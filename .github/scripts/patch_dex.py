#!/usr/bin/env python3
"""
patch_dex.py - Binary dex class replacement

Usage: python3 patch_dex.py original.dex mini_patch.dex output.dex

For each class in mini_patch.dex:
  - If class exists in original.dex → replace it
  - If class is new → add it (classes16 approach)
"""

import sys, struct, hashlib, zlib
from io import BytesIO


def uleb128_read(data, pos):
    result, shift = 0, 0
    while True:
        b = data[pos]; pos += 1
        result |= (b & 0x7F) << shift
        if not (b & 0x80): return result, pos
        shift += 7

def sleb128_read(data, pos):
    result, shift = 0, 0
    while True:
        b = data[pos]; pos += 1
        result |= (b & 0x7F) << shift
        shift += 7
        if not (b & 0x80):
            if b & 0x40: result |= -(1 << shift)
            return result, pos

def uleb128_write(v):
    r = []
    while True:
        b = v & 0x7F; v >>= 7
        r.append(b | (0x80 if v else 0))
        if not v: break
    return bytes(r)

def sleb128_write(v):
    r = []
    more = True
    while more:
        b = v & 0x7F; v >>= 7
        more = not ((v == 0 and not (b & 0x40)) or (v == -1 and (b & 0x40)))
        r.append(b | (0x80 if more else 0))
    return bytes(r)

def align4(n):
    return (n + 3) & ~3


class DexFile:
    def __init__(self, data):
        self.raw = bytearray(data)
        self._parse()

    def u32(self, off): return struct.unpack_from('<I', self.raw, off)[0]
    def u16(self, off): return struct.unpack_from('<H', self.raw, off)[0]
    def u8(self, off):  return self.raw[off]

    def _parse(self):
        d = self.raw
        self.string_ids_size = self.u32(56);  self.string_ids_off = self.u32(60)
        self.type_ids_size   = self.u32(64);  self.type_ids_off   = self.u32(68)
        self.proto_ids_size  = self.u32(72);  self.proto_ids_off  = self.u32(76)
        self.field_ids_size  = self.u32(80);  self.field_ids_off  = self.u32(84)
        self.method_ids_size = self.u32(88);  self.method_ids_off = self.u32(92)
        self.class_defs_size = self.u32(96);  self.class_defs_off = self.u32(100)

        # Strings
        self.strings = []
        for i in range(self.string_ids_size):
            off = self.u32(self.string_ids_off + i * 4)
            _, pos = uleb128_read(d, off)
            end = d.index(0, pos)
            self.strings.append(bytes(d[pos:end]).decode('utf-8', errors='replace'))
        self._str2idx = {s: i for i, s in enumerate(self.strings)}

        # Types
        self.types = []
        for i in range(self.type_ids_size):
            si = self.u32(self.type_ids_off + i * 4)
            self.types.append(self.strings[si])
        self._type2idx = {t: i for i, t in enumerate(self.types)}

        # Protos: (return_type, (param_types...))
        self.protos = []
        for i in range(self.proto_ids_size):
            off = self.proto_ids_off + i * 12
            rt_idx    = self.u32(off + 4)
            params_off = self.u32(off + 8)
            return_type = self.types[rt_idx]
            params = []
            if params_off:
                cnt = self.u32(params_off)
                for j in range(cnt):
                    params.append(self.types[self.u16(params_off + 4 + j * 2)])
            key = (return_type, tuple(params))
            self.protos.append(key)
        self._proto2idx = {p: i for i, p in enumerate(self.protos)}

        # Fields: (class_type, field_type, name)
        self.fields = []
        for i in range(self.field_ids_size):
            off = self.field_ids_off + i * 8
            ci = self.u16(off); ti = self.u16(off+2); ni = self.u32(off+4)
            self.fields.append((self.types[ci], self.types[ti], self.strings[ni]))
        self._field2idx = {f: i for i, f in enumerate(self.fields)}

        # Methods: (class_type, proto_key, name)
        self.methods = []
        for i in range(self.method_ids_size):
            off = self.method_ids_off + i * 8
            ci = self.u16(off); pi = self.u16(off+2); ni = self.u32(off+4)
            self.methods.append((self.types[ci], self.protos[pi], self.strings[ni]))
        self._method2idx = {m: i for i, m in enumerate(self.methods)}

        # Class defs
        self.classes = {}  # type_name -> {'def_off': ..., ...}
        for i in range(self.class_defs_size):
            off = self.class_defs_off + i * 32
            ti = self.u32(off)
            name = self.types[ti]
            self.classes[name] = {
                'def_off': off, 'type_idx': ti,
                'access_flags':    self.u32(off+4),
                'superclass_idx':  self.u32(off+8),
                'interfaces_off':  self.u32(off+12),
                'source_file_idx': self.u32(off+16),
                'annotations_off': self.u32(off+20),
                'class_data_off':  self.u32(off+24),
                'static_values_off': self.u32(off+28),
            }

    # ---- Pool lookup/extend ----

    def get_or_add_string(self, s):
        if s in self._str2idx: return self._str2idx[s]
        idx = len(self.strings); self.strings.append(s); self._str2idx[s] = idx
        return idx

    def get_or_add_type(self, name):
        if name in self._type2idx: return self._type2idx[name]
        si = self.get_or_add_string(name)
        idx = len(self.types); self.types.append(name); self._type2idx[name] = idx
        return idx

    def get_or_add_proto(self, proto_key):
        if proto_key in self._proto2idx: return self._proto2idx[proto_key]
        idx = len(self.protos); self.protos.append(proto_key); self._proto2idx[proto_key] = idx
        return idx

    def get_or_add_field(self, key):
        if key in self._field2idx: return self._field2idx[key]
        idx = len(self.fields); self.fields.append(key); self._field2idx[key] = idx
        return idx

    def get_or_add_method(self, key):
        if key in self._method2idx: return self._method2idx[key]
        idx = len(self.methods); self.methods.append(key); self._method2idx[key] = idx
        return idx


def build_index_map(patch, orig):
    """Build maps from patch pool index -> orig pool index."""
    str_map   = [orig.get_or_add_string(s) for s in patch.strings]
    type_map  = [orig.get_or_add_type(t)   for t in patch.types]
    proto_map = [orig.get_or_add_proto(patch.protos[i]) for i in range(len(patch.protos))]
    field_map = []
    for (ct, ft, n) in patch.fields:
        key = (orig.types[type_map[patch._type2idx[ct]]],
               orig.types[type_map[patch._type2idx[ft]]],
               patch.strings[patch._str2idx[n]])
        field_map.append(orig.get_or_add_field(key))
    method_map = []
    for (ct, proto_key, n) in patch.methods:
        new_proto = (orig.types[type_map[patch._type2idx[proto_key[0]]]],
                     tuple(orig.types[type_map[patch._type2idx[p]]] for p in proto_key[1]))
        key = (orig.types[type_map[patch._type2idx[ct]]],
               new_proto,
               patch.strings[patch._str2idx[n]])
        method_map.append(orig.get_or_add_method(key))
    return str_map, type_map, field_map, method_map


# --- Instruction remapping ---
INSN_TABLE = {}
# Format21c: 2 u16 units, ref in unit[1]
for op, rt in [(0x1a,'s'), (0x1c,'t'), (0x1f,'t'), (0x22,'t')]:
    INSN_TABLE[op] = (2, 1, 16, rt)
# const-string/jumbo (32-bit ref)
INSN_TABLE[0x1b] = (3, 1, 32, 's')
# Format22c: instance-of, new-array
for op, rt in [(0x20,'t'), (0x23,'t')]:
    INSN_TABLE[op] = (2, 1, 16, rt)
# iget/iput variants (0x52-0x5f): field
for op in range(0x52, 0x60):
    INSN_TABLE[op] = (2, 1, 16, 'f')
# sget/sput variants (0x60-0x6d): field
for op in range(0x60, 0x6e):
    INSN_TABLE[op] = (2, 1, 16, 'f')
# Format35c: filled-new-array, invoke-*
for op, rt in [(0x24,'t'), (0x6e,'m'), (0x6f,'m'), (0x70,'m'), (0x71,'m'), (0x72,'m')]:
    INSN_TABLE[op] = (3, 1, 16, rt)
# Format3rc
for op, rt in [(0x25,'t'), (0x74,'m'), (0x75,'m'), (0x76,'m'), (0x77,'m'), (0x78,'m')]:
    INSN_TABLE[op] = (3, 1, 16, rt)


def remap_insns(insns_bytes, str_map, type_map, field_map, method_map):
    import collections
    data = bytearray(insns_bytes)
    pos = 0
    n = len(data) // 2
    trace = collections.deque(maxlen=40)

    def get_u16(p): return struct.unpack_from('<H', data, p * 2)[0]
    def put_u16(p, v): struct.pack_into('<H', data, p * 2, v & 0xFFFF)
    def get_u32(p): return struct.unpack_from('<I', data, p * 2)[0]
    def put_u32(p, v): struct.pack_into('<I', data, p * 2, v & 0xFFFFFFFF)

    while pos < n:
        opcode = data[pos * 2]
        high   = data[pos * 2 + 1]

        if opcode == 0x00:
            if high == 0x01:
                sz = get_u16(pos + 1)
                step = 4 + sz * 2
                trace.append((pos, opcode, high, step))
                pos += step; continue
            elif high == 0x02:
                sz = get_u16(pos + 1)
                step = 2 + sz * 4
                trace.append((pos, opcode, high, step))
                pos += step; continue
            elif high == 0x03:
                elem_width = get_u16(pos + 1)
                sz = get_u32(pos + 2)
                step = 4 + (elem_width * sz + 1) // 2
                trace.append((pos, opcode, high, step))
                pos += step; continue
            else:
                trace.append((pos, opcode, high, 1))
                pos += 1; continue

        info = INSN_TABLE.get(opcode)
        if info:
            insn_sz, ref_pos, ref_bits, ref_type = info
            if ref_bits == 16:
                old_idx = get_u16(pos + ref_pos)
                try:
                    if ref_type == 's':   new_idx = str_map[old_idx]
                    elif ref_type == 't': new_idx = type_map[old_idx]
                    elif ref_type == 'f': new_idx = field_map[old_idx]
                    else:                 new_idx = method_map[old_idx]
                except IndexError:
                    pool_sizes = {'s': len(str_map), 't': len(type_map),
                                  'f': len(field_map), 'm': len(method_map)}
                    print(f"  ERROR: {ref_type} idx {old_idx} >= pool size {pool_sizes[ref_type]} "
                          f"at insn pos {pos} (opcode=0x{opcode:02x} hi=0x{high:02x})", flush=True)
                    print(f"  Last {len(trace)} instructions:", flush=True)
                    for t in trace:
                        print(f"    pos={t[0]:5d} op=0x{t[1]:02x} hi=0x{t[2]:02x} step={t[3]}", flush=True)
                    raise
                trace.append((pos, opcode, high, insn_sz))
                put_u16(pos + ref_pos, new_idx)
            else:
                old_idx = get_u32(pos + ref_pos)
                new_idx = str_map[old_idx]
                trace.append((pos, opcode, high, insn_sz))
                put_u32(pos + ref_pos, new_idx)
            pos += insn_sz
        else:
            sz = _insn_size(data, pos, n)
            trace.append((pos, opcode, high, sz))
            pos += sz

    return bytes(data)


def _insn_size(data, pos, n):
    """Return instruction size in u16 units using complete Dalvik opcode table."""
    opcode = data[pos * 2]
    # 1-unit instructions (10x, 12x, 11n, 11x, 10t formats)
    if opcode in (0x00,
                  0x01, 0x04, 0x07,
                  0x0a, 0x0b, 0x0c, 0x0d,
                  0x0e, 0x0f, 0x10, 0x11,
                  0x12,                          # const/4 (11n)
                  0x1d, 0x1e,
                  0x21,
                  0x27, 0x28):
        return 1
    if 0x7b <= opcode <= 0x8f: return 1          # unary ops (12x)
    if 0xb0 <= opcode <= 0xcf: return 1          # binary/2addr ops (12x)
    # 2-unit instructions
    if opcode in (0x02, 0x05, 0x08,
                  0x13, 0x15, 0x16, 0x19,
                  0x29):
        return 2
    if 0x2d <= opcode <= 0x3d: return 2
    if 0x44 <= opcode <= 0x51: return 2
    if 0x90 <= opcode <= 0xaf: return 2
    if 0xd0 <= opcode <= 0xe2: return 2
    # 3-unit instructions
    if opcode in (0x03, 0x06, 0x09,
                  0x14, 0x17,
                  0x26, 0x2a, 0x2b, 0x2c):
        return 3
    # 5-unit instructions
    if opcode == 0x18: return 5                  # const-wide (51l)
    return 2  # safe default


def read_class_data(dex, class_data_off):
    if class_data_off == 0:
        return {'static_fields': [], 'instance_fields': [], 'direct_methods': [], 'virtual_methods': []}

    d = dex.raw; pos = class_data_off
    sf_size, pos = uleb128_read(d, pos)
    if_size, pos = uleb128_read(d, pos)
    dm_size, pos = uleb128_read(d, pos)
    vm_size, pos = uleb128_read(d, pos)

    def read_fields(cnt):
        nonlocal pos
        items = []; last_idx = 0
        for _ in range(cnt):
            diff, pos = uleb128_read(d, pos)
            af, pos   = uleb128_read(d, pos)
            last_idx += diff
            items.append({'field_idx': last_idx, 'access_flags': af})
        return items

    def read_methods(cnt):
        nonlocal pos
        items = []; last_idx = 0
        for _ in range(cnt):
            diff, pos = uleb128_read(d, pos)
            af, pos   = uleb128_read(d, pos)
            co, pos   = uleb128_read(d, pos)
            last_idx += diff
            items.append({'method_idx': last_idx, 'access_flags': af, 'code_off': co})
        return items

    return {
        'static_fields':   read_fields(sf_size),
        'instance_fields': read_fields(if_size),
        'direct_methods':  read_methods(dm_size),
        'virtual_methods': read_methods(vm_size),
        'end_pos': pos,
    }


def read_code_item(dex, code_off):
    if code_off == 0: return b''
    d = dex.raw
    tries_size = struct.unpack_from('<H', d, code_off + 6)[0]
    insns_size = struct.unpack_from('<I', d, code_off + 12)[0]  # +12, NOT +8 (+8 is debug_info_off)
    end = code_off + 16 + insns_size * 2

    if tries_size > 0:
        if (insns_size % 2) != 0: end += 2
        end += tries_size * 8
        n_handlers, pos = uleb128_read(d, end)
        end = pos
        for _ in range(n_handlers):
            sz, end = sleb128_read(d, end)
            abs_sz = abs(sz)
            for _ in range(abs_sz):
                _, end = uleb128_read(d, end)
                _, end = uleb128_read(d, end)
            if sz <= 0:
                _, end = uleb128_read(d, end)

    return bytes(d[code_off:end])


def remap_code_item(code_bytes, str_map, type_map, field_map, method_map):
    if not code_bytes: return b''
    data = bytearray(code_bytes)
    insns_size = struct.unpack_from('<I', data, 12)[0]  # +12, NOT +8 (+8 is debug_info_off)
    insns = bytearray(data[16:16 + insns_size * 2])
    remapped = remap_insns(insns, str_map, type_map, field_map, method_map)
    data[16:16 + insns_size * 2] = remapped
    return bytes(data)


def patch_dex_simple(orig_data, patch_data):
    orig = DexFile(orig_data)
    patch = DexFile(patch_data)

    # Fast-check: if none of the patch classes exist in the original, skip entirely
    if not any(cn in orig.classes for cn in patch.classes):
        for cn in patch.classes:
            print(f"  WARNING: {cn} not in original dex, skipping")
        return orig_data

    str_map, type_map, field_map, method_map = build_index_map(patch, orig)

    new_strings = orig.strings[orig.string_ids_size:]
    new_types   = orig.types[orig.type_ids_size:]
    new_methods = orig.methods[orig.method_ids_size:]

    pools_extended = bool(new_strings or new_types or new_methods)

    patch_results = []
    for class_name, pcd in patch.classes.items():
        cdata = read_class_data(patch, pcd['class_data_off'])

        def remap_methods(methods):
            return [{'method_idx': method_map[m['method_idx']],
                     'access_flags': m['access_flags'],
                     'code_off': m['code_off']} for m in methods]
        def remap_fields(fields):
            return [{'field_idx': field_map[f['field_idx']],
                     'access_flags': f['access_flags']} for f in fields]

        remapped_cdata = {
            'static_fields':   remap_fields(cdata['static_fields']),
            'instance_fields': remap_fields(cdata['instance_fields']),
            'direct_methods':  remap_methods(cdata['direct_methods']),
            'virtual_methods': remap_methods(cdata['virtual_methods']),
        }

        code_map = {}
        for section in ['direct_methods', 'virtual_methods']:
            orig_methods = cdata[section]
            for m in orig_methods:
                if m['code_off']:
                    code_bytes = read_code_item(patch, m['code_off'])
                    remapped = remap_code_item(code_bytes, str_map, type_map, field_map, method_map)
                    code_map[method_map[m['method_idx']]] = remapped

        patch_results.append((class_name, remapped_cdata, code_map))

    if pools_extended:
        if new_types or new_methods:
            print("WARNING: New types/methods needed — attempting pool extension.")
        return append_before_map(orig, orig_data, patch_results)
    else:
        return append_before_map(orig, orig_data, patch_results)


def append_before_map(orig, orig_data, patch_results):
    """Replace class data by inserting new items BEFORE the MAP_LIST.
    This ensures new code_items and class_data_items fall within the data
    section range that ART's DEX verifier accepts."""
    orig_buf = bytearray(orig_data)
    map_off = struct.unpack_from('<I', orig_buf, 0x34)[0]

    # Build all new code items and class data in a buffer to be inserted at map_off
    insert = bytearray()

    def pad4():
        while (map_off + len(insert)) % 4:
            insert.append(0)

    replacements = {}  # class_name -> new_cdata_off

    for class_name, cdata, code_map in patch_results:
        if class_name not in orig.classes:
            print(f"  WARNING: {class_name} not in original dex, skipping")
            continue

        # Write code items first
        new_code_offs = {}
        for orig_midx, code_bytes in code_map.items():
            if code_bytes:
                pad4()
                new_code_offs[orig_midx] = map_off + len(insert)
                insert.extend(code_bytes)

        # Write class_data_item
        pad4()
        new_cdata_off = map_off + len(insert)
        replacements[class_name] = new_cdata_off

        def write_uleb(v): insert.extend(uleb128_write(v))

        def write_fields(fields):
            write_uleb(len(fields))
            last = 0
            for f in sorted(fields, key=lambda x: x['field_idx']):
                write_uleb(f['field_idx'] - last)
                write_uleb(f['access_flags'])
                last = f['field_idx']

        def write_methods(methods):
            write_uleb(len(methods))
            last = 0
            for m in sorted(methods, key=lambda x: x['method_idx']):
                write_uleb(m['method_idx'] - last)
                write_uleb(m['access_flags'])
                write_uleb(new_code_offs.get(m['method_idx'], 0))
                last = m['method_idx']

        write_fields(cdata['static_fields'])
        write_fields(cdata['instance_fields'])
        write_methods(cdata['direct_methods'])
        write_methods(cdata['virtual_methods'])

        print(f"  Replaced: {class_name}")

    if not replacements:
        struct.pack_into('<I', orig_buf, 32, len(orig_buf))
        return fix_checksum(bytes(orig_buf))

    # Insert new items just before the MAP_LIST
    delta = len(insert)
    buf = bytearray(orig_buf[:map_off]) + insert + bytearray(orig_buf[map_off:])

    # Update map_off in header
    new_map_off = map_off + delta
    struct.pack_into('<I', buf, 0x34, new_map_off)

    # Update the TYPE_MAP_LIST (0x1000) entry's offset field to point to new map location
    map_size = struct.unpack_from('<I', buf, new_map_off)[0]
    for i in range(map_size):
        eoff = new_map_off + 4 + i * 12
        itype = struct.unpack_from('<H', buf, eoff)[0]
        if itype == 0x1000:  # TYPE_MAP_LIST
            struct.pack_into('<I', buf, eoff + 8, new_map_off)
            break

    # Update class_def.class_data_off for each replaced class
    for class_name, new_cdata_off in replacements.items():
        def_off = orig.classes[class_name]['def_off']
        struct.pack_into('<I', buf, def_off + 24, new_cdata_off)

    struct.pack_into('<I', buf, 32, len(buf))
    return fix_checksum(bytes(buf))


def fix_checksum(data):
    buf = bytearray(data)
    sha1 = hashlib.sha1(buf[32:]).digest()
    buf[12:32] = sha1
    adler = zlib.adler32(bytes(buf[12:])) & 0xFFFFFFFF
    struct.pack_into('<I', buf, 8, adler)
    return bytes(buf)


def main():
    if len(sys.argv) != 4:
        print("Usage: patch_dex.py original.dex mini_patch.dex output.dex")
        sys.exit(1)

    orig_path, patch_path, out_path = sys.argv[1], sys.argv[2], sys.argv[3]

    with open(orig_path, 'rb') as f: orig_data = f.read()
    with open(patch_path, 'rb') as f: patch_data = f.read()

    print(f"Patching {orig_path} with {patch_path}...")
    result = patch_dex_simple(orig_data, patch_data)

    with open(out_path, 'wb') as f: f.write(result)
    print(f"Written: {out_path} ({len(result)} bytes)")


if __name__ == '__main__':
    main()
