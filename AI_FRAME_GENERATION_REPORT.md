# AI Frame Generation in BannerHub — Technical Report

**Status:** CONFIRMED WORKING (2026-05-08 20:30) — ~1.8–1.9× FPS scaling on a 2× multiplier, verified via FPS overlay screenshots on Adreno 750 (AYANEO Pocket FIT, God of War / Steam ID 1593500).

**Shipping in:** v3.7.0-pre1 (merged 2026-05-08 as commit `9d4a594`) and v3.7.0-pre2 (2026-05-09), pre-release artifact-only per pre-release policy.

---

## 1. What this is, in plain English

Modern games run at a "real" frame rate — say, 40 frames per second. **AI Frame Generation** invents extra frames *between* the real ones to make the picture look smoother. If the game renders 40 FPS, the technique can fill in synthetic in-between frames so your eyes see ~80 FPS of motion. The game itself doesn't have to work any harder; the GPU just paints additional "tween" frames on the way to the screen.

The trick: how do you invent a believable in-between frame? The system looks at two real frames in sequence and computes **optical flow** — a per-pixel map of "this pixel moved from here to there." With that motion map, the GPU can warp the older frame partway toward the newer one and produce a synthetic middle frame. Do this every render cycle and you've doubled (or tripled) the perceived smoothness.

NVIDIA does this on PCs as **DLSS Frame Generation**, using dedicated optical-flow accelerators on RTX 40-series cards. The clever bit on Android is that **the same trick works on a Qualcomm Adreno phone GPU** — not because Adreno has a dedicated optical-flow chip, but because the open-source Mesa "Turnip" driver fork that BannerHub ships re-implements NVIDIA's `VK_NV_optical_flow` Vulkan extension as plain compute shaders running on the GPU's existing image-processing units.

So end-to-end: the game thinks it's drawing normal frames into a normal swapchain, but a shim driver (`libGameScopeVK.so`) intercepts every frame, computes optical flow against the previous frame, and inserts AI-warped intermediate frames before sending pixels to the display. The game never knows. The user sees ~2× the smoothness for ~10–20% extra GPU cost.

### The simple version of the stack

```
Game (Windows .exe under Wine/DXVK)
         │
         ▼
libGameScopeVK.so  ← "fake" Vulkan driver — intercepts frames here
         │
         ▼
libvulkan_freedreno.so (Mesa Turnip with VK_NV_optical_flow)  ← real Adreno driver
         │
         ▼
GPU  →  display
```

`libGameScopeVK.so` is the "magic in the middle." Everything else is plumbing.

---

## 2. The discovery — why this turned out to be tractable

The **original porting plan** assumed four big pieces of work:
1. Modify firmware to bundle the AI library
2. Rebuild Mesa Turnip with optical-flow support
3. Wire up the Vulkan ICD chain
4. Build the UI

**Reality check (2026-05-08):** firmware 1.3.6 already shipped *everything* — the AI library, the modified Turnip driver, the config files. BannerHub was already creating `gamescope.control` on every game launch. It just had the **enabled byte set to 0**, the multiplier slot empty, and the ICD JSON pointing at a hardcoded placeholder path that was broken on every install.

The actual fix collapsed to **two file edits at runtime**:
- Flip the right bytes in `gamescope.control`
- Rewrite the `library_path` in `GameScopeVK_icd.json` to the current package's actual file location

That's it. No firmware bundling, no Turnip rebuild, no native code shipped in our APK.

---

## 3. `libGameScopeVK.so` — the AI shim

### 3.1 What it is

A **Vulkan ICD (Installable Client Driver) shim**. Originally from Tencent's GameHub 6.0.1 firmware (1.3.6 AI build). It ships *inside the imagefs* — i.e., bundled into the container's root filesystem, not in our APK.

| Property | Value |
|---|---|
| Path on device | `/data/data/<pkg>/files/usr/lib/libGameScopeVK.so` |
| Size (1.3.6 AI build) | 2,218,904 bytes (`-16 B` vs 1.3.5 — different MD5, same Vulkan API version) |
| Architecture | ARM64 ELF, NDK r28-beta1 |
| Internal name | `GameScopeVK` |
| Build origin (DWARF leak) | `/Users/me/Documents/GameScopeVK/gamescope/...` (someone's macOS dev tree, home dir literally `me`) |
| Vulkan ICD API version | 1.3.216 |

It is **not** Valve's gamescope despite the name — it's Tencent's reimplementation that hijacks the same UX terminology.

### 3.2 Position in the Vulkan stack

It chains in front of the real GPU driver via the Vulkan loader's ICD chain. Exports the standard ICD entry points:
- `vk_icdGetInstanceProcAddr`
- `vk_icdGetPhysicalDeviceProcAddr`
- `vk_icdNegotiateLoaderICDInterfaceVersion`

The Vulkan loader sees `libGameScopeVK.so` advertised in the ICD JSON, loads it as the "primary" Vulkan driver, and lets it intercept every Vulkan call from the game.

### 3.3 What it actually does internally

From a strings dump of the binary, plus DWARF symbol names:

**Source files referenced:**
- `direct_rendering_client.cpp`
- `gamescope.cpp`
- `gamescope_shader.cpp`
- `gamescope_swapchain.cpp`
- `vulkan_dispatch.cpp`

**Embedded class names:**
- `gamescope::FPSCounter`
- `gamescope::FPSCallback`
- `gamescope::FPSCounterWithCallback`
- `gamescope::Swapchain`

**Pipeline:**
1. Hooks `vkCreateInstance` and registers itself between game and driver
2. Detects the rendering engine (`wellknown engine DXVK detected` in logs)
3. Wraps the game's swapchain creation
4. On every frame submit:
   - Computes optical flow via `vkCreateOpticalFlowSessionNV` + related entry points
   - Decodes AI weights from BCN-compressed textures
   - Runs compute pipelines named `delta5`, `delta6`, `gamma1`
   - Synthesizes intermediate frames using the warmed-up backend
5. Loads an "HMI" asset (some kind of model/init blob)
6. Manages temporal images and scratch buffers across frames

**Linked dependencies (ELF NEEDED):** only standard system libs — `libandroid`, `liblog`, `libEGL`, `libGLESv2`, `libGLESv3`, `libX11`, `libX11-xcb`, `libxcb`, `libxcb-dri3`, `libxcb-present`, `libvulkan`, `libm`, `libdl`, `libc`. **NO ML inference framework** — no NCNN, no ONNX Runtime, no TensorFlow Lite. All "AI" is implemented as Vulkan compute shaders embedded inside `libGameScopeVK.so` itself, leveraging `VK_NV_optical_flow` for hardware-accelerated motion estimation.

### 3.4 Environment variables it consumes

| Variable | Purpose |
|---|---|
| `GAMESCOPE_CONTROL_PATH` | Path to the 10-byte `gamescope.control` mmap (overrides default location) |
| `GAMESCOPE_DRIVER_PATH` | Real Vulkan ICD to chain to (the underlying GPU driver) |
| `GAMESCOPE_DEVICE_MEMORY_LIMIT` | Memory-cap override |
| `GAMESCOPE_DUMP_FAILURES` | Diagnostic dump toggle — writes failure info to file |
| `GAMESCOPE_SURFACE_USING_BGRA` | Pixel-format hint |

### 3.5 Diagnostic strings (logged with Android tag `gamescope`, lowercase)

Success path:
- `Frame interpolation backend created`
- `GameScope control enabled`
- `wellknown engine DXVK detected`

Failure modes:
- `Frame interpolation backend creation failed`
- `Frame interpolation execution failed: {}`
- `Frame interpolation warmup failed: {}`
- `begin warmup command buffer failed`
- `warmup ingest failed`
- `warmup submit failed`
- `invalid warmup input`
- `Failed to open control file: {}`
- `Failed to load HMI: {}`
- `Failed to create BCN decoder: {}`
- `Failed to decode BCN texture: {}`
- `ensure temporal images failed`
- `temporal create scratch failed`
- `Compute pipeline creation failed`
- `Compute pipeline failure info dumped to {}` (when `GAMESCOPE_DUMP_FAILURES=1`)
- `GameScopeVK: [BYPASS_XSERVER] Status changed: {}`

---

## 4. `GameScopeVK_icd.json` — registering the shim

The Vulkan loader on Android scans `usr/home/steamuser/.config/vulkan/icd.d/` for ICD JSON manifests. The relevant file:

```json
{
  "file_format_version": "1.0.0",
  "ICD": {
    "library_path": "/data/data/com.tencent.ig/files/usr/lib/libGameScopeVK.so",
    "api_version": "1.3.216"
  }
}
```

**The upstream-shipped placeholder problem:** GameHub 6.0.1 ships this file with `library_path` hardcoded to `/data/data/com.winemu/files/usr/lib/libGameScopeVK.so` — a path that doesn't exist on any user's device because nobody actually installs the standalone `com.winemu` runtime APK that XiaoJi maintains separately. Master map § 26.8.5 calls this out as either an install-time placeholder or an artifact from XiaoJi's separate runtime.

**Our fix (commit `7af2a70` on `feature/framegen-menu`):** `BhFrameGenWriter.ensureIcdJsonForCurrentPackage(ctx)`:
- Resolves `library_path` to `/data/data/${ctx.getPackageName()}/files/usr/lib/libGameScopeVK.so` at runtime
- Creates the parent dir `.../usr/home/steamuser/.config/vulkan/icd.d/` if missing
- Idempotent — skips write when JSON already matches
- Aborts silently if `libGameScopeVK.so` doesn't exist on disk
- Called from `applyFromPrefs(ctx)`, which already runs at every container launch via the smali hook in `WineActivity.onCreate()` (line 6052)

**Why this works for renamed APKs:** `Context.getPackageName()` returns whatever the currently-installed APK's `AndroidManifest` declares as `package=`. So if a user (or downstream fork) re-signs the APK with a different package name (apktool / APK Editor), the ICD JSON write at launch tracks the new name automatically. **Device-tested 2026-05-08** with a manually-renamed package — passed.

---

## 5. `gamescope.control` — the 10-byte runtime IPC

A memory-mapped file at `<wineprefix>/etc/gamescope.control`. The Java/Kotlin side writes bytes; `libGameScopeVK.so` reads them on every frame. Wrapper class on the GameHub side: `defpackage.ca2`.

### 5.1 Buffer layout (10 bytes, little-endian)

| Offset | Size | Field | Initial | Notes |
|---|---|---|---|---|
| 0–1 | 2 B | uint16 reserved / FPS limit | 0 | `putShort((short) 0)` in ctor |
| 2 | 1 B | **enabled flag** | 0 | **THIS IS THE TOGGLE** — 0=off, 1=on |
| 3 | 1 B | NativeRenderingMode | 0 (Auto) | 0=Auto, 1=Never, 2=Always — pre-existing slot |
| 4–7 | 4 B | **AI flowScale float** | 0.6 | Clamped 0.2–1.0 via `br5.x()` |
| 8 | 1 B | **AI model byte** | 0 | 0=standard, 1=clear/extreme |
| 9 | 1 B | **AI multiplier byte** | 2 | Clamped 2–4 via `br5.y()` |

Created via `RandomAccessFile("rw")` + `channel.map(READ_WRITE, 0, 10)`. Each write is followed by `MappedByteBuffer.force()` to flush to disk-backed mmap.

### 5.2 Final byte sequence for the working state

For Clear preset / 2× multiplier / flowScale 0.5:

```
00 00 01 00 00 00 00 3F 00 02
```

Decoded:
- `[0-1]` = 0x0000 → FPS limit off
- `[2]`   = 0x01 → enabled
- `[3]`   = 0x00 → NativeRender=Auto
- `[4-7]` = 0x3F000000 LE = float 0.5 → flowScale 0.5
- `[8]`   = 0x00 → standard model
- `[9]`   = 0x02 → 2× multiplier

### 5.3 The `multiplier=1` quirk (master map § 26.8.4)

The Kotlin enum's `Extreme` mode declares `multiplier=1`, but the IPC writer (`sz4.a()`) clamps to `[2..4]` — so the byte at offset 9 is always 2-4 inclusive. **`Extreme`'s multiplier=1 is silently coerced to 2 at the IPC layer.** This means the `multiplier` field in the enum is *not* the literal frame multiplier — it's a model-variant tag the UI uses to differentiate Clear (`mult=2`) from Extreme (`mult=1`) presets while both run at 2× compositor multiplication.

Practical takeaway: multiplier=3 and 4 are documented in the protocol but not yet observed working in our tests. Stick to 2× for verified results.

### 5.4 The launcher-regenerator gotcha

**Key behavior we discovered the hard way:** BannerHub's launcher REGENERATES `gamescope.control` on each game launch based on UI state. After our 18:12 manual mmap patch on 2026-05-08, the file came back with bytes 2 and 3 swapped (enabled→0, NativeRender→1). We re-patched at 18:19 *while the game was running* and the mmap-shared file was picked up live (confirmed by `GameScope control enabled` appearing right after).

**This is why the smali hook matters.** The framegen-menu writes via `applyFromPrefsNoContext()` from `EnvironmentController.smali` — the launcher regenerator runs first, then our hook re-applies the correct bytes from SharedPrefs. Without that ordering, every container launch would clobber framegen back to off.

---

## 6. The `VK_NV_optical_flow` ↔ Adreno bridge (master map § 26.8.6)

> **For the full driver-nerd writeup see `gamehub_reports/VK_NV_OPTICAL_FLOW_ON_ADRENO.md`.** This section is the summary version.

`VK_NV_optical_flow` is **not a hardware lock — it's a Vulkan extension specification.** Anyone whose driver can answer `vkCreateOpticalFlowSessionNV` and friends can advertise it. NVIDIA designed the spec around their RTX 40-series fixed-function Optical Flow Accelerator (OFA), but XiaoJi's Mesa Turnip fork (`libvulkan_freedreno.so`, also bundled in the imagefs — 13 MB, NDK r29, Android 34) reimplements the same ABI as **plain Vulkan compute shaders** on Adreno's regular shader cores.

### 6.1 Confirmed by symbol presence in `libvulkan_freedreno.so`

C++ template instantiations for **three Adreno chip families**:

```
tu_CreateOpticalFlowSessionNV<chip 6>          Adreno 6xx (S855/S865/S888 — A640/650/660/680)
tu_CreateOpticalFlowSessionNV<chip 7>          Adreno 7xx (S8 Gen 2/3 — A730/740/750)   ← our verified device
tu_CreateOpticalFlowSessionNV<chip 8>          Adreno 8xx / Adreno X1 (S8 Elite, X Elite)
tu_DestroyOpticalFlowSessionNV<chip 6/7/8>
tu_BindOpticalFlowSessionImageNV<chip 6/7/8>
tu_CmdOpticalFlowExecuteNV<chip 6/7/8>
```

Plus the spec's struct-type strings (`VkPhysicalDeviceOpticalFlowFeaturesNV`, `VK_STRUCTURE_TYPE_OPTICAL_FLOW_SESSION_CREATE_INFO_NV`, etc.) and the Vulkan loader-facing entry points (`vkCreateOpticalFlowSessionNV`, `vkCmdOpticalFlowExecuteNV`, `vkGetPhysicalDeviceOpticalFlowImageFormatsNV`, …) — i.e. Turnip advertises the extension via `vkEnumerateDeviceExtensionProperties` and exposes the feature struct via `vkGetPhysicalDeviceFeatures2`. From the application's perspective the device looks identical to an RTX 40-series.

### 6.2 The per-chip dispatch is not cosmetic

The `IL4chip{6,7,8}EE` template parameter is Mesa's standard "compile this function separately per Adreno generation" pattern. Generations vary in wave width, FP16 dot-product accumulator widths, texture-gather ISA, and image-store coherency rules — so each chip gets its own ISA generator path. `tu_physical_device->info->chip` indexes into the right specialisation at session-create time. **One Turnip build covers Adreno 6xx through Adreno X1.**

### 6.3 What `libGameScopeVK` is actually doing with it

`libGameScopeVK.so` is a **Vulkan ICD shim** (NEEDED list: only `libvulkan`, `libandroid`, `liblog`, `libEGL`, `libGLES*`, `libX11*`, `libxcb*`, `libm/dl/c` — **no NCNN/ONNX/TFLite/CUDA**). On init it `dlopen`s whatever path is in `GAMESCOPE_DRIVER_PATH` and forwards device-level Vulkan calls. On `vkQueuePresentKHR` it:

1. Calls `vkCmdOpticalFlowExecuteNV` against the chained driver to compute motion vectors between frames N-1 and N.
2. Dispatches its embedded inference network — visible as compute pipeline names in the binary's strings: `delta0..delta9` (10 stages) + `gamma0..gamma4` and `gamma23` (likely a fused 2/3 stage) — consuming the OF vectors as one input alongside the two reference frames.
3. Blits the synthetic mid-frame into the swapchain before forwarding Present.

The `delta`/`gamma` weights load via a "warmup" pass at first use (`warmup ingest failed`, `warmup submit failed` are the failure strings; weights are likely BCN-compressed textures decoded into SSBOs).

### 6.4 Critical implication for users

AI frame-gen requires **both** halves of the chain:

- An imagefs that ships a frame-gen-capable `libGameScopeVK.so` (1.3.5+, ~2.2 MB; pre-1.3.5 ships a 950 KB stub with no AI codepath)
- A Vulkan ICD that advertises `VK_NV_optical_flow` — i.e. XiaoJi's bundled Turnip fork or another Turnip build with the OF feature flag enabled

Devices on stock vendor Vulkan drivers (Qualcomm / ARM / PowerVR) **won't** advertise `VK_NV_optical_flow`. The "Custom GPU driver" toggle in PC Game Settings must be ON, pointing at a Turnip variant with the chip-6/7/8 symbols. We confirmed `Turnip_v26.2.0_R3` exposes the symbols for our 2026-05-08 successful run.

### 6.5 Why this isn't "hacking around" the extension

It's the opposite — Mesa **legitimately implements** the extension. Vulkan extension names are namespaced (`KHR`/`EXT`/`<vendor>`) by *who proposed* the spec, but the ABI is open. Any vendor's driver can answer the same entrypoints and advertise support. NVIDIA shipped the dedicated silicon; Mesa shipped a pure-compute reimplementation; the Vulkan loader and the consuming application can't tell the difference at the API layer. The performance is different (~10–20% extra GPU cost on Adreno vs near-free on RTX OFA), but the contract is identical.

---

## 7. Per-GPU capability gating (master map § 26.8.9)

**There is no client-side gate in the APK.** A search of `com.xiaoji.egggame.*` finds zero GPU-vendor / device-model / Vulkan-extension checks on `AiFrameInterpolation`. The release-note phrasing "AI frame generation now supported across all games" means **no per-game allowlist** — it does NOT mean every device can use it.

The runtime gate is **silent**, inside `libGameScopeVK.so`: if `VK_NV_optical_flow` isn't available on the device's loaded Vulkan ICD chain, the swapchain interpolation backend creation fails with `Frame interpolation backend creation failed` (logged via `liblog`) and the swapchain falls back to passthrough. **Frame-gen no-ops without any user-visible error.** Users will simply see no FPS doubling and no toast / dialog explaining why.

Verification recipe for any given device:
1. `getlog -f <pkg>` while launching a game with framegen on
2. Grep for `Frame interpolation backend created` (success) vs `Frame interpolation backend creation failed` (no `VK_NV_optical_flow`)

---

## 8. Java/Kotlin data model (master map § 26.8.1)

The GameHub-side classes (kept by R8 because kotlinx-serializable):

```
com.xiaoji.egggame.common.winemu.bean.AiFrameInterpolation
  └─ field: AiFrameInterpolationMode mode      // single field; default = Disabled

com.xiaoji.egggame.common.winemu.bean.AiFrameInterpolationMode (enum, 7 values)
  ├─ Disabled  (model=0, multiplier=2, flowScale=0.6, enabled=false)  ← off state
  ├─ Fast      (model=0, multiplier=2, flowScale=0.2, enabled=true)
  ├─ Smooth    (model=0, multiplier=2, flowScale=0.4, enabled=true)
  ├─ Balanced  (model=0, multiplier=2, flowScale=0.6, enabled=true)   ← default-on
  ├─ Enhanced  (model=0, multiplier=2, flowScale=0.8, enabled=true)
  ├─ Clear     (model=1, multiplier=2, flowScale=0.6, enabled=true)   ← model 1
  └─ Extreme   (model=1, multiplier=1, flowScale=0.8, enabled=true)   ← model 1, mult=1 (label-only)
```

`Companion.defaultEnabled = Balanced`.

### 8.1 Persistence — `WineInGameSettingType`

```
WineInGameSettingType.AiFrameInterpolation
  ├─ key   = "AiFrameInterpolation"
  ├─ scope = WineSettingScope.Game        (per-game / per-container)
  └─ codec = WineSettingCodec.Json(AiFrameInterpolation.class)
```

Stored via `p0o.x(WineInGameSettingType, value)` → MMKV under the variant package's MMKV root.

### 8.2 Action / state classes

| Class | Role |
|---|---|
| `defpackage.r1o` | `UpdateAiFrameInterpolationMode(mode)` — UI/store action (user picked a mode) |
| `defpackage.e3o` | `ApplyAiFrameInterpolationMode(mode)` — service action (commit to mmap) |
| `defpackage.sz4.a(...)` | Actual mmap writer (3-step: model byte + flowScale float + multiplier byte + force) |
| `defpackage.ie9` | `ysj` adapter — receives `e4o` actions, fans out to setting-specific handlers |
| `defpackage.wzn` | `xc1` ViewModel — holds Wine activity state including current AI mode |
| `defpackage.g1j` | Slider position picker (maps slider float → AiFrameInterpolationMode by index) |
| `defpackage.m5o` | Static `int[]` ordinal-index dispatch tables for all 7 enum values |
| `defpackage.y1m` | Polymorphic invoke lambda — handles default fallback to `Disabled` |

---

## 9. UI surface — what users see (master map § 26.8.7)

User-facing strings (`res/values-en/strings.xml`):

| String key | English |
|---|---|
| `ai_frame_interpolation_plus` | "AI Frame Generation" (top-level title) |
| `ai_frame_interpolation_header` | "Frame Generation" (section header) |
| `winemu_sidebar_ai_frame_interpolation_enable` | "Enable frame generation" |
| `winemu_sidebar_ai_frame_interpolation_preset` | "Preset" |
| `ai_frame_interpolation_mode_fast` | "Power Saving" |
| `ai_frame_interpolation_mode_smooth` | "Smooth mode" |
| `ai_frame_interpolation_mode_balanced` | "Balanced mode" |
| `ai_frame_interpolation_mode_enhanced` | "Enhanced mode" |
| `ai_frame_interpolation_mode_clear` | "Clear mode" |
| `ai_frame_interpolation_mode_extreme` | "Extreme mode" |
| `ai_frame_interpolation_label_*` | Slider pills: Eco · Flow · Bal · Boost · Clear · Max |

Per-mode descriptions (paraphrased):
- **Disabled**: "Frame rate and power usage will not be changed."
- **Fast (Eco)**: "Lowest overhead, suitable for lower-end devices or battery-sensitive play."
- **Smooth (Flow)**: "Low overhead smoothness boost for most lightweight games."
- **Balanced (Bal)**: "Recommended. Balances smoothness, power usage, and stability."
- **Enhanced (Boost)**: "Stronger motion smoothing for users who prefer extra fluidity."
- **Clear**: "Prioritizes a steadier, cleaner image with fewer motion artifacts."
- **Extreme (Max)**: "Highest quality preset with the highest power and performance cost."

The sidebar slider track shows 6 enabled positions (Eco · Flow · Bal · Boost · Clear · Max). "Disabled" is a separate off-state above the slider, not a slider position. Translations exist for ar, en, es, ja-rJP, pt-rBR, ru-rRU, zh-rCN, plus dozens more — XiaoJi treats this as a flagship feature.

---

## 10. The BannerHub `feature/framegen-menu` implementation

**Branch:** `feature/framegen-menu` (off main, commit `55308ab`)
**Merged:** main as `9d4a594` (`--no-ff`) on 2026-05-08, tagged **v3.7.0-pre1**

### 10.1 What the BannerHub UI adds

A new entry in the in-game sidebar (just below the RTS controls row):
- **Switch** — writes byte 2 of `gamescope.control` and persists to SharedPrefs
- **Gear button** → opens a programmatic Dialog (no XML — modeled on RTS Gesture Settings) exposing:
  - Enable toggle
  - 6-position preset slider (Eco/Flow/Bal/Boost/Clear/Max — values copied from GameHub 6.0.1's `AiFrameInterpolationMode` enum)
  - Multiplier picker 2× / 3× / 4× (byte 9, clamped 2–4)
  - Custom flowScale slider 0.20–1.00 (bytes 4–7 float32 LE)
  - FPS limit toggle + value 30–144 (bytes 0–1 uint16 LE)

Every control writes immediately to `<imageFs>/etc/gamescope.control` AND saves to SharedPrefs. Settings re-apply on every game launch via the smali hook so values survive BannerHub's regenerator.

### 10.2 Files

| Path | Role |
|---|---|
| `extension/BhFrameGenSettings.java` | Settings + 6-preset enum |
| `extension/BhFrameGenWriter.java` | mmap byte writer (per-byte + full + `applyFromPrefsNoContext()` + `ensureIcdJsonForCurrentPackage()`) |
| `extension/BhFrameGenDialog.java` | Programmatic dialog UI (no XML — avoids R.id cross-module coupling, like BhFrameRating) |
| `extension/BhFrameGenWiring.java` | Binds sidebar widgets via `getResources().getIdentifier()` |
| `patches/smali_classes14/com/xj/winemu/sidebar/SidebarControlsFragment.smali` | onResume hook → `BhFrameGenWiring.bind(getView())` |
| `patches/smali_classes6/com/winemu/core/controller/EnvironmentController.smali` | Tail of `n()` method → `BhFrameGenWriter.applyFromPrefsNoContext()` |
| `patches/res/layout/winemu_sidebar_controls_fragment.xml` | Adds `frame_gen_container` row |
| `patches/res/values/ids.xml` | + `frame_gen_container`, `switch_frame_gen`, `btn_frame_gen_settings` |
| `patches/res/values/strings.xml` | + `bh_framegen_title`, `bh_framegen_settings_open` |

### 10.3 Storage

- SharedPreferences file: `bh_framegen.xml`
- **Global** (not per-game) settings in v1
- Keys: `enabled`, `preset`, `multiplier`, `flowScale`, `model`, `fpsLimitEnabled`, `fpsLimitValue`

### 10.4 Preset → byte mapping in our implementation

| Preset | model | flowScale |
|---|---|---|
| ECO | 0 | 0.2 |
| FLOW | 0 | 0.4 |
| BAL | 0 | 0.6 (default) |
| BOOST | 0 | 0.8 |
| CLEAR | 1 | 0.6 |
| MAX | 1 | 0.8 |

### 10.5 Commit history on the branch

1. `55308ab` feat(framegen): in-game AI Frame Generation settings menu — initial scaffolding
2. `0e214de` fix(framegen): move launch hook from classes6 to classes15
3. `5a9ab56` fix(framegen): drive sidebar switch via `setSwitch()` reflection; remove FPS section
4. `12195fc` fix(framegen): dock settings dialog to right edge, vertically centered
5. `902ec82` fix(framegen): compact dialog — 320dp wide, smaller text + paddings
6. `7af2a70` feat(framegen): write `GameScopeVK_icd.json` with runtime package name ← unblocks any package name

---

## 11. The 18:23 A/B failure — what we learned

Our first live test on 2026-05-08 18:19 **looked like a success and failed**. Capture during gameplay showed:
- ✓ `D gamescope: GameScope control enabled` — patched control file was read
- ✓ `D gamescope: wellknown engine DXVK detected` — engine recognized
- ✓ Game's `vkCreateInstance` flowed through gamescope
- ✓ Swapchain 1280×720 / 3 images created via gamescope
- ✓ Chained to user's Turnip driver

But:
- ✗ Zero "Frame interpolation" / "Optical flow" / "AI model" log lines
- ✗ `VK_NV_optical_flow` not in negotiated device extension list
- ✗ No `tu_*OpticalFlow*` activity
- ✗ In-game BannerHub overlay = 24 FPS in BOTH the patched and reverted runs

**Root cause:** BannerHub's launcher regenerated `gamescope.control` *after* our manual mmap patch with bytes 2 and 3 swapped — `enabled` ended up at 0, `NativeRender` ended up at 1. The libGameScopeVK loaded but ran in transparent-passthrough mode because the enabled byte was zero by the time it actually mattered.

**The 20:30 success** came from the framegen-menu branch's launch hook in `WineActivity.onCreate()` (line 6052) which calls `applyFromPrefsNoContext()` — that fires *after* the regenerator and re-asserts the correct byte order from SharedPrefs. That's the difference between "loaded but no-op" and "actually doing 2× interpolation."

---

## 12. Verified results — 2026-05-08 20:30 live test

Device: AYANEO Pocket FIT, Adreno 750, custom Turnip `Turnip_v26.2.0_R3`, God of War (Steam ID 1593500). FPS overlay screenshots saved at:
- `/data/data/com.termux/files/home/Screenshot_20260508-202930.png`
- `/data/data/com.termux/files/home/Screenshot_20260508-202943.png`
- `/data/data/com.termux/files/home/Screenshot_20260508-203018.png`

| State | Toggle | Preset | Multi | flowScale | **FPS** | GPU | CPU | PWR |
|---|---|---|---|---|---|---|---|---|
| Off  | OFF | Clear | 2× | 0.60 | **42** | 86% | 57% | -17.3W |
| On 1 | ON  | Clear | 2× | 0.60 | **75** | 97% | 69% | -16.9W |
| On 2 | ON  | Flow  | 2× | 0.40 | **80** | 85% | 57% | -14.8W |

Observations:
- ~1.79× / ~1.90× scaling on a 2× multiplier — exactly what a working LSFG/optical-flow pipeline should yield (perfect 2× is impossible due to flow-pass overhead)
- Flow preset @ 0.40 flowScale = highest FPS at *lowest* GPU/CPU usage → lighter preset behaves correctly
- End-to-end chain confirmed: framegen-menu dialog → `gamescope.control` byte writes → libGameScopeVK frame-interp backend → freedreno `VK_NV_optical_flow` → 2× frame multiplier

**Fresh-install + renamed-package test:** also passed. User manually changed the APK package name, fresh-installed, launched a game, opened the frame-gen menu, and confirmed activation works end-to-end. ICD JSON was written correctly for the runtime package name.

---

## 13. Open issues / future work

- **Multiplier=3 / 4** — documented in protocol, not yet observed working in tests. Stick to 2× for verified results.
- **Settings are global**, not per-game. Per-game scoping is a v2 candidate. (GameHub 6.0.1 stores per-game via `WineSettingScope.Game`; we collapsed to global for v1 simplicity.)
- **Dialog is hardcoded English** — programmatic UI with no string resources. Localization TBD.
- **`Extreme` preset's `multiplier=1` quirk** — the upstream enum value will be silently coerced to 2× by the IPC writer. Either drop "Extreme" from our preset list or document that "Max" preset still runs at 2× in v2.
- **No graceful "device unsupported" UX** — if `VK_NV_optical_flow` isn't available, the toggle works but does nothing. We should detect via Vulkan extension query and disable the toggle with an explanatory tooltip.
- **`GAMESCOPE_DUMP_FAILURES=1`** is a useful debug knob we haven't yet wired into the BannerHub UI. Could go in a hidden dev-tools menu.

---

## 14. Cross-references

- `BANNERHUB_MASTER_MAP.md` § 26.8 — full GameHub 6.0.1 deep-dive (data classes, persistence, mmap IPC, libGameScopeVK ICD, VK_NV_optical_flow on Adreno, UI strings, capability gating)
- `gamehub_reports/VK_NV_OPTICAL_FLOW_ON_ADRENO.md` — dedicated driver-nerd writeup of the OF extension reimplementation (chip 6/7/8 dispatch, Turnip internals, ICD chain, embedded delta/gamma compute pipelines)
- `BANNERHUB_API_6.0_INTEGRATION.md` — relates to the broader 6.0.1 hotfix work (v1.0.1-601)
- `project_lsfg_android.md` — separate frame-gen project (LSFG-VK), unrelated DLL-based approach
- `project_bannerhub.md` — overall BannerHub state and release status
- Live capture log: `/home/claude-user/live-framegen.log` (29,510 lines, 2026-05-08 session)
