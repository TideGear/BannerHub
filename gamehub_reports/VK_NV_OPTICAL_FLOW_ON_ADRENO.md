# `VK_NV_optical_flow` on Adreno — Deep-Dive Report

**Status:** Confirmed working on Adreno 750 (chip 7) end-to-end as of 2026-05-08; symbols also present for chip 6 and chip 8.
**Scope:** How a Vulkan extension whose name is literally prefixed `_NV_` ends up running on a Qualcomm phone GPU, and what BannerHub 3.7.0's AI Frame Generation actually depends on at the driver layer.
**Audience:** Developers / driver nerds. Does not duplicate the user-facing material in `AI_FRAME_GENERATION_REPORT.md` — read that first for the simple version.

---

## TL;DR

`VK_NV_optical_flow` is **a Vulkan extension specification, not a hardware lock**. Anyone whose Vulkan driver can answer `vkCreateOpticalFlowSessionNV` and friends can advertise it. NVIDIA designed the spec around their RTX 40-series fixed-function Optical Flow Accelerator (OFA), but XiaoJi's Mesa Turnip fork (`libvulkan_freedreno.so`, bundled in `imagefs_136.zst`) **reimplements the same ABI as plain Vulkan compute shaders running on Adreno's regular shader cores**, with separate codepaths compiled for chip 6, chip 7, and chip 8. BannerHub's `libGameScopeVK.so` is a generic Vulkan ICD shim that calls those entry points; it has no NVIDIA-specific code at all. If the underlying Vulkan ICD is Turnip → frame-gen works. If it's stock Qualcomm/ARM/PowerVR → it silently no-ops.

---

## 1. The two binaries involved

Both ship inside the imagefs (`imagefs_136.zst`, the 1.3.6 / "AI build" firmware), not inside the BannerHub APK.

| Binary | Path inside imagefs | Size (1.3.6) | BuildID | Role |
|---|---|---|---|---|
| `libGameScopeVK.so` | `usr/lib/libGameScopeVK.so` | 2,218,904 B (2.2 MB) | `173d02fd…` | ICD shim that intercepts the swapchain and runs the frame-gen NN |
| `libvulkan_freedreno.so` | `usr/lib/libvulkan_freedreno.so` | 13,628,576 B (13.0 MB) | `9f591407…` | Mesa Turnip driver fork that actually implements `VK_NV_optical_flow` |

For comparison, the older `imagefs.zst` (Sep 2025) ships a 972,456-byte `libGameScopeVK.so` with no AI codepath — that's the placeholder version pre-1.3.5. **The OF-capable Turnip and the AI-capable Gamescope shim only exist in 1.3.5+ firmwares.**

---

## 2. Where the magic actually lives — Mesa Turnip

`nm -D` against `libvulkan_freedreno.so` does not list the OF symbols as dynamic exports — they are reached through the ICD's `vkGetDeviceProcAddr`. The C++ mangled names are present in the binary's string table:

```
_Z29tu_CreateOpticalFlowSessionNVIL4chip6EE…   Adreno 6xx (640/650/660/680)
_Z29tu_CreateOpticalFlowSessionNVIL4chip7EE…   Adreno 7xx (730/740/750)
_Z29tu_CreateOpticalFlowSessionNVIL4chip8EE…   Adreno 8xx / Adreno X1
_Z30tu_DestroyOpticalFlowSessionNVIL4chip{6,7,8}EE…
_Z32tu_BindOpticalFlowSessionImageNVIL4chip{6,7,8}EE…
_Z26tu_CmdOpticalFlowExecuteNVIL4chip{6,7,8}EE…
```

Plus the spec's struct-type strings — `VkPhysicalDeviceOpticalFlowFeaturesNV`, `VK_STRUCTURE_TYPE_OPTICAL_FLOW_SESSION_CREATE_INFO_NV`, `VK_OBJECT_TYPE_OPTICAL_FLOW_SESSION_NV`, `VK_STRUCTURE_TYPE_OPTICAL_FLOW_IMAGE_FORMAT_INFO_NV`, etc. — and the loader-facing entrypoint strings:

```
vkCreateOpticalFlowSessionNV
vkDestroyOpticalFlowSessionNV
vkBindOpticalFlowSessionImageNV
vkCmdOpticalFlowExecuteNV
vkGetPhysicalDeviceOpticalFlowImageFormatsNV
VK_NV_optical_flow
```

So Turnip advertises the extension in `vkEnumerateDeviceExtensionProperties` and exposes the Feature struct via `vkGetPhysicalDeviceFeatures2(VkPhysicalDeviceOpticalFlowFeaturesNV)`. From the application's perspective the device looks identical to an RTX 40-series.

### 2.1 Per-chip dispatch

The `IL4chip{6,7,8}EE` template parameter is Mesa's standard "compile this code separately for each Adreno generation" pattern. Different generations vary in:

- Wave width (wave64 vs wave128 paths)
- Texture-gather ISA (different cluster layouts)
- FP16 dot-product instructions and accumulator widths
- Image-store coherency rules

The fact that the binary contains all three instantiations means a single Turnip build covers Adreno 6xx through 8xx. At session-create time `tu_physical_device->info->chip` indexes into the right template specialisation.

Identifier-style strings in the binary: `Turnip Adreno (TM) %s%s`, `turnip Mesa driver`, `turnip-v1`. SONAME `libvulkan_freedreno.so`. Built with NDK r29 against Android 34 (`for Android 34, built by NDK r29 (14206865)`).

### 2.2 What the implementation almost certainly is

There is no fixed-function OFA on Adreno, so the only thing the chip-specific `tu_*` functions can be doing is **dispatching Vulkan compute pipelines**. Strong hints from the surrounding ISA on Adreno 7/8:

- `IMAGE_GATHER` instructions on the texture units → block-matching cost-volume construction
- FP16 dot-product MAD lanes → SAD / NCC accumulation
- Hardware mip-map generation → cheap pyramid building for hierarchical OF
- Wave-uniform `READFIRSTLANE`-style reductions → winner-take-all min/argmin per pixel block

Performance is much worse than RTX's dedicated OFA (which is why the AI Frame Generation report budgets ~10–20% extra GPU cost), but the API is identical, so the consuming code doesn't need to know.

---

## 3. The consumer — `libGameScopeVK.so`

A Vulkan **layer-shaped ICD shim**. Its job is to look like a Vulkan driver to the Vulkan loader, intercept swapchain calls, and produce the AI-warped intermediate frames.

### 3.1 What it doesn't link against

`readelf -d` says NEEDED is exactly:

```
libandroid.so   liblog.so       libEGL.so       libGLESv2.so    libGLESv3.so
libX11.so       libX11-xcb.so   libxcb.so       libxcb-dri3.so  libxcb-present.so
libvulkan.so    libm.so         libdl.so        libc.so
```

**Nothing else.** No NCNN, no ONNX Runtime, no TensorFlow Lite, no CUDA / CUDNN, no NVIDIA runtime. This is a clean Vulkan client. The "AI" is not a black-box framework call — it is shader bytecode embedded inside the .so itself.

### 3.2 The embedded compute pipeline

Diagnostic strings reveal the structure of the inference network:

```
delta0 failed   delta1 failed   delta2 failed   delta3 failed   delta4 failed
delta5 failed   delta6 failed   delta7 failed   delta8 failed   delta9 failed
gamma0 failed   gamma1 failed   gamma2 failed   gamma3 failed   gamma4 failed
gamma23 failed
```

10 `delta` stages + 6 `gamma` stages (note `gamma23` — likely a fused 2/3 stage). Combined with the lifecycle strings:

```
warmup ingest failed         (loading the network input)
begin warmup command buffer failed
warmup submit failed         (dispatching the warmup pass)
Frame interpolation backend created   (success path)
Frame interpolation backend creation failed
Frame interpolation execution failed: {}
```

…this is consistent with a small UNet-style image-to-image network that takes (frame N-1, frame N, optical-flow vectors) → synthetic mid-frame. The OF vectors from `vkCmdOpticalFlowExecuteNV` are one of the inputs, not the output. Weights load via the warmup pass; the report flagged "BCN-compressed textures" as the encoded weight format. The whole network runs as Vulkan compute, which is why the ICD-side shim doesn't need an ML framework.

### 3.3 Loader-level config

`libGameScopeVK` consumes these env vars (loaded via `getenv`, all observable in the binary's strings):

```
GAMESCOPE_CONTROL_PATH         path to the 10-byte gamescope.control mmap (state + multiplier byte)
GAMESCOPE_DRIVER_PATH          real Vulkan ICD to chain to (i.e. libvulkan_freedreno.so)
GAMESCOPE_DEVICE_MEMORY_LIMIT  device-memory cap override
GAMESCOPE_DUMP_FAILURES        diagnostic dump toggle (not yet wired into BannerHub UI)
GAMESCOPE_SURFACE_USING_BGRA   swap-chain pixel-format hint
```

`GAMESCOPE_DRIVER_PATH` is the critical one for understanding the chain — the shim is not a driver, it's a man-in-the-middle that *delegates* device functionality to whatever ICD the env var names. So at runtime:

- The Vulkan loader sees `libGameScopeVK.so` advertised in `GameScopeVK_icd.json`, loads it as the ICD.
- `libGameScopeVK` opens `GAMESCOPE_DRIVER_PATH` (`libvulkan_freedreno.so`), forwards all the device-level calls.
- For swapchain Present, it inserts its own compute pass + `vkCmdOpticalFlowExecuteNV` against the chained driver.

Hence the dependency: **the chained driver must be one that advertises `VK_NV_optical_flow`.** Stock Qualcomm doesn't.

---

## 4. End-to-end runtime chain (one diagram)

```
Wine-side game (DXVK → Vulkan)
        │
        │  vkCreateInstance / vkCreateDevice
        ▼
Vulkan loader (libvulkan.so)
        │  reads /…/files/usr/home/steamuser/.config/vulkan/icd.d/GameScopeVK_icd.json
        │  → "library_path": "/data/data/<pkg>/files/usr/lib/libGameScopeVK.so"
        ▼
libGameScopeVK.so   (the shim ICD)
        │
        │  on init: dlopen(getenv("GAMESCOPE_DRIVER_PATH"))
        │            → libvulkan_freedreno.so
        │  forwards vkEnumeratePhysicalDevices, vkGetPhysicalDeviceFeatures2, …
        │
        │  on vkQueuePresentKHR:
        │    1. vkCmdOpticalFlowExecuteNV(prev_frame, this_frame, …)
        │    2. dispatch delta0..delta9, gamma0..gamma4/gamma23 compute pipelines
        │    3. blit synthetic intermediate(s) into the swapchain image
        │    4. forward Present
        ▼
libvulkan_freedreno.so  (Turnip fork)
        │  tu_CmdOpticalFlowExecuteNV<chip 7>(…)
        │    → builds command stream of compute shaders against Adreno
        ▼
Adreno shader cores (no fixed-function OFA — pure compute)
```

The whole AI part of the chain runs **above** the kernel driver — `libvulkan_freedreno.so` talks to the kernel's `msm`/`adreno` driver via the standard Mesa winsys (`libdrm`/`libnativewindow`), nothing custom.

---

## 5. The runtime gate (silent-fail mode)

`libGameScopeVK` queries `VK_NV_optical_flow` from the chained driver during backend init. If the chained driver doesn't advertise it:

- `vkCreateOpticalFlowSessionNV` returns `VK_ERROR_FEATURE_NOT_PRESENT` (or similar)
- Backend init logs `Frame interpolation backend creation failed` via `liblog`
- The shim falls back to swapchain passthrough — frames forwarded unmodified
- **No toast, no dialog, no UI feedback.** The frame-gen toggle simply doesn't do anything

This is the worst part of the UX and the thing 3.7.0 still doesn't surface to the user. The fix would be a Vulkan extension probe at app startup (`vkEnumerateDeviceExtensionProperties` against the active GPU driver) and disabling/greying-out the toggle if the extension isn't present.

### 5.1 Verification recipe

```bash
# 1. Force frame-gen on, launch a game, capture logs
getlog -f <bannerhub_pkg>

# 2. Look for which path fired
grep "Frame interpolation backend" <log>
#  → "Frame interpolation backend created"          → working
#  → "Frame interpolation backend creation failed"  → driver does not advertise VK_NV_optical_flow

# 3. Confirm Turnip is loaded (PC GPU drivers settings)
grep -i "turnip" <log>
```

Confirmed-good Turnip variant for the 2026-05-08 successful run: `Turnip_v26.2.0_R3` (chip 6/7/8 OF symbols all present; build matches the bundled 1.3.6 freedreno SONAME).

---

## 6. Practical implications

1. **It's not a Tencent / XiaoJi secret.** It's open-source Mesa Turnip with the OF feature flag turned on at build time. Anyone can rebuild Turnip with `tu_optical_flow.c` enabled and ship the result.
2. **Vendor drivers will never advertise this.** Qualcomm's official Vulkan ICD has zero motivation to implement an `_NV_`-prefixed extension. The whole feature is parasitic on the Mesa stack — the user must have the "Custom GPU driver" toggle ON pointing at a Turnip variant with the OF symbols present.
3. **chip-6 coverage means older devices may work.** Adreno 640 / 650 / 660 phones (S855/S865/S888) shouldn't be ruled out a priori — the symbols are there. Whether the compute throughput is good enough for net-positive frame-gen at typical render resolutions is a separate empirical question.
4. **The "AI" and the "optical flow" are separable.** The OF stage gives motion vectors; the delta/gamma compute pipelines do the actual warp+blend. The OF stage *could* in principle be replaced by a manual block-matching compute shader if Turnip were ever stripped of the extension. The inference pipelines in `libGameScopeVK` would still work — they consume vectors as input.
5. **Two pieces of stacked magic.** (a) Mesa Turnip clones an NV-prefixed extension onto Adreno. (b) GameScopeVK ships a small embedded inference network that consumes those OF vectors. (a) is the load-bearing trick. (b) is the polish that turns motion vectors into perceived smoothness.
6. **None of this is bypassed or "hacked around" at the API level.** The Vulkan extension namespace lets vendors ship vendor-prefixed extensions, but the ABI is open — Mesa simply implemented the same entrypoints. From the loader's point of view the device legitimately supports `VK_NV_optical_flow`.

---

## 7. What BannerHub itself contributes

To be clear about layering: BannerHub 3.7.0 ships **none of these binaries**. Specifically:

- `libGameScopeVK.so` → ships in the user's installed imagefs (1.3.5 / 1.3.6).
- `libvulkan_freedreno.so` → ships in the user's installed imagefs **and** in the Custom GPU driver bundle the user picks (Turnip_v26.2.0_R3 etc.).
- `GameScopeVK_icd.json` → BannerHub **does** write this at game-launch time via `BhFrameGenWriter.java`, with `library_path` set to `/data/data/<pkg>/files/usr/lib/libGameScopeVK.so` so it survives package renames. Before 3.7.0 this JSON was a stale `com.winemu` placeholder that broke on every install.
- `gamescope.control` (the 10-byte mmap that controls enable/multiplier) → BannerHub writes this from the in-game frame-gen menu via the framegen-menu dialog and the `EnvironmentController` smali hook.

So BannerHub's contribution is **the wiring**, not the runtime. The optical-flow magic itself is Turnip's, and the inference network's is XiaoJi's GameScopeVK.

---

## 8. Cross-references

- `AI_FRAME_GENERATION_REPORT.md` § 6 — same topic, user-facing summary.
- `gamehub_reports/GAMEHUB_600_MASTER_MAP.md` § 26.8.6 — same topic, embedded inside the broader 6.0.1 deep-dive.
- `BANNERHUB_MASTER_MAP.md` § 26.8 — full GameHub 6.0.1 frame-gen architecture.
- `imagefs_136.zst` (Termux home) — source of all binary observations in this report.
- Live capture log `/data/data/com.termux/files/home/live-framegen.log` (29,510 lines, 2026-05-08 confirming-run session).

---

*Generated 2026-05-08 from direct symbol/string analysis of `imagefs_136.zst:usr/lib/{libGameScopeVK.so, libvulkan_freedreno.so}`.*
