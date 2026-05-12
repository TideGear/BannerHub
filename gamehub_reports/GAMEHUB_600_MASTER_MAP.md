# GameHub 6.0.0 — Master APK Map

**Generated:** 2026-05-01
**Last revised:** 2026-05-07 (full § 26 expansion — 22 sub-sections covering 6.0.0 → 6.0.1 deltas: R8 letter remap, vjoy/Scheme cloud-share, AI Frame Generation deep dive, Steam SDK refresh, multi-layer vjoy, gyro + new touchscreen modes, Box64 per-game tunable UI, HUD overlay, PC game backup, Wine performance modes, setup-flow rewrite, container validators, BaseInfo package move, asset adds, native lib refresh, manifest correction, sidebar features)
**Source APK:** `GameHub_beta_6.0.0_global.apk` (base for §§ 1–25); `GameHub_6.0.1.apk` (versionCode 111) for § 26 deltas
**Tools:** apktool 2.12.1 + jadx
**Coverage:** 32 iterative passes (3 consecutive clean) + on-device probes 2026-05-02/03 + targeted re-decompile 2026-05-03 (JNI surface, Card serializer, perf telemetry, JS bridge, vJoy serializer, BaseAndroidApp init order). 6.0.1 base added 2026-05-07: 18 angle-pass scans (manifest, native libs, kept-package classes, all string literals, resources/assets, $$serializer/DTOs, AI frame-gen deep dive, Compose nav graph, DB entities/DAOs, sealed/abstract hierarchies, package-level class counts, all-locale string resources, top-level package counts, drawables, composeResources, WineInGameSettingType members, all com.xiaoji.egggame enums) + 3 consecutive empty passes confirming termination. See § 26 for delta-only coverage. Pass-history detail in Appendix A.
**Companion report:** `BANNERHUB_API_6.0_INTEGRATION.md` documents the BannerHub Cloudflare Worker + bannerhub-revanced patch divergence from this vanilla map.

---

## Table of Contents

1. APK Identity
2. Architecture Overview
3. Native Layer (libs + JNI surface)
4. Assets (composeResources, shaders, baseline profile, root files)
5. Resources (XML, fonts, layouts)
6. AndroidManifest (activities, services, receivers, providers, permissions, processes)
7. DEX / Java Package Map
8. Application Entry Points (init order, deep links)
9. Subsystems
   - 9.1 WinEmu (Wine emulation core)
   - 9.2 Steam Integration
   - 9.3 Epic Games (EpicKit)
   - 9.4 Retro Emulation
   - 9.5 Cloud Gaming (VTouch + Haima HMCP)
   - 9.6 In-App Payment
   - 9.7 Card System
   - 9.8 Virtual Joystick (VJoy)
   - 9.9 Performance HUD
   - 9.10 Performance Telemetry
10. DTO Inventory
11. Storage
    - 11.1 Room Databases
    - 11.2 SharedPreferences / MMKV
    - 11.3 FileProvider Paths
12. API Surface
    - 12.1 Catalog API (`mcj` enum, bare hostnames)
    - 12.2 Client API (`clientgsw.vgabc.com/clientapi/`)
    - 12.3 Standalone first-party URL literals
    - 12.4 Live verification — host reachability matrix
13. CDN Structure
14. Third-Party SDK Endpoints
15. Custom URI Schemes
16. External `content://` Providers
17. Game Launch Types
18. Third-Party SDK Inventory
19. Removed Since 5.3.5
20. Themes & Styles
21. Third-Party Metadata (app IDs, SDK versions)
22. New in 6.0 vs 5.3.5
23. Decompile Output Locations
24. Related Reports
25. Appendix A — Scan History (Passes 22–32)
26. 6.0.0 → 6.0.1 Deltas (added 2026-05-07)
    - 26.1 APK Identity Bump
    - 26.2 R8 Class-Letter Remap (auth flow, navigator, URL builder, data classes)
    - 26.3 New vjoy/Scheme Cloud-Share Subsystem
    - 26.4 New API Endpoint Family (vcontroller/*, simulator/configList family, layoutType)
    - 26.5 New 6.0.1-only NavigationInterceptor (`Lar0;`)
    - 26.6 Firmware Version Bump (1.3.4 → 1.3.5 → 1.3.6)
    - 26.7 Upstream Feature Highlights (XiaoJi-side)
    - 26.8 AI Frame Generation — Technical Deep Dive (data classes, persistence, mmap IPC, libGameScopeVK ICD, VK_NV_optical_flow on Adreno, UI strings, capability gating)
    - 26.9 Steam SDK Refresh (cancellable downloads, network-status sync, +510KB libsteamkit_core.so)
    - 26.10 vjoy Multi-Layer Architecture (VJoyLayer, ControlAction.SwitchLayer, layout-format extension)
    - 26.11 Gyroscope + New Touchscreen Input Methods (GyroAim/TargetMode, ScreenTouchInput/Mode, AxisRole, VJoyTextAlign)
    - 26.12 Box64 Per-Game Tunable UI (~80 new strings; surfaces 30+ Box64 dynarec/TSO/x87/SMC tunables per game)
    - 26.13 Wine HUD Overlay Strings (MangoHud Integration)
    - 26.14 PC Game Data Backup / Restore (NEW Feature)
    - 26.15 Wine Performance Modes (Power Profiles)
    - 26.16 Setup / Install Flow Rewrite
    - 26.17 Container State Check + Game-File Validator
    - 26.18 DTO Package Move (`core.domain.base.*` → `core.network.model.baseinfo.dto.*`)
    - 26.19 Resource Asset Additions (cover image, splash GIFs, guide-finger icon, launcher refinements)
    - 26.20 Native Library Refresh (Steam/Epic SDKs)
    - 26.21 Manifest Correction (USB host)
    - 26.22 Additional Sidebar Features (gyro calibration state machine, force-exit, trackpad sensitivity, virtual gamepad toggle)
27. 6.0.1/6.0.2 → 6.0.4 Deltas (added 2026-05-12)
    - 27.1 APK Identity Bump (versionCode 110 → 114, minSdk 31 → 29)
    - 27.2 New MTDataFiles SDK (Matryoshka file-content provider)
    - 27.3 AI Frame Interpolation Mode Enum (new beans, 6 modes)
    - 27.4 Native Library Refresh (libsteamkit_core.so 9.6 → 11 MB; libwinemu.so -3.7%)
    - 27.5 New Resource Qualifier Folders (`values-en`, `values-v30`, `values-v31`)
    - 27.6 Alipay SDK Pruning (APM Security + Android-app SDK removed)
    - 27.7 R8 Class-Letter Remap Update (NavigationInterceptor `Lar0` → `Lixo`; BaseAndroidApp deobfuscated)
    - 27.8 New `org/` Package — BouncyCastle Post-Quantum Crypto
    - 27.9 Smali Class Count Growth (+715 classes, 1.3% growth)

---

## 1. APK Identity

| Field            | Value                          |
|------------------|-------------------------------|
| Package          | `com.xiaoji.egggame` (this APK); also branches on `com.xiaoji.egggame.realme` and `com.xiaoji.egggame.redmagic` package IDs at runtime — confirms OEM-skinned variants for RealMe and RedMagic gaming phones |
| Version Name     | 6.0.0                          |
| Version Code     | 110                            |
| Min SDK          | 31 (Android 12)                |
| Target SDK       | 36 (Android 16)                |
| Compile SDK      | 36 / codename 16               |
| Architecture     | arm64-v8a only                 |
| DEX files        | 6 (classes.dex – classes6.dex) |
| Total classes    | 53,053                         |
| Build VCS        | git rev `dac5b666d67b8fa0fe6ccaadfbc3343f1d515803` (recorded in `unknown/META-INF/version-control-info.textproto`) |
| Obfuscation      | Heavy R8 (~98% of classes use 2–4 char names). Named: `com.xiaoji.*`, `com.winemu.*`, `com.xj.muugi.*`, plus all third-party SDKs |
| Locales          | 160+ resource folders. KMP string translations: ja-rJP, pt-rBR, ru-rRU, zh-rCN (default); cardsystem also has ar + es |

**Pulled-from-device receipt (2026-05-03):** vanilla GH 6.0 lifted from a device install of `com.mihoyo.genshinimpact` (XiaoJi reuses miHoYo's package for their store skin), versionName `6.0.0`, versionCode `49908`. All API verification in §12 was run against this binary.

---

## 2. Architecture Overview

| Aspect | Choice |
|---|---|
| **UI stack** | Kotlin + Jetpack Compose (primary). Legacy XML layouts only for third-party SDK screens (Weibo, Alipay, HMCP, etc.) |
| **KMP** | Compose Multiplatform resource system — 31 modules in `assets/composeResources/` |
| **Navigation** | Single-activity Compose Navigation (`androidx.navigation3` + `androidx.navigationevent`) with `AppNavKey` sealed class. **78 `@Serializable` destinations + ~40 data-object destinations ≈ 119 routes.** kotlinx.serialization wired in for typed-payload routes |
| **DI** | Koin — ~70–80 modules total: 22 prebuilt + 19 inline in `BaseAndroidApp`, plus ~30+ from `us2.smali` feature-DI factory |
| **Wine integration** | `libwinemu.so` + `libxserver.so` runtime; `WineActivity` + `com.winemu.*` Java SDK; runs in separate `:wine` process |
| **GPU info** | `libgpuinfo.so` + `GPUInfoQuery.java` — must call on main thread (AdrenoTools SIGSEGV risk) |
| **Steam** | `libsteamkit_core.so` + `SteamCloudSaveService` + `com.winemu.core.steam_agent` |
| **Epic Games** | `libepickit_core.so` via UniFFI Rust bridge — full EGS catalog/download/cloud-save SDK |
| **Cloud gaming** | VTouch (`vtouch/startType` API + `cloud_game_sessions` Room DB) + Haima HMCP SDK (separate stack) |
| **Retro emulation** | WebView + Nostalgist.js 0.19.0 + RetroArch WASM cores (6 platforms) |
| **XGP** | Xbox Game Pass redemption via `xgp.xiaoji.com` + `gamehub-service-dev.xiaoji.com/xgp/exchange` |
| **Controllers** | GameSir SDK (libGamesir.so), JieLi USB OTA (libJieLiUsbOta.so + libjl_ota_auth.so), Nordic BLE DFU, RxAndroidBLE, custom `com.xiaoji.sdk.bluetooth.le` SDK |
| **Media** | IJK player (Haima fork) + ExoPlayer Media3 (HLS/offline/image) + AV1 (libaom + libdav1d) + H.265 (libx265 + libde265) + HEIF + AVIF (awxkee) |
| **IAP** | Apple IAP receipt verification + WeChat Pay + pending payment retry queue (`db_pending_payment_v1.db`) |
| **Game platforms** | WinEmu PC + Steam + Epic + GOG + Xbox Cloud Gaming + PlayStation streaming + VTouch — 20 distinct LaunchType values |
| **Daily sign-in** | `cloud_sign/getActivity` + `cloud_sign/sign` |
| **Push** | Firebase FCM + Huawei HMS Push + MobPush (aggregator for Xiaomi/OPPO/vivo/Honor/Meizu/Unicom) — 6-channel |
| **Auth** | WeChat, QQ, Alipay, Weibo, Google Sign-In, Firebase Auth, phone-number (Alibaba + CMIC SSO), FlyID, MobID, Apple, Epic. SDK classes also present for Facebook, Twitter, Play Games (Firebase Auth providers) |
| **Storage** | MMKV (fast prefs), Room (SQLite via libsqliteJni), DataStore, AVIF (awxkee), VFS layer (libvfs.so) |
| **Compression** | Zstandard JNI (libzstd-jni-1.5.7-4.so) + luben zstd — used for component/container downloads |
| **Crypto** | BouncyCastle (post-quantum `pqc` package present), Rustls platform verifier, Google Tink |
| **Crash reporting** | libfntvcrash.so (Fanttv) + Firebase Crashlytics |
| **HDR** | 4 SPIR-V compute shaders for Gamma/HLG/HDR10/D-Cinema tone-mapping |
| **Compose-specific** | `io.github.alexzhirkevich.compottie` (Lottie for Compose), `androidx.compose.material3.adaptive`, `androidx.privacysandbox.ads` |
| **Fonts** | MiSans VF (core + cardsystem), D-DIN Pro (6 weights, cardsystem), AlimamaShuHeiTi Bold (cardsystem) |

---

## 3. Native Layer

### 3.1 Native libraries (arm64-v8a only — 27 total)

| Library | Size | Purpose |
|---------|------|---------|
| `libsteamkit_core.so` | 9.6 MB | Steam Kit — Steam network/auth/cloud saves |
| `libhaima_rtc_so.so` | 7.9 MB | Haima RTC — real-time voice/streaming (WebRTC-based) |
| `libaom.so` | 4.7 MB | AV1 encoder/decoder (libaom) |
| `libepickit_core.so` | 4.6 MB | EpicKit — Epic Games SDK (UniFFI Rust bridge) |
| `libxserver.so` | 3.8 MB | X11/Xwayland server (Wine display layer) |
| `libcoder.so` | 2.1 MB | Custom encoder/decoder |
| `libx265.so` | 1.9 MB | H.265/HEVC video encoder |
| `libIjkffmpeg_haima.so` | 1.9 MB | FFmpeg (Haima fork — media playback) |
| `libde265.so` | 1.6 MB | H.265 software decoder |
| `libheif.so` | 1.4 MB | HEIF/HEIC image format support |
| `libsqliteJni.so` | 1.3 MB | SQLite JNI (Room database) |
| `libvfs.so` | 969 KB | Virtual filesystem layer (Wine VFS) |
| `libJieLiUsbOta.so` | 903 KB | JieLi USB OTA firmware update |
| `libmmkv.so` | 718 KB | MMKV — fast key-value storage (Tencent) |
| `libdav1d.so` | 714 KB | AV1 hardware-accelerated decoder (dav1d) |
| `libwinemu.so` | 683 KB | WinEmu JNI bridge (core Wine interface, IHudDataProvider) |
| `libzstd-jni-1.5.7-4.so` | 604 KB | Zstandard compression JNI (component downloads) |
| `libpns-2.14.17-…_alijtca_plus.so` | 499 KB | Alibaba push notifications |
| `libIjksdl_haima.so` | 461 KB | SDL layer for IJK player |
| `libIjkplayer_haima.so` | 446 KB | IJK media player (Haima) |
| `libgpuinfo.so` | 342 KB | GPU info/detection JNI (main-thread only) |
| `libjnidispatch.so` | 177 KB | JNA (Java Native Access) dispatch |
| `libfntvcrash.so` | 58 KB | Fanttv crash reporter |
| `libGamesir.so` | 20 KB | GameSir controller SDK |
| `libjl_ota_auth.so` | 15 KB | JieLi OTA authentication |
| `libandroidx.graphics.path.so` | 10 KB | AndroidX graphics path rendering |
| `libdatastore_shared_counter.so` | 7 KB | AndroidX DataStore shared counter |

### 3.2 JNI surface — WinEmu native server (com.winemu.core.server.*)

Java-side classes that bridge Wine's process loop. All extracted from jadx sources at
`com/winemu/core/server/`. **Many methods were not previously documented.**

| Class | Native methods (with signatures) |
|---|---|
| `com.winemu.core.server.alsaserver.ALSAClient` | `private native boolean downMix16Bit(ByteBuffer)`<br>`private native boolean downMix8Bit(ByteBuffer)`<br>`private native boolean downMixFloat(ByteBuffer)`<br>**Purpose:** ALSA audio downmix from Wine's PCM stream into device-native buffer. |
| `com.winemu.core.server.socket.ClientSocket` | `private native int read(int, ByteBuffer, int, int)`<br>`private native int write(int, ByteBuffer, int)`<br>`private native int recvAncillaryMsg(int, ByteBuffer, int, int)`<br>`private native int sendAncillaryMsg(int, ByteBuffer, int, int)`<br>**Purpose:** AF_UNIX socket I/O including SCM_RIGHTS fd-passing for X11 shared memory. |
| `com.winemu.core.server.socket.XConnectorEpoll` | `private native boolean addFdToEpoll(int, int)`<br>`public static native void closeFd(int)`<br>`private native int createAFUnixSocket(String)`<br>`private native int createEpollFd()`<br>`private native int createEventFd()`<br>`private native boolean doEpollIndefinitely(int, int, boolean)`<br>`private native void removeFdFromEpoll(int, int)`<br>`private native boolean waitForSocketRead(int, int)`<br>**Purpose:** epoll-based event loop hosting the X11 client connector. Hosts the Wine display I/O thread. |
| `com.winemu.core.server.sysvshm.SysVSharedMemory` | `public static native void closeFd(int)`<br>`public static native int createMemoryFd(String, int)`<br>`public static native int createMemoryFile(String, ByteBuffer)`<br>`public static native ByteBuffer createSubBuffer(ByteBuffer, int, int)`<br>`public static native ByteBuffer mapSHMSegment(int, long, int, boolean)`<br>`public static native void unmapSHMSegment(ByteBuffer, long)`<br>**Purpose:** System V SHM segment management (X11 MIT-SHM extension + Wine bitmap transfer). |
| `com.winemu.core.server.XServer` | `public final native boolean sendKeyEvent(int, int, boolean)`<br>`public final native void sendMouseEvent(float, float, int, boolean, boolean)`<br>`public final native void sendTextEvent(byte[])`<br>`public final native void sendTouchEvent(int, int, int, int)`<br>`public final native void sendWindowChange(int, int, int, String)`<br>`public final native void setRenderingEnabled(boolean)`<br>`public final native void setShmPath(String)`<br>`public final native void setSurfaceFormat(int)`<br>`public final native boolean start(String, String[])`<br>`public final native void startUI()`<br>`public final native void surfaceChanged(Surface)`<br>**Purpose:** X11 input injection + display lifecycle into running Wine process. Realized/unrealized window callbacks fire on Java side via `setOnWindowRealized`/`Unrealized`. |

### 3.3 JNI surface — WinEmu peripherals

| Class | Native methods | Purpose |
|---|---|---|
| `com.winemu.core.CabFile` | `private static final native long open(String)`<br>`private static final native void close(long)`<br>`public static final native boolean extract(long, long, String)`<br>`public static final native String getFileName(long)`<br>`private static final native long[] listFiles(long)` | Microsoft CAB archive read/extract (Wine installer payloads) |
| `com.winemu.core.DirectRendering$Companion` | `public final native void nativeInitialize(Surface, SurfaceControl, Surface, SurfaceControl, String, int, int)`<br>`public final native void nativeSetSurfaceFormat(int)` | Android `SurfaceControl` direct-rendering swap-chain wired to Wine's renderer |
| `com.winemu.core.GPUInfoQuery` | Singleton: `getGPUDeviceName/Vendor/DriverVersion/Id/Version` (loads libgpuinfo.so, **must call on main thread**) | GPU detection for AdrenoTools driver-replacement compatibility |
| `com.winemu.core.steam_agent.SteamAgentTicketIssuer` | `nativeCreateAgentTicket(...)` | Generate Steamworks Web API auth ticket (libsteamkit_core.so) |
| `com.xiaoji.egggame.common.steam_sdk.bridge.SteamBridgeNativeInitializer` | `initPlatformVerifier(Context)` | Initialize Steam's network platform verifier (rustls-platform-verifier integration) |
| `com.winemu.core.gamepad.GamepadServerManager` | `nativeCreate()`, `nativeDestroy()`, `nativeGetGamepadBuffer()`, `nativeSetRumbleCallback()`, `nativeUpdateGamepadCount()` | In-game gamepad state via Wine; Java-side `onRumble()` / `close()` callbacks |
| `com.xiaoji.sdk.bluetooth.le.Gamesir` | `decryJoyData(int[]) → int[]`<br>`setBTMac(byte[])` | GameSir hardware-protocol decryption + BT MAC pairing (libGamesir.so) |

**Recognized GameSir controller IDs** (from firmware/protocol routing strings):
`Gamesir-G4pro`, `Gamesir-G6` (+ `Gamesir-G6_OTA`), `Gamesir-T4pro`, `Gamesir-X2` (+ `Gamesir-X2_OTA`), `Gamesir-X3 Type-C`.

---

## 4. Assets

### 4.1 Root-level files (`assets/`)

| File / Pattern | Purpose |
|----------------|---------|
| `hmsrootcas.bks` / `hmsincas.bks` | Huawei HMS root + intermediate CA keystores |
| `grs_sp.bks` | Huawei GRS BKS keystore |
| `grs_sdk_global_route_config_opendevicesdk.json` | HMS device SDK regional routing (push.dbankcloud.com, regions DR1–DR4/CN/ASIA/RU/EU) |
| `grs_sdk_global_route_config_opensdkService.json` | HiAnalytics routing (metrics1-drcn.dt.dbankcloud.cn) |
| `grs_sdk_server_config.json` | HMS GRS base URLs: grs.dbankcloud.com/.cn/.asia/.ru/.eu |
| `com.tencent.open.config.json` | QQ SDK TA telemetry config (`Common_ta_enable: 1`, `Common_frequency: 24`) |
| `PublicSuffixDatabase.list` | OkHttp public suffix list for cookie domain validation |
| `h5_qr_back.png` | QR code background (QQ QR login) |
| `libwbsafeedit{,_64,_x86,_x86_64}` | Weibo SafeEdit native libs (4 ABIs, 12–18 KB each) — bundled as raw assets, loaded dynamically by Weibo SDK |

### 4.2 Vulkan compute shaders (`assets/shaders/`)

4 SPIR-V shaders for HDR tone-mapping:

| File | Purpose |
|------|---------|
| `GammaOetf.comp.spv` | Gamma OETF transfer function |
| `HLG.comp.spv` | Hybrid Log-Gamma HDR |
| `SMPTE2084.comp.spv` | HDR10 / PQ curve (SMPTE ST 2084) |
| `SMPTE428.comp.spv` | SMPTE ST 428 (D-Cinema) |

### 4.3 Baseline profile

| File | Purpose |
|------|---------|
| `assets/dexopt/baseline.prof` | ART baseline profile for startup optimization |
| `assets/dexopt/baseline.profm` | Baseline profile metadata |

### 4.4 composeResources (31 KMP modules)

Each module contains `values[-locale]/strings.commonMain.cvr`, optionally `drawable/`, `font/`, `files/`. Default locale `zh-rCN`. Most modules translated to ja-rJP, pt-rBR, ru-rRU, zh-rCN; cardsystem also has ar + es.

| Module | drawable | font | files | Notes |
|--------|---|---|---|-------|
| `com.xiaoji.egggame.cardsystem` | ✅ | ✅ (AlimamaShuHeiTi, D-DIN Pro 6w, MiSans) | ❌ | Card/game launcher (new in 6.0) |
| `com.xiaoji.egggame.common.download` | ❌ | ❌ | ❌ | Download feature strings |
| `com.xiaoji.egggame.common.game` | ✅ | ❌ | ❌ | Game entity strings + icons |
| `com.xiaoji.egggame.common.gamepadconnect` | ❌ | ❌ | ❌ | Gamepad pair strings |
| `com.xiaoji.egggame.common.gcm` | ❌ | ❌ | ❌ | GCM/FCM strings (en only) |
| `com.xiaoji.egggame.common.retro_emulators` | ✅ | ❌ | ✅ (nostalgist JS + index.html) | Retro emulation (new in 6.0) |
| `com.xiaoji.egggame.common.share` | ✅ | ❌ | ❌ | Share sheet assets |
| `com.xiaoji.egggame.common.shortcut` | ✅ | ❌ | ❌ | Launcher shortcut strings |
| `com.xiaoji.egggame.common.vjoy` | ❌ | ❌ | ✅ (vjoy icons + layouts) | Virtual joystick configs |
| `com.xiaoji.egggame.common.winemu_core` | ❌ | ❌ | ❌ | WinEmu core strings |
| `com.xiaoji.egggame.core` | ✅ | ✅ (MiSans VF) | ✅ (9 UI sound WAVs) | Core UI: navigation sounds, battery icons |
| `com.xiaoji.egggame.features.appupdate` | ✅ | ❌ | ❌ | Update dialog |
| `com.xiaoji.egggame.features.auth` | ✅ | ❌ | ❌ | Auth / login |
| `com.xiaoji.egggame.features.cloud` | ✅ | ❌ | ❌ | Cloud save |
| `com.xiaoji.egggame.features.community` | ✅ | ❌ | ❌ | Social/community (locale splash images) |
| `com.xiaoji.egggame.features.download` | ✅ | ❌ | ❌ | Download feature |
| `com.xiaoji.egggame.features.emojipicker` | ❌ | ❌ | ❌ | Emoji picker strings |
| `com.xiaoji.egggame.features.file_selector` | ✅ | ❌ | ❌ | File picker |
| `com.xiaoji.egggame.features.game` | ✅ | ❌ | ❌ | Game detail |
| `com.xiaoji.egggame.features.gamepadconfig` | ✅ | ❌ | ❌ | Gamepad config (zh-rCN drawable variant) |
| `com.xiaoji.egggame.features.gamepadconnect` | ✅ | ❌ | ❌ | Gamepad pairing screens |
| `com.xiaoji.egggame.features.home` | ✅ | ❌ | ✅ (Lottie JSON) | Home screen; locale-specific leaderboard images |
| `com.xiaoji.egggame.features.profile` | ✅ | ❌ | ❌ | User profile |
| `com.xiaoji.egggame.features.search` | ✅ | ❌ | ❌ | Search |
| `com.xiaoji.egggame.features.setting` | ✅ | ❌ | ❌ | Settings |
| `com.xiaoji.egggame.features.splash` | ✅ | ❌ | ❌ | Splash (zh-rCN variant) |
| `com.xiaoji.egggame.features.steam` | ✅ | ❌ | ❌ | Steam feature |
| `com.xiaoji.egggame.features.vjoy` | ✅ | ❌ | ❌ | Virtual joystick |
| `com.xiaoji.egggame.features.webview` | ❌ | ❌ | ❌ | In-app browser strings |
| `com.xiaoji.egggame.features.winemu` | ✅ | ❌ | ❌ | WinEmu feature (en + zh variants) |
| `com.xiaoji.egggame.features.zonecode` | ✅ | ❌ | ❌ | Region/zone code picker |

### 4.5 Core UI sound effects (`com.xiaoji.egggame.core/files/sound/`)

| File | Trigger |
|------|---------|
| `core_download_game_completed.wav` | Download complete |
| `core_launch_game.wav` | Game launch |
| `focus_boundary.wav` | Gamepad focus reached edge |
| `focus_cancel.wav` / `focus_confirm.wav` / `focus_move.wav` / `focus_tab_switch.wav` / `focus_toggle.wav` | Gamepad navigation |
| `gamepad_connected.wav` | Controller connected |

### 4.6 vJoy bundled assets (`com.xiaoji.egggame.common.vjoy/files/vjoy/`)

```
icons/
├── index.json                          icon pack manifest
└── OfficialStyle01.zip                 official icon pack (default)
layout/
├── index.json                          layout manifest
├── OfficialLayout_gamepad.gtheme       gamepad overlay layout
└── OfficialLayout_keyboard.gtheme      keyboard overlay layout
```

### 4.7 Retro emulator assets (`com.xiaoji.egggame.common.retro_emulators/`)

```
files/emulator/
├── index.html                          WebView shell (JSBridge bridge — see §9.4)
└── nostalgist.0.19.0.umd.js            Nostalgist.js retro emulator engine
drawable/
├── DarkA/B/DPad/L1/L2/R1/R2/Menu/Select/Start/X/Y.png  dark theme buttons
├── LightA/B/... .png                   light theme buttons
├── check_on/off.svg
├── feature_emulators_ic_add/delete/more.xml
├── ic_import.xml
├── ic_search_empty.png
├── local_retro_game_default.png
└── rom_placeholder.png
```

**Nostalgist system → RetroArch core map:**

| System | LibRetro core |
|--------|--------------|
| gb / gba / gbc | mgba |
| megadrive | genesis_plus_gx |
| nes | fceumm |
| snes | snes9x |

**Bundled GBA demo ROM URLs (gamebrew.org):** `pnakys_v1.0.zip`, `xniq_alpha.zip`, `arcademaniagba.7z`, `astrohawk_advance.zip`. Cores download at runtime from `https://retro-emulator-download.bigeyes.com/retroarch/`.

### 4.8 `unknown/` — embedded files

- **Google Play Services properties:** `play-services-{auth,basement,base,cloud-messaging,fido,measurement-*[6 variants],stats,tasks,ads-identifier,auth-api-phone,auth-base,auth-blockstore,identity-credentials}`
- **Huawei HMS properties:** `HMSCore-{base,baselegacyapi,availableupdate,device,hatool,log,stats,ui}`, `agconnect-core`
- **Firebase / Google properties:** `firebase-{analytics,auth,auth-interop,encoders,encoders-proto,iid-interop,measurement-connector}`, `core-common`, `googleid`, `network-common`, `network-framework-compat`, `network-grs`, `integrity`, `recaptcha`, `hmpublicsuffixes.gz`
- **Protobuf schemas:** `client_analytics.proto` (analytics events), `messaging_event.proto` + `messaging_event_extension.proto` (push), `google/protobuf/{any,api,descriptor,duration,empty,field_mask,java_features,source_context,struct,timestamp,type,wrappers}.proto`
- **`kotlin/`** — Kotlin stdlib metadata (annotation, collections, concurrent, coroutines, internal, ranges, reflect, kotlin.kotlin_builtins)
- **`org/`** — apache, bouncycastle metadata
- **`META-INF/`** — 109 entries: ~100 `.version` files for AndroidX + Compose; `services/java.security.Provider` registers `BouncyCastleProvider` + `BouncyCastlePQCProvider`; `services/io.ktor.serialization.kotlinx.KotlinxSerializationExtensionProvider` registers Ktor JSON; `native-image/okhttp/` GraalVM hints
- **Other:** `DebugProbesKt.bin` (Kotlin coroutine debug probes)

---

## 5. Resources

### 5.1 `res/xml/` — configuration files

| File | Purpose |
|------|---------|
| `device_filter.xml` | USB device whitelist (vendor 13623=GameSir 8 PIDs; 1356=Sony 1 PID DualShock 4; 1452=Apple 1 PID MFi controller) |
| `file_paths.xml` | FileProvider paths (`apk_cache`) |
| `filekit_file_paths.xml` | FileKit cache paths |
| `image_share_filepaths.xml` | Image share FileProvider paths |
| `util_code_provider_paths.xml` | BlankJ UtilsFileProvider — broadest scope (see §11.3) |
| `wbsdk_filepaths.xml` | Weibo SDK FileProvider paths |

### 5.2 `res/font/`

| File | Purpose |
|------|---------|
| `roboto_medium_numbers.ttf` | Roboto Medium Numbers — used by legacy XML views for numeric displays |

### 5.3 Layouts

`res/layout/` contains 88 XML layouts. All non-third-party UI is Compose; XML layouts are for SDK screens (Weibo, Alipay, HMCP, etc.).

### 5.4 Themes & styles → see §20

---

## 6. AndroidManifest

### 6.1 Component counts

| Component type      | Count |
|---------------------|-------|
| Activities          | 35    |
| Services            | 20    |
| Broadcast Receivers | 9     |
| Content Providers   | 10    |
| `uses-permission`   | 44    |

### 6.2 Multi-process layout

| Process | Role |
|---------|------|
| Default (`com.xiaoji.egggame`) | Main app, MainActivity, all foreground UI |
| `:wine` | `WineActivity` (Wine game session) + `EmuFileService` (sensorLandscape, separate JVM) |
| `:p0` | `com.mob.pushsdk.impl.MobLReceiver` (MobPush long-poll receiver) |

### 6.3 Key activities

**App-defined:**
- `com.xiaoji.egggame.MainActivity` — main entry (singleTask, landscape)
- `com.xiaoji.egggame.DeepLinkActivity` — deep-link dispatcher (noHistory, translucent)
- `com.xiaoji.egggame.features.winemu.WineActivity` — Wine game session (`:wine` process)
- `com.xiaoji.egggame.features.winemu.setup.ui.PcGameSetupComposeActivity` — PC game setup
- `com.xiaoji.egggame.features.auth.data.tencentopenapi.TencentEntryActivity` — Tencent auth
- `com.xiaoji.egggame.features.auth.data.tencentopenapi.QqQrcodeEntryActivity` — QQ QR login
- `com.xiaoji.egggame.wxapi.WXEntryActivity` — WeChat OAuth entry
- `com.xiaoji.egggame.wxapi.WXPayEntryActivity` — WeChat Pay result

**Deep-link schemes handled by `DeepLinkActivity`:**

| Scheme | Source |
|---|---|
| `scheme://epic-auth` | Epic Games auth callback |
| `tencent102667728://` | QQ OAuth callback (also embeds the QQ App ID `102667728`) |
| `genericidp://firebase.auth/` | Firebase generic IdP |
| `recaptcha://firebase.auth/` | Firebase reCAPTCHA |
| `tbopen://` | Taobao/Alipay deep link |

**Third-party auth/payment activities (full list, 27):**

| Group | Activities |
|---|---|
| Alipay | `AlipayResultActivity`, `APayEntranceActivity`, `H5AuthActivity`, `H5OpenAuthActivity`, `H5PayActivity`, `PayResultActivity` |
| WeChat | `WXEntryActivity`, `WXPayEntryActivity` (in `com.xiaoji.egggame.wxapi`) |
| QQ / Tencent | `com.tencent.connect.common.AssistActivity`, `com.tencent.tauth.AuthActivity` |
| Weibo | `com.sina.weibo.sdk.share.ShareTransActivity`, `com.sina.weibo.sdk.web.WebActivity` |
| Firebase | `GenericIdpActivity`, `RecaptchaActivity` |
| Google Sign-In | `SignInHubActivity`, `GoogleApiActivity` |
| HMS Push | `com.huawei.hms.support.api.push.TransActivity` |
| MobID | `com.mob.id.MobIDActivity` |
| FlyID | `cn.fly.id.FlyIDActivity` |
| MobPush | `com.mob.pushsdk.impl.MobPushActivity` |
| Phone-auth (Alibaba) | `LoginAuthActivity`, `AuthWebVeiwActivity`, `PrivacyDialogActivity` |
| Play Core | `PlayCoreDialogWrapperActivity` |
| AndroidX Credentials | `HiddenActivity`, `IdentityCredentialApiHiddenActivity` |
| Compose UI tooling | `androidx.compose.ui.tooling.PreviewActivity` (debug-only) |
| BlankJ utilcode | `UtilsTransActivity`, `UtilsTransActivity4MainProcess` |

### 6.4 Services

**App-defined:**
- `com.xiaoji.egggame.game.domain.install.PcEmulatorAutoUnzipService` — foreground (dataSync)
- `com.xiaoji.egggame.common.winemu.service.EmuFileService` — emulator file management
- `com.xiaoji.egggame.common.steam.cloud.SteamCloudSaveService` — Steam cloud saves
- `com.xiaoji.egggame.common.gamepadota.ble.gamesirg6.dfu.G6DfuService` — GameSir G6 OTA

**Third-party (16 total):**

| Group | Services |
|---|---|
| Firebase | `ComponentDiscoveryService`, `FirebaseMessagingService` |
| Google measurement | `AppMeasurementService`, `AppMeasurementJobService`, `RevocationBoundService`, `metadata.ModuleDependencies` |
| Google datatransport (FCM/Analytics) | `TransportBackendDiscovery`, `JobInfoSchedulerService` (paired with `AlarmManagerSchedulerBroadcastReceiver`) — note: previously mislabeled as Alibaba in earlier passes |
| Huawei AGConnect | `core.ServiceDiscovery` |
| MobPush | `MobPushJobService`, `plugins.fcm.FCMFirebaseInstanceIdService` |
| MobID | `MobIDService` |
| FlyID | `FlyIDService` |
| AndroidX Credentials | `CredentialProviderMetadataHolder` |
| AndroidX Room | `MultiInstanceInvalidationService` |
| BlankJ utilcode | `MessengerUtils$ServerService` |

### 6.5 Broadcast receivers (9)

- `com.xj.muugi.shortcut.broadcast.NormalCreateBroadcastReceiver` — shortcut creation
- `com.xj.muugi.shortcut.special.AutoCreateBroadcastReceiver` — auto-shortcut creation
- `com.mob.pushsdk.impl.MobLReceiver` (`:p0` process)
- `com.mob.pushsdk.impl.NotifyActionReceiver`
- `com.mob.pushsdk.plugins.fcm.FCMFireMessagingReceiver`
- `com.google.firebase.iid.FirebaseInstanceIdReceiver`
- `com.google.android.gms.measurement.AppMeasurementReceiver`
- `com.google.android.datatransport.runtime.scheduling.jobscheduling.AlarmManagerSchedulerBroadcastReceiver`
- `androidx.profileinstaller.ProfileInstallReceiver`

### 6.6 Content providers (10)

- `androidx.core.content.FileProvider` — general file sharing
- `com.blankj.utilcode.util.UtilsFileProvider` — utility file provider
- `com.sina.weibo.sdk.content.FileProviderV2` / `WeiboSDKFileProvider` — Weibo sharing
- `io.github.vinceglb.filekit.dialogs.FileKitFileProvider` — system file picker
- `com.google.firebase.provider.FirebaseInitProvider` — Firebase auto-init
- `androidx.startup.InitializationProvider` — AndroidX Startup
- `org.jetbrains.compose.resources.AndroidContextProvider` — Compose resources
- `com.mob.MobProvider` — MobPush init
- `cn.fly.FlyProvider` — FlyID init

### 6.7 Permissions (44 total)

| Category | Permissions |
|---|---|
| Network | `INTERNET`, `ACCESS_NETWORK_STATE`, `ACCESS_WIFI_STATE`, `CHANGE_NETWORK_STATE` |
| Storage | `MANAGE_EXTERNAL_STORAGE`, `READ/WRITE_EXTERNAL_STORAGE`, `WRITE_MEDIA_STORAGE`, `READ_MEDIA_AUDIO/IMAGES/VIDEO`, `READ_MEDIA_VISUAL_USER_SELECTED` |
| Foreground / process | `FOREGROUND_SERVICE`, `FOREGROUND_SERVICE_DATA_SYNC`, `WAKE_LOCK`, `KILL_BACKGROUND_PROCESSES`, `VIBRATE`, `MODIFY_AUDIO_SETTINGS`, `WRITE_SETTINGS` |
| Hardware | `BLUETOOTH_SCAN` (neverForLocation), `BLUETOOTH_ADVERTISE`, `BLUETOOTH_CONNECT`, `NEARBY_DEVICES`, `android.hardware.usb.host`, `android.hardware.bluetooth` (optional), `android.hardware.bluetooth_le` (required), OpenGL ES 2.0 (required) |
| Identity / auth | `USE_BIOMETRIC`, `USE_FINGERPRINT`, `READ_PHONE_STATE`, `POST_NOTIFICATIONS`, `REQUEST_INSTALL_PACKAGES` |
| Advertising / analytics | `ACCESS_ADSERVICES_AD_ID`, `ACCESS_ADSERVICES_ATTRIBUTION`, `com.google.android.gms.permission.AD_ID`, `READ_GSERVICES`, `BIND_GET_INSTALL_REFERRER_SERVICE` |
| Launcher shortcuts | `INSTALL_SHORTCUT`, `UNINSTALL_SHORTCUT`, `READ_SETTINGS`, `WRITE_SETTINGS` (com.android.launcher + com.bbk.launcher2) |
| App-defined | `com.xiaoji.egggame.permission.C2D_MESSAGE`, `com.xiaoji.egggame.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION`, `com.google.android.c2dm.permission.RECEIVE` |
| Vendor-launcher | `com.android.permission.GET_INSTALLED_APPS` (newly noted in 6.0) |

---

## 7. DEX / Java Package Map

### 7.1 DEX content summary

| DEX file       | Smali classes | Primary content                          |
|----------------|---------------|------------------------------------------|
| classes.dex    | 10,367        | androidx, android, alipay, blankj, bumptech, google |
| classes2.dex   | 6,832         | com.google (GMS, Firebase, protobuf, haima.hmcp) |
| classes3.dex   | 8,143         | com.winemu, com.xiaoji.egggame (cloud/cardsystem), vendor SDKs |
| classes4.dex   | 13,543        | com.xiaoji.egggame (common/, features/, core/) |
| classes5.dex   | 10,650        | com.xiaoji.egggame (home, retro_emulators, launcher), io/ktor, okhttp3, xiaomi push |
| classes6.dex   | 3,518         | uniffi/epickit_core, org.webrtc, org.chromium, org.koin, org.rustls |
| **TOTAL**      | **53,053**    |                                          |

### 7.2 `com.xiaoji.egggame.*` core package tree

```
cardsystem/
  ui/cards/             card data models (43-field Card + supporting — see §9.7)

cloud/
  data/local/           CloudGameDatabase, CloudGameSessionDao, CloudGameSessionEntity
  data/remote/          cloud game API models

common/
  bi/database/          Business intelligence / analytics DB
  epic/
    downloader/         EpicKit download management + recovery governance
    storage/dao+entity/ Epic game local storage (Room)
  gamepadconnect/
    data/dto/           gamepad pairing DTOs
    flow/               connection state machine
    usb/                USB gamepad detection
  gamepadota/
    ble/gamesirg6/dfu/  GameSir G6 BLE DFU service
    ble/jieli/          JieLi BLE OTA
    usb/transport/      USB OTA transport
  steam/
    branch/             Steam branch management
    cloud/              SteamCloudSaveService
    core/               Steam auth core
    data/bean+entity+repository/  Steam data models
    models/app/         Steam app models
    utils/              Steam utilities
  steam_sdk/
    bridge/             Steam SDK JNI bridge
    impl/               SDK implementation
    model/              SDK models
  ui/vjoy/model/        VJoy UI models (see §9.8)
  vjoy/data/            VJoy data layer
  winemu/
    bean/               WinEmu data beans
    data/bean+repository/ WinEmu data layer
    engine/             Wine engine interface
    hud/                HUD data management (HUDConfig serializer)
    loadingtips/        loading screen tips
    service/            EmuFileService
    settings/model/     WinEmu settings models
    trace/collectors/   performance trace collection

core/
  android/base/         Android base classes
  data/                 core data layer
  database/dao+entity/  core Room database
  device/battery/       battery state management
  device/entity/        device info entities
  domain/
    activitytask/model/ in-app task system
    base/               base domain classes
    bi/                 analytics domain
    community/model/    community domain
    device/model/       device domain
    hometab/model/      home tab configuration
    id/                 user identity domain
    leaderboard/model/  leaderboard domain
    model/steam/        Steam domain models
    search/model/       search domain
    unzip/              unzip domain
    upgrade/model/      app update domain
    vjoy/model/         VJoy domain models
  events/               app-wide event bus
  i18n/                 internationalization
  navigation/model/     gamepad / OTA navigation models
  network/model/        full DTO tree (auth, cloud, device, feedback, profile, setting, upgrade, upload, vjoy, vtouch, zonecode) — see §10
  network/token/        JWT token management
  util/                 file/jwt/serialization utilities

features/
  auth/data/tencentopenapi/   QQ/Tencent OAuth
  file_selector/platform/     platform file picker
  pay/data+database/          in-app payment (Room)
  profile/model/enums/        profile enums
  vjoy/ui/main/base/          VJoy main UI
  webview/data/activitytask/  webview tasks
  winemu/
    data/remote/              WinEmu API layer
    di/model/scheme/          dependency injection + setting schemes
    input/                    input handling
    launcher/                 game launcher
    perf/                     performance overlay + telemetry
    setup/ui/                 PcGameSetupComposeActivity
    ui/gameSetting/           in-game settings UI

game/
  data/remote/              game API (including CloudGamePlayTimeEntity)
  database/dao+entity/      local game DB
  di/model/                 launchMethod + game DI models
  domain/install/           PC game installation (PcEmulatorAutoUnzipService)
  domain/mobileimport/      mobile game import
  domain/model/             game domain models

home/
  data/remote/              home feed API
  domain/model/             home domain models
  ui/tabs/home+play/        home/play tab screens

launcher/interceptor+model/  launcher interceptor logic

retro_emulators/
  data/local/               RetroGameDatabase + DAOs
  data/remote/              RetroGameStatsReArgs, RetroGameStatsEntity (API)
  domain/model/             RetroGameCheat
  ui/                       RetroEmulatorWebView (Compose + WebView hybrid)
  util/setting/             retro game settings

wxapi/                      WeChat OAuth + Pay entry activities
```

### 7.3 `com.winemu.*` package

`com.winemu.*` is unchanged from 5.x. Full tree under `smali_classes3/com/winemu/`:

```
com.winemu.core/
  gamepad/              GameSir integration
  input/                input event handling (TapHandler.InitPoint)
  server/
    alsaserver/         ALSAClient (3 native methods — see §3.2)
    environment/        Wine environment setup
      plugins/          NetworkInfoUpdatePlugin
    socket/             ClientSocket, XConnectorEpoll (see §3.2)
    sysvshm/            SysVSharedMemory (see §3.2)
  steam_agent/          AgentCmd, StatusData, SteamAgentTicketIssuer
  trans_layer/          Box64Config, FEXConfig, FEXConfigData, FEXJsonConfig,
                        LocalizedName, TemplateBoxConfig, TemplateFexConfig,
                        TemplateConfigType (4 presets: Compatibility/Stable/Performance/Extreme)
  utils/                EnvVars (only named class)

com.winemu.openapi/     a, b, c, d, e, f (obfuscated), CASEffect,
                        Config (GPUDriver/Resolution/SteamGameInfo),
                        GPUConfig, HDREffect

com.winemu.ui/          BootLogView, DirectRendering, DirectRenderingActivationView,
                        HUDConfig, HUDLayer, StatusData, TapHandler,
                        UnifiedHUDView, X11View, XServer
```

**Box64 supported env vars** (com.winemu.core.utils.EnvVars):
`CPUNAME`, `CPUTYPE`, `AVX`, `MMAP32`, `UNITY`, `X11GLX`, `IGNOREINT3`, `NOBANNER`, `NORCFILES`, `RDTSC_1GHZ`, `DYNACACHE`, `DYNACACHE_FOLDER`, `DYNACACHE_MIN`, `DYNAREC`, `DYNAREC_ALIGNED_ATOMICS`, `DYNAREC_BIGBLOCK`, `DYNAREC_CALLRET`, `DYNAREC_DF`, `DYNAREC_DIRTY`, `DYNAREC_DIV0`, `DYNAREC_FASTNAN`, `DYNAREC_FASTROUND`, `DYNAREC_FORWARD`, `DYNAREC_NATIVEFLAGS`, `DYNAREC_PAUSE`, `DYNAREC_SAFEFLAGS`, `DYNAREC_STRONGMEM`, `DYNAREC_VOLATILE_METADATA`, `DYNAREC_WAIT`, `DYNAREC_WEAKBARRIER`, `DYNAREC_X87DOUBLE`

**FEX-Emu supported env vars:**
`FORCESVEWIDTH`, `HALFBARRIERTSOENABLED`, `HIDEHYPERVISORBIT`, `HOSTFEATURES`, `MAXINST`, `MEMCPYSETTSOENABLED`, `MONOHACKS`, `MULTIBLOCK`, `OUTPUTLOG`, `PROFILESTATS`, `SILENTLOG`, `SMALLTSCSCALE`, `SMCCHECKS`, `TSOENABLED`, `VECTORTSOENABLED`, `VOLATILEMETADATA`

### 7.4 `com.winemu.openapi.Config` — per-game Wine launch config (from `Config.java`)

Fields: `runMode`, `exePath`, `gameRootDir`, `virtualContainer`, `resolution (width/height)`, `gpuDriver (isCustomDriver + customPath)`, `gpuConfig (vendorId + deviceId)`, `gpuMemoryLimitInMB`, `sysMemoryLimitInMB`, `hostCoreLimit`, `hostCoreMask`, `audioDriver`, `box64Config`, `fexConfig`, `bootParams`, `dllOverrides`, `envVars`, `localeCode`, `steamAppId`, `steamGameInfo`, `winedebugParams`, `surfaceFormat`, `logPath`, `inGameHud`, `enableESync`, `enableMangoHUD`, `enableOnScreenKeyboard`, `enableRDCDebug`, `enableWinMonitor`, `enableLogHttpServer`, `disableReshade`, `disableWM`, `bypassAVDecode`, `debugMode`.

**Post-processing effects:**
- `CASEffect.sharpness` — Contrast Adaptive Sharpening strength
- `HDREffect(HDRPower, radius1, radius2)` — HDR tone-mapping overlay

### 7.5 Surviving `com.xj.*` classes (2 only)

```
com.xj.muugi.shortcut.broadcast.NormalCreateBroadcastReceiver
com.xj.muugi.shortcut.special.AutoCreateBroadcastReceiver
```

All other `com.xj.*` classes (winemu utils, common entity, etc.) have moved to `com.xiaoji.egggame.*`.

### 7.6 Compose nav routes (`AppNavKey`) — 119 destinations

Organized by feature group:

```
App / meta:    Home, HomeProfile, HomeTabPortrait, Splash, AppVersionDialog,
               Search, ZoneCodePicker, VerifyId
Auth:          AuthLoginAll, AuthLoginSmsOrEmail, AuthAliOneKey, DeleteAccount
Profile:       ProfileCenter, ProfileEditAll, PushActivityPage
Settings:      SettingContent, SettingTheme, AboutSettings, HelpSettings,
               PrivacySettings, NotificationSettings, FeedbackSettings,
               FeedbackHistorySettings, StorageManager, DeveloperDebug,
               NetworkDebug, ScreenAdaptDebug, ScreenRatioSetting,
               DeviceInfoSettings, MyDevicePage
Game:          GameDetail, GameNewWeb, LocalGameDetail, ProductWiki,
               MobileGameImport, CustomRecommendation
PC / WinEmu:   PcGameSetup, PcGameCompatibilitySetting, PcGameComponentDependence,
               PcGameDeveloperOptions, PcGameGeneralSetting, PcGameKeymap,
               PcGameRestoreSetting, PcGameSchemeDetail, PcGameSchemeEditor,
               PcGameSchemeTranslationParameters, PcGameSettingEntrance,
               PcGameSteamSetting, PcGameTranslationParameters,
               PcSchemeHome, PcImportEdit, LaunchConfig, LaunchConfigSelection,
               WinEmuEnvList, WinEmuEnvSetting, SwitchModeDialog
Steam:         SteamLogin, SteamLoginDeviceConfirmation, SteamLoginGuardVerification,
               SteamProfileScreen, SteamSwitchAccountScreen
Cloud gaming:  CloudGameDetail, CloudSetting, CloudNormalSetting,
               CloudContorlSetting, CloudOrderCenter,
               CloudRechargeCenterSheet, CloudRechargeCenter
Gamepad:       GamepadConfigEntry, GamepadConfigSetting, GamepadCoolerSetting,
               GamepadDeviceConnectPage, GamepadDeviceListPage,
               GamepadFunctionSetting, GamepadKeyMapping, GamepadKeyMappingP1,
               GamepadKeySetting, GamepadKeySettingP1, GamepadLightSetting,
               GamepadMappingTarget, GamepadMotionSetting, GamepadOta,
               GamepadTriggerSetting, GamepadVibrationSetting,
               GamepadCalibrationGuide, GamepadTestBig, GamepadTestInputAll,
               GamepadTestKeyboard, GamepadTestP1, GamepadTestTelescopic,
               OtaSelectPage, KeyboardMappingTarget, CoolerSettingDialog
VJoy:          VJoyMain, VJoyMainSheet, VJoyEdit, VJoyIconFolder,
               VJoyHudMain, VJoyHudEdit, VJoyHudIconFolder,
               VJoySetting, VJoyTest
Retro:         RetroGames, RetroEmulatorPlayer, RetroGameDetail, RetroGameArchive,
               RetroGameCheatAdd, RetroGameCheatList, RetroGameImport,
               RetroGameSetting
XGP / Store:   XgpRedemption, CommonRedemption, RedeemCenter, RedemptionCenter
Community:     CommunityDialog, CommunityCodeDialog
Downloads:     DownloadConfirmation, DownloadManagerPage
Utility:       FileSelector, EmojiPicker, WebView
```

---

## 8. Application Entry Points

### 8.1 Application class — `AndroidApp` extends `BaseAndroidApp`

Manifest declares `android:name="com.xiaoji.egggame.AndroidApp"`. `AndroidApp` is a 19-line concrete subclass that only overrides `b()` to return `new nh(this)`; all real work is in `BaseAndroidApp.onCreate()`.

### 8.2 Init sequence (`BaseAndroidApp.onCreate`, line numbers from jadx source)

| Step | Line | Action |
|---|---|---|
| 1 | 165 | `FirebaseApp.initializeApp(this)` — Firebase first (Crashlytics + Analytics auto-init via `FirebaseInitProvider`) |
| 2 | 178 | `registerActivityLifecycleCallbacks(gm3Var)` — 1st lifecycle observer |
| 3 | 188 | `MMKV.initialize(this, MMKVLogLevel.LevelInfo)` |
| 4 | 190 | `registerActivityLifecycleCallbacks(new gm3(1))` — 2nd lifecycle observer |
| 5 | 235 | `ApplicationDSLExtKt.startKoinWith(...)` — Koin DI: 22 prebuilt modules + 19 inline `ModuleDSLKt.module$default(...)` calls in this file (~30+ more from `us2.smali` feature-DI factory; total app modules ≈ 70–80) |
| 6 | 259+266 | Coil singleton image loader (`KoinPlatformTools.INSTANCE`) |
| 7 | 315 | `registerActivityLifecycleCallbacks(new t6g(new bsh(), ...))` — 3rd lifecycle observer (UI state tracker) |
| 8 | 325–392 | EGL14 GPU renderer probe: `eglGetDisplay` → `eglInitialize` → `eglChooseConfig` → `eglCreateContext` → `eglCreatePbufferSurface` → `eglMakeCurrent` → `glGetString(VENDOR/RENDERER)` → `eglDestroySurface`/`Context`/`Terminate` cleanup |

Imports tied to init order: `android.opengl.{EGL14, EGLConfig, EGLContext, EGLDisplay, EGLSurface, GLES20}`, `com.google.firebase.FirebaseApp`, `com.mob.pushsdk.MobPush`, `com.tencent.mmkv.{MMKV, MMKVLogLevel}`, `org.koin.mp.KoinPlatformTools`. MobPush registration (`MobPush.addPushReceiverInMain` at line 142) is invoked from a helper, not the main init flow.

### 8.3 `MainActivity` (com.xiaoji.egggame)

- Extends `GamepadInputHostActivity` (gamepad/joystick input base)
- Screen-orientation management via SharedPreferences
- **Deep-link intent extras** (full set, 11 keys): `app_nav_target` (route name), `app_nav_game_id`, `app_nav_game_type`, `app_nav_launch_type`, `app_nav_steam_app_id`, `app_nav_epic_app_name`, `app_nav_source_type`, `app_nav_source_id`, `app_nav_source_slug`, `app_nav_auto_start_game`, `app_nav_return_to_wine`

---

## 9. Subsystems

### 9.1 WinEmu (Wine emulation core)

#### 9.1.1 Component categories (live, from on-device registry)

`EnvLayerEntity.type` integer mapping:

| `entity.type` | Category | Examples |
|---|---|---|
| `1` | Translator (FEX + Box64) — disambiguated by `name` prefix downstream | `Fex_*`, `Box64-*` |
| `2` | GPU driver | `Adreno_*`, `turnip_*`, `qcom-*` |
| `3` | DXVK | `dxvk-*`, `wined3d8.0` |
| `4` | VKD3D | `vkd3d-proton-*` |
| `5` | Per-game settings packs **+ Steam agents** | `Hzd_Settings`, `Cyberpunk`, `steamagent`, `SteamAgent2` |
| `6` | Runtime dependency / `isBase=true` | `vcredist*`, `cjkfonts`, `directshow`, ... |
| `8` | Steam clients (was `7` in 5.3.5) | `steam_client_0403` |

`ComponentType` enum (com.xiaoji.egggame.common.winemu.bean): `TRANSLATOR(1)`, `GPU(2)`, `DXVK(3)`, `VKD3D(4)`, `GENERAL(5)`, `DEPENDENCY(6)`, `STEAMCLIENT_RUNTIME(8)`.

`EnvLayerEntity.getType()` returns boxed `Integer` (nullable, not primitive) — confirmed at `l13.smali:1615`. `isBase=true` is set only when `entity.type==6` (`l13.smali:1639–1646`). The `Translator` enum (`FEX="1"`, `Box64="2"`) is **separate** from `EnvLayerEntity.type`; both translators share `entity.type=1`, the enum value selects the backend in container settings.

#### 9.1.2 Translator settings (per-game)

**Box64 settings** (TranslationSetting subclasses, all extending base):

| Class | Type | Values |
|-------|------|--------|
| `AlignedAtomicsSetting` | switch | on/off |
| `BigBlockSetting` | option | 0–3 |
| `Box64AVXSetting` | option | 0–2 |
| `CallRetSetting` | switch | on/off |
| `CpuTypeSetting` | option | 0–1 |
| `DFSetting` | switch | on/off |
| `DirtySetting` | option | 0–2 |
| `DIV0Setting` / `DynarecSetting` / `FastNanSetting` / `FastRoundSetting` / `IgnoreINT3Setting` / `NativeFlagsSetting` | switch | on/off |
| `PauseSetting` | option | 0–3 |
| `RDTSC1GHZSetting` / `WaitSetting` / `X87DoubleSetting` / `VolatileMetadataBox64Setting` | switch | on/off |
| `SafeFlagsSetting` | option | 0–2 |
| `StrongMemSetting` | option | 0–3 |
| `WeakBarrierSetting` | option | 0–2 |

**FEX settings:**

| Class | Type | Values |
|-------|------|--------|
| `HalfBarrierTSOEnabledSetting` / `HideHypervisorBitSetting` / `MemcpySetTSOEnabledSetting` / `MonoHacksSetting` / `MultiblockSetting` / `SmallTSCScaleSetting` / `TSOEnabledSetting` / `VectorTSOEnabledSetting` / `VolatileMetadataSetting` / `X87ReducedPrecisionSetting` | switch | on/off |
| `MaxInstSetting` | input | numeric |
| `SMCChecksSetting` | option | "none", "mtrack", "full" |

**Translator config holders:**

| Class | Notes |
|-------|-------|
| `Box64TranslatorConfig` | Implements `ITranslatorConfig`; 25+ fields aggregating all Box64 settings |
| `FEXTranslatorConfig` | Implements `ITranslatorConfig`; 20+ boolean/int fields |
| `TranslationSetting` | Abstract base — options, defaults, types |
| `TranslatorConfigs` | Composite: `box64` + `fex` |
| `TranslatorTabItem` | `tabs` (List\<ITranslatorConfig\>) + `updateFlag` |
| `BoxOptions` / `FexOptions` | Singletons holding option arrays for dropdowns |
| `Translator` enum | `Box64("2")`, `FEX("1")` |
| `TranslatorConstant` | Preset config names + IDs |

#### 9.1.3 Repo / component beans

| Class | Fields |
|---|---|
| `EnvLayerEntity` | 19 — environment layer (component) data |
| `EnvRepo` | `name`, `version`, `state` (State), `entry` (EnvLayerEntity) |
| `WinEmuRepo` | 8 — extends `EnvRepo` with `RepoCategory` + `depInfo` |
| `ComponentRepo` | `name`, `version`, `state`, `entry`, `isDep`, `isBase`, `depInfo` |
| `ComponentRecorder` | `name`, `version`, `broken` |
| `EnvInstallEvent` | `repo` (EnvRepo), `state` (EnvInstallState), `progress` |
| `EnvListData<T>` | `list`, `page`, `pageSize`, `total` |
| `LocalPcGameManifest` | 12 — local game manifest |
| `RefreshGameDownloadUrlEntity` | `id`, `downUrl` |

#### 9.1.4 State enums

| Enum | Values |
|---|---|
| `State` | None, Downloaded, Extracted, NeedUpdate, INSTALLED |
| `GameState` | None(0), Downloaded(1), INSTALLED(2), VERIFIED(4), VERIFYING(8), UNZIPPING(16) — bitfield |
| `Translator` | Box64("2"), FEX("1") |
| `EnvInstallState` | Installation states for Wine environment |
| `WinEmuInstallState` | Wine emulator installation states |
| `RepoCategory` | Component repository category |
| `SettingType` / `WineInGameSettingType` / `WineSettingScope` | Setting classification (global vs game-specific) |
| `GamePadState` | Gamepad connection/configuration states |
| `InstalledGameSource` | Source of installed game (local/steam/epic/gog/etc.) |
| `NativeRenderingMode` | Native rendering configuration modes |
| `RedMagicPerformanceMode` | ROG/RedMagic device performance profiles |
| `FileTypeValues` | GAME, IMAGE_FS, WINE, COMPONENT, GENERAL_COMPONENT, DEP_COMPONENTS, STEAM_CLIENT, STEAM_CLIENT_RUNTIME |
| `FileStatusValues` | NORMAL, DOWNLOADED, INSTALLED, UN_ZIP, CAN_UPGRADE |
| `FrameworkType` | TYPE_X64, TYPE_ARM64X |

#### 9.1.5 Setting / game beans (selected)

| Class | Fields |
|---|---|
| `FpsLimit` | `enable` (bool), `fpsLimit` (int) |
| `SuperResolution` | `enable`, `sharpness` (float) |
| `NativeRendering` | `mode` (NativeRenderingMode) |
| `KeyControlsAlpha` | `alpha` (float) |
| `GamepadSensitivity` | `sensitivity` (float) |
| `PcEmuControllerEntity` | `dinput`, `xinput`, `xboxLayout`, `vibration` (4 booleans) |
| `PcEmuGameLocalConfig` | 8 fields — fps, display, hud, etc. |
| `PcEmuGameModeEntity` | 9 fields |
| `PcEmuGameModeDetailEntity` | `id`, `name`, `translations`, `localConfigId` |
| `PcEmuGameModeDetailTranslationEntity` | 22 |
| `PcSettingEntity` / `PcSettingItemEntity` / `PcSettingDataEntity` | 3 / 3 (+ 80 type constants) / 11 |
| `PcSettingEnvEntity` | `key`, `value` |
| `PcSettingKeyMappingEntity` | `type`, `id`, `title`, `isSelect` |
| `PcSettingResetEntity` | `name`, `curValueString`, `defaultValueString` |
| `PcSettingDefaultValue` | 14 default-value constants |
| `WineActivityData` | 23 |
| `GamePad` | abstract — `Physical`, `Virtual`, `PlaceHolder` subclasses |
| `WrapInputDevice` | `inputDevice` (InputDevice), `noGamePad`, `virtualGamePad` |
| `ExeInfo` | `name`, `path`, `icon` (Bitmap) |
| `SubData` | `subFileName`, `subDownloadUrl`, `subFileMd5` |
| `DialogSettingListItemEntity` | 22 — UI item for download/settings |
| `CollapseItemMenu` | `title`, `isCheck` |
| `ShowDownloadOptionEvent` | `archView`, `position`, `item` |

#### 9.1.6 Storage / cache beans

| Class | Fields |
|---|---|
| `ComputeStorageCache` | `lastComputeTime`, `totalSize`, `availableSize`, `mediaSize`, `totalGameSize` (5 longs) |
| `GamesSizeCache` | `lastComputeTime`, `sizeMap` (Map\<String, Long\>) |
| `DownloadTasks` | `downloadingTasks`, `downloadSoonTasks`, `completedTasks` |
| `DownloadUIItem` | `task` (dr4), `title`, `subTitle`, `content` |
| `FileOperationEvent` | `fileId`, `fileName`, `version`, `fileType`, `status` |
| `DepComponentChildDownloadEvent` | `depComponents`, `state`, `isDepChildFail`, `throwable` |
| `GameStateRepo` | `gameId`, `name`, `state` (GameState), `version` |

#### 9.1.7 PC game setting scheme system

The scheme system allows saving, sharing, and applying per-game Wine configuration presets. Schema version `2`.

| Class | Fields |
|---|---|
| `PcGameSettingSchemeIndex` | `schemaVersion(2)`, `records`, `appliedSchemeByGame`, `appliedSchemeIdByGame` |
| `PcGameSettingScheme` | `record`, `jsonString`, `payload` |
| `PcGameSettingSchemeRecord` | 10 — `localId`, `gameId`, `name`, `schemeFilePath`, `sourceType`, `remoteSchemeId`, `shareCode`, `createdAt`, `updatedAt`, `lastAppliedAt` |
| `PcGameSettingSchemePayload` | 17 — `containerId`, `componentIds`, `translations`, `componentDependencies`, `dinputLibrary`, `skipAvDecode`, `surfaceFormat`, `audioDriver`, `cpuLimitations`, `videoMemory`, `startParam`, `environment`, `startupFilePath`, `gpuUseBuiltin`, `dxvkUseBuiltin`, `vkd3dUseBuiltin`, `translatorUseBuiltin` |
| `PcGameSettingSchemeTranslations` | `box64`, `fex` |
| `PcGameSettingSchemeComponentDependency` | 6 — `id`, `name`, `version`, `fileName`, `fileMd5`, `fileSize` |
| `PcGameSettingSchemeValidationResult` | `isValid`, `message`, `normalizedJson`, `payload` |
| `AppliedSchemeIdentity` | 6 — `localId`, `remoteId`, `shareCode`, `schemeName`, `appliedPayloadHash`, `appliedSettingsHash` |
| `PcGameSettingSchemeApplyResult` | sealed: `Success` (7 fields) / `Failure` (`reason`, `cause`) |

**Remote scheme classes:**

| Class | Fields |
|---|---|
| `SchemeDetailEntity` | 25 — `id`, `title`, `configBody`, `sourceType`, `isOfficial`, `isRecommend`, `status`, `weight`, `downloadCount`, `activeUserRatio`, `downloadRatio`, `matchLevel`, `matchLevelLabel`, `gpuGroupName`, `shareUserAvatar`, `createdBy`, `updatedBy`, timestamps, `titleLangParam`, `isCommon` |
| `SchemeShareEntity` | `id`, `shareCode`, `sourceGameId`, `sourceType` |
| `SchemeShareRequest` | `id`, `gameId`, `sourceGameId`, `sourceType`, `title`, `configBody` |
| `SchemeShareInfo` | `remoteSchemeId`, `shareCode`, `sourceGameId`, `sourceType` |
| `DeleteRemoteSchemeRequest` | `id` (int) |
| `ReportConfigApplyRequest` | `id` (long) |

`PcGameSettingSchemeSourceType` enum: `Local(0)`, `Imported(1)`, `Official(2)`, `Recommended(3)`, `CloudShared(4)`.

#### 9.1.8 In-game sidebar UI

User-facing sidebar string keys (all extracted from `res/values/strings.xml`):

**HUD / performance metrics:**
- `winemu_sidebar_hud_cpu` / `_gpu` / `_ram` / `_power` / `_tmp` / `_fps` — toggle each metric
- `winemu_sidebar_hud_graph` — FPS graph toggle
- `winemu_sidebar_hud_opacity` — HUD transparency
- `winemu_sidebar_hud_vertical_layout` (+ `_desc`) — vertical metric stack
- `winemu_sidebar_hud_display` — master HUD toggle

**Visual / display:**
- `winemu_sidebar_super_resolution` — Super resolution upscaling
- `winemu_sidebar_sharpness` — CAS sharpness
- `winemu_sidebar_crt_effect` — CRT visual filter
- `winemu_sidebar_hdr` — HDR tone-mapping
- `winemu_sidebar_fullscreen` — Fullscreen game toggle
- `winemu_sidebar_enable_screen_brightness` + `winemu_sidebar_system_brightness` — manual brightness
- `winemu_sidebar_power_multiplier` — Dual-battery power fix

**Controls / session:**
- `winemu_sidebar_controls_title`, `winemu_sidebar_default_layout`, `winemu_sidebar_custom_layout_example`, `winemu_sidebar_more_layouts`, `winemu_sidebar_switch_mapping_scheme` — gamepad layouts
- `winemu_sidebar_virtual_gamepad`, `winemu_sidebar_simulate_touch_screen` — touch controls
- `winemu_sidebar_key_opacity` — touch controls opacity
- `winemu_sidebar_mouse_speed` — mouse speed
- `winemu_sidebar_gamepad_manage_subtitle` — "Configure gamepad and change order"
- `winemu_sidebar_enable_fps_limit` + `winemu_sidebar_fps_limit` — FPS limit
- `winemu_sidebar_performance_title` — performance group header
- `winemu_sidebar_system_volume` — system volume
- `winemu_sidebar_exit` — exit game

**Loading state strings:** `winemu_loading_client_starting`, `winemu_loading_desktop_entry`, `winemu_loading_game_starting`.

**Cloud save:** `features_winemu_cloud_save_download_*` / `_sync_*` / `_upload_*`.

**Setup workflow:** `winemu_setup_*` (checks for container, Steam client, components; download base/dependency components).

**Log server:** `winemu_log_server_info_*` (local network HTTP logging server for debugging).

#### 9.1.9 Component dropdown dispatch — read/write paths

Settings dropdowns (FEXCore / Box64 / DXVK / VKD3D / GPU pickers) do **not** read `sp_winemu_unified_resources.xml` directly. They consume an in-memory cache (`Ll9o;->c`) populated by API + XML cache layers.

**Read-side accessor:** `Ll9o;->z(RepoCategory)ArrayList<WinEmuRepo>` (`l9o.smali:4388`):

```
public z(RepoCategory cat) {
    ConcurrentHashMap<String, WinEmuRepo> map = (ConcurrentHashMap) l9o.c;
    ArrayList<WinEmuRepo> out = new ArrayList<>();
    for (WinEmuRepo r : map.values())
        if (r.getCategory() == cat) out.add(r);
    return out;
}
```

**Companion methods on `l9o`:**

| Method | Signature | Purpose |
|---|---|---|
| `o()` | `()Ll9o;` | Singleton accessor (`d:Ll9o;` static field) |
| `B()` | `(RepoCategory, String)String` | Build pref key `"<CategoryName>:<repoName>"` |
| `x()` | `(RepoCategory, String)WinEmuRepo` | Single-get by name |
| `z()` | `(RepoCategory)ArrayList<WinEmuRepo>` | List-by-category |
| `G()` | `(WinEmuRepo)V` | Write-through to host registry (calls `y99.b`) |
| `A()` | `()Map` | Generic unmodifiable view (legacy / non-registry overload) |

`l9o` is held as a constructor field by `gxh.<init>(Ll9o;Lfzh;Lh9a;)V` and `jjn.<init>(Application, Ll9o;, Lh9a;, Lvaa;, Lnaa;, Lfzh;, Lgxh;, Ly99;)V`.

**Diagnostic (2026-04 ComponentDiagnosticPatch):** when a per-game picker opens, neither `Ll9o;->z` nor `Ldh7;-><init>` fires. Picker reads from already-populated Compose state. Active fires: `gxh.a` (Kotlin suspend function), `m13.b` (returns `COROUTINE_SUSPENDED`), `o61.r` (Composable wrapper), `v86.b` (picker Composable), `nhn.f`. Implications:
- `Ll9o;->z` is **not** the dropdown feed despite its clean shape
- `Ldh7;` is constructed once on app/game load, then cached
- No surface-level non-suspend method takes the assembled `List<EnvLayerEntity>` as parameter or immediate return value

**Registry write side:** `Ly99;->b(WinEmuRepo)V` writes a single repo to `sp_winemu_unified_resources.xml` at key `"<RepoCategory.name()>:<repo.getName()>"`, JSON-serialized via `Lob9;->c(Object)String`. Sequence: `getCategory().name()` → `repo.getName()` → key string → `getSharedPreferences().edit()` → `putString(key, json)` → `remove(repo.getName())` → `apply()`. Writes are **per-key, additive** — server never bulk-clears.

**Recommended write strategy for manager-injected components** (after empirical confirmation that read-side hooks fail):

- **Write key:** `COMPONENT:<userComponentName>`
- **Write value:** JSON shaped like a host entry: top-level `{category, depInfo, entry{...}, isBase, isDep, name, state, version}`; `entry` populated with `type` (FEX/Box64=1, GPU=2, DXVK=3, VKD3D=4, settings=5, runtime-dep=6), `name`, `version`, `fileType=4`, `fileName="<name>.tzst"`, `state="Extracted"`, `status=0`, plus markers `_bh_injected:true`, `_bh_skip_md5:true`, `_bh_source_uri`, `_bh_added_at`
- Re-write on every Component Manager open (idempotent, defends against future server pruning)
- Sidecar pref `sp_bh_components.xml` retained for our own bookkeeping (which entries we injected — for uninstall/badging UX)

#### 9.1.10 Other component-pipeline classes

| Class.method | Role |
|---|---|
| `Lt76;->invoke()` | Lazy provider for `sp_winemu_unified_resources` SharedPreferences |
| `Ll13;->invokeSuspend(Object)Object` | Coroutine state machine for `m13.b` — calls `simulator/v2/getAllComponentList`, parses `List<EnvLayerEntity>`, wraps each as `WinEmuRepo(... entity, RepoCategory.COMPONENT, isBase=type==6, ...)`. Result feeds `l9o.c` cache |
| `Ldxh;->invoke()` | Per-repo readiness check — logs `WinEmuModule queryReadyState name=<name> repo=<name> version=<v>` |

#### 9.1.11 Interfaces

| Interface | Purpose |
|---|---|
| `IEmuContainer` | Container management |
| `IWinEmuService` | WinEmu service ops |
| `ITranslatorConfig` | Abstract translator config (Companion serializer) |
| `SwitchableSetting` | `getEnable` / `setEnable` |
| `WineSettingCodec` | Inner `Bool`, `Json` |

---

### 9.2 Steam Integration

#### 9.2.1 `SteamInstalledAppMetadata` (22 fields)

```kotlin
data class SteamInstalledAppMetadata(
    val appId: Int, val installDirPath: String, val buildId: Int,
    val isInCopying: Boolean, val branch: String, val displayName: String,
    val iconHash: String, val verticalCover: String,
    val depots: List<SteamInstalledAppMetadataDepot>,
    val hasInstallScripts: Boolean,
    val installScripts: Map<String, List<String>>,
    val unKnowInstallScripts: Map<String, List<String>>,
    val launchInfo: Any,
    val isUpdateTask: Boolean?, val updateDownloadSize: Long?,
    val updateProgress: Int?, val updateSize: Long?,
    val downloadedSize: Long, val installedSize: Long,
    val totalDownloadSize: Long, val totalInstallSize: Long,
    val updatedAtMillis: Long
)
```

`SteamInstalledAppMetadataDepot` (4 fields): `parentAppId` (int), `depotId` (int), `manifestId` (long), `installScriptPath` (String?).

#### 9.2.2 Steam Bridge (`com.xiaoji.egggame.common.steam_sdk`)

| Class | Role |
|---|---|
| `SteamBridgeClient` | Main bridge client |
| `SteamBridgeTransport` (interface) | Transport abstraction |
| `AndroidSteamBridgeTransport` | Android implementation |
| `SteamBridgeNative` | JNI bridge to libsteamkit_core.so |
| `SteamBridgeEvent` | Event type definitions |
| `NativeBridgeError`, `NativeBridgeEvent`, `NativeBridgeResponse` | Native bridge DTOs |
| `NativeOperationStart`, `NativeOperationPoll` | Async operation control |

**50+ request/response DTOs:** `AppDetailsDto`, `AuthErrorDto`, `AuthStateDto`, `BranchOptionDto`, `CloudSyncReportDto`, `DownloadProgressEventDto`, `GameLaunchInfoDto`, `PersonaDto`, etc.

#### 9.2.3 `SteamDownloadStatus` constants

| Status | Value |
|--------|-------|
| Waiting | 0 |
| Preparing | 1 |
| Downloading | 2 |
| Paused | 3 |
| Cancel | 4 |
| Finished | 5 |
| Fail | 6 |
| DownloadingConfigFile | 7 |
| Resuming | 11 |
| Installing | 12 |
| DownloadSoon | 13 |

#### 9.2.4 Additional Steam DTOs (`com.xiaoji.egggame.common.steam`)

`SteamBranchPreference`, `SteamAccountInfo`, `SteamPlatformStats`, `SteamPlatformStatsResponse`, `BindingsListResponse`, `SteamBindingRequest`, `SteamUnbindRequest`, `ThirdPartyBindingInfo`, `AppDownloadInfo`, `AppMetadata`, `DepotInfo`, `SteamDownloadStatus`, `PlatformGameItem`, `PlatformGameLibData`, `PlatformGameLibResponse`.

#### 9.2.5 `PlatformGameItem` (51 fields — largest single API entity)

`id`, `sysLanguageId`, `platform`, `type`, `tagId`, `isGame`, `name`, `titleDesc`, `logo`, `coverImage`, `backImage`, `videoUrl`, `screenshot`, `otherDesc`, `description`, `aiDesc`, `packageStr`, `packageStrIos`, `status`, `weight`, `createdTime`, `updatedTime`, `ageRating`, `company`, `releaseDate`, `watchNum`, `channelId`, `isChannel`, `shareLink`, `fromId`, `fromType`, `isPay`, `price`, `payPrice`, `classifyId`, `topCategoryId`, `steamAppId`, `steamType`, `fullGameId`, `fullGameName`, `fileSize`, `webpmStatus`, `compatibilityId`, `fileMd5`, `squareImage`, `xboxProdId`, `filter`, `reviewPercentage`, `playTime`, `releaseDateNormalized`, `topCategoryTags`.

---

### 9.3 Epic Games (EpicKit)

`libepickit_core.so` is a Rust library exposed to Java via **UniFFI** (Mozilla's cross-language FFI). Provides a full Epic Games Store SDK at `uniffi/epickit_core/` (160+ Java files).

**Epic OAuth Client ID:** `34a02cf8f4414e29b15921876da36f9a` (hardcoded in smali_classes4).
**API path:** `epic_data/epickit` (POST relay) plus 9 GET paths under `epic_data/` for recovery governance JSONs (see §12.2.6).
**XGP redemption:** `gamehub-service-dev.xiaoji.com/xgp/exchange` and `xgp.xiaoji.com` portal.

#### 9.3.1 Cloud Save records

| Class | Fields / Values |
|---|---|
| `EpicCloudSaveSyncDecisionRecord` | enum: NONE, UPLOAD, DOWNLOAD, SKIPPED_UPLOAD_DISABLED, SKIPPED_DOWNLOAD_DISABLED, SKIPPED_NO_LOCAL_SAVE, SKIPPED_NO_REMOTE_SAVE |
| `EpicCloudSaveSyncStateRecord` | enum: NO_SAVE, SAME_AGE, LOCAL_NEWER, REMOTE_NEWER |
| `EpicCloudSaveSyncOptionsRecord` | `localDirOverride`, `forceUpload`, `forceDownload`, `skipUpload`, `skipDownload`, `cleanLocalBeforeDownload` |
| `EpicCloudSaveSyncReportRecord` | `appName`, `localDir`, `state`, `decision`, `localTimestamp`, `remoteTimestamp`, `remoteManifest`, `uploaded`, `downloaded`, `summary` |
| `EpicCloudSaveUploadReportRecord` | `appName`, `filesRequested`, `filesUploaded`, `bytesUploaded` |
| `EpicCloudSaveDownloadReportRecord` | `appName`, `outputDir`, `manifestsDownloaded`, `filesRestored`, `chunksDownloaded`, `bytesDownloaded` |
| `EpicCloudSaveCleanupReportRecord` | `appName`, `filesSeen`, `manifestsSeen`, `keptManifest`, `filesDeleteAttempted`, `filesDeleted`, `filesDeleteFailed` |
| `EpicCloudSaveManifestRecord` | `appName`, `manifestName`, `manifestPath`, `lastModified` |

#### 9.3.2 Download records

| Class | Fields |
|---|---|
| `EpicDownloadJobStateRecord` | enum: QUEUED, RUNNING, PAUSED, VERIFYING, COMPLETED, FAILED_RETRYABLE, FAILED_TERMINAL, CANCELLED |
| `EpicDownloadModeRecord` | enum: INSTALL, UPDATE, REPAIR |
| `EpicDownloadRunModeRecord` | enum: AUTO, INSTALL, UPDATE, REPAIR |
| `EpicDownloadJobRecord` | 21 — `version`, `jobId`, `requestedAppName`, `resolvedAppName`, `title`, `platform`, `label`, `installDir`, `manifestSha1`, `chunkBaseUrl`, `chunkBaseUrls`, `state`, `failureCount`, `retryNotBefore`, `lastError`, `createdAt`, `updatedAt`, `progress` |
| `EpicDownloadJobProgressRecord` | 11 — `phase`, `filesTotal`, `filesCompleted`, `chunksTotal`, `chunksCompleted`, `bytesDownloaded`, `bytesWritten`, `visibleBytesWritten`, `estimatedDownloadBytes`, `elapsedMs`, `speedBytesPerSecond` |
| `EpicDownloadJobCreateRequestRecord` | `jobId`, `requestedAppName`, `title`, `platform`, `label`, `installDir` |
| `EpicDownloadJobStartRequestRecord` | 23 — `runMode`, `includePrefixes`, `excludePrefixes`, `installTags`, `maxConcurrency`, `maxRetries`, `retryBackoffMs`, `chunkRequestTimeoutMs`, `memoryChunkCacheEntries`, `keepChunkCache`, `forceRedownload`, `disablePatching`, `disableDelta`, `oldManifestSha1`, `manifestOverride`, `deltaManifestOverride`, `oldManifestOverride`, `chunkBaseUrlOverride`, `downloadOnly`, `retainCompletedDownloadOnlyJob`, `updateOnly`, `withDlcs`, `skipDlcs` |
| `EpicDownloadAnalysisRecord` | 17 — `requestedAppName`, `resolvedAppName`, `platform`, `label`, `manifestSha1`, `previousManifestSha1`, `mode`, `fromCache`, `downloadBytes`, `reusableBytes`, `installBytes`, `removedBytes`, `deleteFiles`, `addedFiles`, `changedFiles`, `removedFiles`, `unchangedFiles` |
| `EpicDownloadTerminalStatusRecord` | `state`, `errorMessage` |
| `EpicResolvedManifestRecord` | 10 — `requestedAppName`, `resolvedAppName`, `platform`, `label`, `manifestUrl`, `chunkBaseUrl`, `manifestSha1`, `baseUrls`, `fromCache`, `manifestBytes` |
| `EpicSizeEstimateRecord` | `downloadBytes`, `installBytes`, `fromCache` |

#### 9.3.3 Metadata / catalog records

| Class | Fields |
|---|---|
| `EpicActivationStoreRecord` | enum: UBISOFT, EA |
| `EpicActivationReportRecord` | `appName`, `title`, `store`, `activationUri`, `alreadyActivated`, `message` |
| `EpicGameAssetRecord` | `appName`, `namespace`, `catalogItemId`, `buildVersion`, `labelName`, `assetId`, `sidecarRev` |
| `EpicGameImageRecord` | `imageType`, `url` |
| `EpicKeyValueRecord` | `key`, `value` |
| `EpicManifestComparisonRecord` | `added`, `removed`, `changed`, `unchanged` (all List\<String\>) |
| `EpicMetadataSyncReportRecord` | `requested`, `updated`, `failed`, `updatedCatalogItemIds` |
| `EpicOfferIdentityRecord` | `offerId`, `offerType`, `productSlug`, `namespace` |

#### 9.3.4 SDK / session records

| Class | Fields |
|---|---|
| `EpicSdkOptions` | `configDir`, `apiTimeoutSecs`, `locale`, `country`, `sessionBackend`, `accountId` |
| `EpicStatusSnapshotRecord` | `configDir`, `loggedIn`, `sessionCount`, `installedCount`, `accountId`, `displayName` |
| `EpicCleanupReportRecord` | `removedManifestBlobs`, `removedManifestIndexEntries`, `removedDownloadJobs`, `removedTmpEntries`, `clearedSizeEstimateEntries` |
| `EpicVerifyReportRecord` | `appName`, `checkedFiles`, `matchedFiles`, `missingFiles`, `mismatchedFiles`, `totalBytes` |

#### 9.3.5 Exception types

`EpicException` (abstract):
- `EpicException.Message` (`details: String`)
- `EpicException.NotAuthenticated`
- `EpicException.SessionNotFound` (`accountId: String`)

#### 9.3.6 Recovery governance system (com.xiaoji.egggame.common.epic.downloader)

Full state machine for EGS download failure recovery.

**Enums:** `EpicRecoveryGovernanceExecutionState` (Triggered, Suppressed, Blocked, ManualRequired), `EpicRecoveryGovernanceExecutionReason`, `EpicRecoveryGovernanceExecutionStrategy`, `EpicRecoveryGovernancePromptType`, `EpicRecoveryGovernancePromptState`, `EpicRecoveryGovernanceDirectiveMode`, `GovernancePromptEscalationLevel`.

**Data classes:** `EpicRecoveryGovernanceDirective`, `EpicRecoveryGovernanceDirectiveExecutor`, `EpicRecoveryGovernancePlan`, `EpicRecoveryGovernanceDirectiveExecutionApprovalStateRecord`, `EpicRecoveryGovernanceDirectiveExecutionAuditStateRecord`, `EpicRecoveryGovernanceDirectiveExecutionOutcomeRecord`, `EpicRecoveryGovernanceDirectiveExecutionReasonRecord`, `EpicRecoveryGovernanceWorkflowStepRecord`, `EpicRecoveryGovernanceWorkflowStepStateRecord`, `EpicRecoveryManualAction`, `EpicRecoveryReviewAction`.

State configurations are loaded at runtime from 9 JSON endpoints under `epic_data/epic_recovery_governance_*.json` (see §12.2.6).

---

### 9.4 Retro Emulation (new in 6.0)

The retro emulation feature runs emulators inside a WebView using **Nostalgist.js 0.19.0** (RetroArch compiled to WebAssembly). Cores are downloaded on demand from `https://retro-emulator-download.bigeyes.com/retroarch/`.

**Supported systems:** GB, GBA, GBC (mGBA), NES (fceumm), SNES (snes9x), Mega Drive (genesis_plus_gx).

#### 9.4.1 Local ROM database (Room)

```sql
CREATE TABLE retro_games (
    game_id TEXT PRIMARY KEY,
    game_name TEXT, game_icon TEXT,
    core_type TEXT,          -- e.g. "mgba", "fceumm", "snes9x"
    platform TEXT,           -- e.g. "gba", "nes", "snes"
    file_path TEXT, is_import INTEGER,
    created_at INTEGER, updated_at INTEGER
)
CREATE TABLE retro_game_sessions (
    session_id TEXT PRIMARY KEY, game_id TEXT,
    duration_seconds INTEGER, started_at INTEGER, last_updated_at INTEGER
)
-- plus retro_game_stats (server-synced stats)
```

#### 9.4.2 WebView ↔ Java JS bridge

The retro emulator WebView (`assets/composeResources/com.xiaoji.egggame.common.retro_emulators/files/emulator/index.html`) exposes a `window.JSBridgeApi` Java-callable surface and posts back to Java via `window.JSBridge.postMessage(jsonString)`.

**`window.JSBridgeApi` methods (Java → JS):**

| Method | Notes |
|---|---|
| `launch(config)` | async — start emulator with config (system, core URL, ROM path, save path) |
| `saveState()` | async — capture current state as bytes |
| `loadState(stateData)` | async — restore from save state |
| `restart()` | async — reset emulator |
| `pause()` / `resume()` / `isPaused()` | playback control |
| `sendFastForward()` | toggle FF mode |
| `screenshot()` | async — capture frame |
| `exit()` | shut down emulator |
| `keyEvent(keyConfig)` | async — inject input |
| `applyCheat(payloadJson)` / `toggleCheat(...)` / `removeCheat(...)` | cheat-code management |

**JS → Java:** `window.JSBridge.postMessage(JSON.stringify({...}))` — single-channel JSON-message bus for events (cheat result, error, lifecycle).

**Features:** save states (archive), cheat codes, gamepad button mapping (dark/light theme button images), retro game stats reporting to server.

---

### 9.5 Cloud Gaming (VTouch + Haima HMCP)

Cloud gaming has two distinct stacks: VTouch (XiaoJi's own cloud-PC backend) and Haima HMCP (third-party SDK). Both are accessible from the same UI but route differently.

#### 9.5.1 VTouch — `vtouch/startType` + `cloud/*`

**Catalog routes** (under `clientgsw.vgabc.com/clientapi/`):
- `vtouch/startType` — query cloud-gaming launch mode
- `cloud/game/auth_token`, `cloud/game/start_token`, `cloud/game/renew_token` — session lifecycle
- `cloud/game/exit`, `cloud/game/check_user_timer` — session end + remaining-time check
- `cloud/game/getQueueInfo`, `cloud/game/startQueue`, `cloud/game/getQueueCalendar` — queue management
- `cloud/game/getGoodsListV2`, `cloud/game/getNewsList`, `cloud/game/getNewsDetail`, `cloud/game/confirmPlay` — store / info / confirmation
- `cloud/order/info`, `cloud/order_list`, `cloud/payment` — billing
- `cloud/app/exchange_code`, `cloud/h5/exchange_code?uuid=` — activation codes
- `cloud/use_time_log` — play-time reporting
- `cloud/notify/apple` — Apple push for cloud gaming
- `cloud_sign/getActivity`, `cloud_sign/sign` — daily sign-in (under separate `cloud_sign/` namespace, listed here for proximity)

**Local DB:** `cloud_game_sessions.db` — `cloud_game_sessions` + `cloud_timer` tables track session duration for reporting.

#### 9.5.2 Haima HMCP — third-party SDK

SDK version: `master-7.40.1` (libhaima_rtc_so.so). Package root: `com.haima.hmcp.*`.

| Sub-package | Content |
|---|---|
| `hmcp/beans/` | 200+ bean/DTO classes (cloud session, IME, gamepad, streaming, WebSocket) |
| `hmcp/model/` | Model classes (`ArmMouseModel`, `JoystickInputModel` enum, `TvModel` enum, `VibratorModel`) |
| `hmcp/cloud/` | Cloud session management (`AckOrderBean`, `CloudFileConfig`) |
| `hmcp/device/input/manager/` | `AbstractDeviceInputManager` interface, `TcMouseManager` |
| `hmcp/device/input/operate/` | `AbstractDeviceOperate` interface |
| `hmcp/device/input/view/` | `TcMouseView` (24f, 13m) |
| `hmcp/device/input/sender/` | `AbsHMInputSender` (3f, 4m) |
| `hmcp/language/` | `AbsLanguageManager` (2f, 5m) |
| `hmcp/listeners/` | Listener interfaces for streaming/input events |
| `hmcp/fastjson/` | 138+ Alibaba FastJSON classes (bundled JSON parser) |
| `hmcp/protobuf/` | 60+ Protobuf message classes (bundled Google Protobuf) |
| `hmcp/websocket/` | 15+ WebSocket classes (Connection, Manager, Reader) |
| `hmcp/volley/` | Google Volley HTTP classes (bundled) |
| `hmcp/utils/` | Utility classes |
| `hmcp/widgets/` | UI widget classes |
| `hmcp/business/` | Business logic |

**Key bean classes (selected):**

| Class | Fields | Notes |
|---|---|---|
| `AckOrderBean` | 26 | Cloud session acknowledgment |
| `ArmMouseModel` | 26 | ARM mouse control |
| `IntentExtraData` | 16 | Intent payload for session handoff |
| `JoyStickBean` | 48 | Full virtual joystick state |
| `JoyStickMappingConfig` | 35 | Joystick button mapping config |
| `VideoDelayInfo` | 30 | Streaming latency data — see §9.5.3 |
| `WebSocketConfig` | 11 | WebSocket connection config |
| `X86KeyMapContentConfig` | 12 | x86 keyboard mapping |
| `X86TouchConfig` | 13 | x86 touch input |
| `X86ScreenSlideConfig` | 5 | Screen slide |
| `TouchesMappingConfig` | 6 | Touch mapping |
| `BaseWsMessage` / `BaseWsMessage4JsonParse` | 5 / 5 | Base WS messages |
| `CapScreenData` | 1 | Screen capture |
| `CommonPayloadDataQueues` | 2 | Payload queues |
| `IMEBean` / `IMESwitchCallbackResult` | 2 / 5 | IME state |
| `InstanceMessage` | 6 | Instance control |
| `Joypad` | 13 | Physical joypad descriptor |
| `JoinBattleResult` | 11 | Battle session join |
| `RecommendInfo` | 5 | Stream-quality recommendation |
| `RelaunchGameBean` | 2 | Game relaunch request |
| `ScreenInfo` | 11 | Screen resolution/orientation |
| `TokenTimeStampModel` | 3 | Auth token + timestamp |
| `WsUploadDownloadBean` | 5 | WS upload/download state |

**Key enums / models:**

| Class | Notes |
|---|---|
| `JoystickInputModel` | 31-field enum — full virtual gamepad state |
| `SwitchStreamTypeData` | 16-field enum — stream-type switching |
| `TvModel` | 6-field enum — display/TV mode |
| `VirtualOperateType` | NONE, VIRTUAL_KEYBOARD, VIRTUAL_STICK_XBOX |

**Analytics (Countly):**

| Config | Value |
|---|---|
| Host | `https://countly.haimacloud.com` |
| API key | `9c0edb3f80d8d9adc71bb544b6dc87743340e829` |
| App ID (foreground) | `12040` |
| App ID (background) | `12041` |
| Additional event IDs | 100+ in range 12050–15489 |

#### 9.5.3 `VideoDelayInfo` — 30 streaming-latency fields

`bitRate`, `clockDiffUse`, `decodeDelay`, `frameSize`, `jankAndFreezeDuration`, `netDelay`, `realFrameRateOutput`, `renderDelay`, `timeStamp`, `videoFps`, `delayTime`, `nowDelayTime`, `receiveFrameCount`, `receiveFrameSize`, `gameFps`, `gameRealFps`, `frameRateEglRender`, `serverEncodeDelay`, `videoCaptureDelay`, `videoEncodeDelay`, `videoDecodeDelay`, `videoRenderDelay`, `audioCaptureDelay`, `audioEncodeDelay`, `audioDecodeDelay`, `audioRenderDelay`, `jitterDelay`, `haimaCpu`, `systemCpu`, `delayFromVideoCapToDecoded`.

#### 9.5.4 `JoyStickBean` button bitmask constants

| Constant | Value | Button |
|---|---|---|
| `JOY_KEY_UP` | 1 | D-pad up |
| `JOY_KEY_DOWN` | 2 | D-pad down |
| `JOY_KEY_LEFT` | 4 | D-pad left |
| `JOY_KEY_RIGHT` | 8 | D-pad right |
| `JOY_KEY_START` | 16 | Start |
| `JOY_KEY_SELECT` | 32 | Select |
| `JOY_KEY_LS` | 64 | Left stick click |
| `JOY_KEY_RS` | 128 | Right stick click |
| `JOY_KEY_L1` | 256 | LB |
| `JOY_KEY_R1` | 512 | RB |
| `JOY_KEY_A` | 4096 | A |
| `JOY_KEY_B` | 8192 | B |
| `JOY_KEY_X` | 16384 | X |
| `JOY_KEY_Y` | 32768 | Y |

Analog: `L_X`, `L_Y`, `R_X`, `R_Y` (float), `L2AxisValue`, `R2AxisValue` (Float). Threshold `MOTION_INVALID_VALUE = 0.004921628f`.

#### 9.5.5 `GetCloudServiceParametersV2` — 40+ fields

- **String:** `action`, `appChannel`, `appName` (JSON: `"pkg_name"`), `cToken`, `channel`, `cloudId` (JSON: `"cid"`), `componentName`, `gameId`, `resolution`, `routingIp`, `viewFrameRate`, `viewResolution`, `timeZone`
- **Integer:** `bitRate`, `clientImeType`, `clientType`, `componentType`, `frameRate`, `orientation`, `streamingMode`
- **Boolean:** `ahead`, `demoTest`, `freeFlowTag`, `isArchive`, `isReapply`, `support2k`, `syncRefresh`, `h264SeiDataReportEnable`
- **Complex:** `sdkAbility` (long[]), `sdkUserDeviceInfo` (JSONObject), `streamingTypes` (List\<String\>), `extraData` (IntentExtraData), `userInfo` (UserInfo2)

#### 9.5.6 `CloudPlayInfo` — 16 connection-state booleans

`isGetStreamUrlSuccess`, `isGetCloudServiceSuccess`, `isGetOperationFiveSuccess`, `isTurnOnVideoSuccess`, `isVideoConnectSuccess`, `isAudioConnectSuccess`, `isSignalConnectSuccess`, `isReceiveOffer`, `isSendAnswer`, `isSendCandidate`, `isReceiveCandidate`, `isWebrtcConnectSuccess`, `isWebrtcConnectFailed`, `isWebrtcConnectTimeout`, `isFirstFrameArrival`, `isMatchStreamType`. Plus `pingCount`, `pongCount` (int), `reportStatusCode` (String), `isStatusCodeEnable` (boolean).

**HMCP scene strings:** 60+ (`applyCloudInstance`, `battle`, `firstFrameArrival`, `gameMaintenance`, etc.). Color palette: 29 entries (`haima_hmcp_black`, `haima_hmcp_red`, etc.).

The HMCP virtual input overlay also provides an Xbox controller add dialog (`hm_dialog_add_xbox.xml`), virtual keyboard dialog (`hm_dialog_fullkeyboard.xml`), virtual key edit dialog, mouse control, and cloud computer overlay — used for both PC streaming and cloud gaming.

---

### 9.6 In-App Payment (new in 6.0)

In-app payment combines Apple IAP receipt verification (for iOS-purchased content carryover) with WeChat Pay for Android transactions, plus a Room-backed retry queue for failures.

**Database:** `db_pending_payment_v1.db` — schema fingerprint `f18683c410e5cd9d73a45330d5a1fb69`.

```sql
CREATE TABLE pending_payment (
    order_no TEXT PRIMARY KEY,
    receipt_data TEXT NOT NULL,
    product_id TEXT NOT NULL,
    goods_id TEXT NOT NULL,
    transaction_id TEXT,
    created_at INTEGER NOT NULL,
    retry_count INTEGER NOT NULL,
    last_retry_at INTEGER,
    last_error TEXT
)
```

**WeChat Pay error codes** (`WXPayEntryActivity`):

| Code | Meaning |
|---|---|
| 0 | Success |
| -1 | Failed |
| -2 | Cancelled |

**Active WeChat App IDs:**
- Primary: `wx2075ef952b9b60c4`
- Secondary: `wxf9d9756e4f820261`

**Alipay App ID:** `2021005104662679`.

---

### 9.7 Card System (new in 6.0)

`com.xiaoji.egggame.cardsystem` — mini game launcher / promotional content system. All card data is `kotlinx.serialization`-encoded.

#### 9.7.1 `Card` model — 43 fields (extracted from `Card$$serializer.java`)

| # | Field | Required? |
|---|---|---|
| 1 | `leaderboard_info` | required (nullable) |
| 2 | `card_param` | required |
| 3 | `card_tag` | required |
| 4 | `game_op_tag` | required |
| 5 | `card_type` | required |
| 6 | `content_img` | required |
| 7 | `currency_symbol` | required |
| 8 | `discount` | required |
| 9 | `company` | required |
| 10 | `discount_price` | required |
| 11 | `end_time` | required |
| 12 | `game_back_image` | required |
| 13 | `hero_capsule` | optional |
| 14 | `game_channel_params` | required |
| 15 | `game_cover_image` | required |
| 16 | `game_price` | required |
| 17 | `review_score` | required |
| 18 | `game_startup_params` | required |
| 19 | `game_tag` | required |
| 20 | `game_type` | required |
| 21 | `game_show_types` | optional |
| 22 | `game_video_url` | required |
| 23 | `id` | required |
| 24 | `is_pay` | required |
| 25 | `jump_type` | required |
| 26 | `platform` | required |
| 27 | `release_text` | required |
| 28 | `square_image` | required |
| 29 | `subtitle` | required |
| 30 | `sys_language_id` | required |
| 31 | `title` | required |
| 32 | `topic_id` | required |
| 33 | `weight` | required |
| 34 | `news_publisher` | required |
| 35 | `news_published_time` | required |
| 36 | `news_content` | required |
| 37 | `steam_app_id` | required |
| 38 | `fallback_icon` | optional |
| 39 | `server_game_id` | optional |
| 40 | `source_id` | optional |
| 41 | `source_type` | optional |
| 42 | `epic_app_name` | optional |
| 43 | `classify_icons` | optional |

#### 9.7.2 Supporting models

| Class | Purpose |
|---|---|
| `CardData` | Card container |
| `CardListData` | Paginated card list |
| `CardTag` | Card category/tag |
| `GameChannelParam` | Game channel parameters |
| `GameStartupParam` | Game launch configuration |
| `LeaderboardInfo` | Leaderboard metadata |
| `NewDetail` | Detail panel data |
| `OpTags` | Operation tags |
| `StartExt` | Launch extensions |

Fonts: AlimamaShuHeiTi Bold, D-DIN Pro (6 weights), MiSans (cardsystem module).

---

### 9.8 Virtual Joystick (VJoy)

`InputMapping` (sealed base in `com.xiaoji.egggame.common.ui.vjoy.model`) with 5 nested types for binding virtual controls to physical input:

| Type | Maps to |
|---|---|
| `InputMapping.Directional` | analog stick / D-pad direction |
| `InputMapping.Gamepad` | physical gamepad button |
| `InputMapping.Keyboard` | keyboard key |
| `InputMapping.Macro` | multi-input macro sequence |
| `InputMapping.Mouse` | mouse button / movement |

#### 9.8.1 Layout / control data classes (full field lists)

| Class | Fields |
|---|---|
| `VJoyLayout` | `formatVersion` (opt), `id`, `name`, `b.i` (opt), `meta` (opt), `controls` (opt) — 6 |
| `VJoyControl` | `id`, `type`, `position`, `appearance` (opt), `mapping` (opt, field name `HmInputMappings.FIELD_MAPPING`), `properties` (opt) — 6 |
| `VJoyIconConfig` | `iconName`, `displayName` (opt), `scale` (opt), `tint` (opt), `alpha` (opt), `scaleMode` (opt) — 6 |
| `ControlPosition` | `x`, `y`, `width` (opt), `height` (opt), `scale` (opt), `rotation` (opt), `anchor` (opt) — 7 |
| `ControlAppearance` | 30 — see below |
| `MacroConnection` | `id`, `fromNodeId`, `toNodeId` — 3 |

**`ControlAppearance` — 30 fields** (all optional except as noted): `label`, `fillColor`, `strokeColor`, `strokeWidth`, `alpha`, `activeAlpha`, `shape`, `cornerRadius`, `sides`, `stickFillColor`, `stickStrokeColor`, `stickStrokeWidth`, `innerIcon`, `outerIcon`, `activeInnerIcon`, `activeOuterIcon`, `icon`, `activeIcon`, `interactionStyles`, `activeColor`, `idleStrokeColor`, `pressedStrokeColor`, `pressedFillColor`, `glowWidth`, `stickIdleStrokeColor`, `stickPressedFillColor`, `stickPressedStrokeColor`, `stickGlowWidth`, `labelIdleColor`, `labelPressedColor`.

#### 9.8.2 UI model enums (`com.xiaoji.egggame.common.ui.vjoy.model`)

| Enum | Values |
|---|---|
| `GamepadButton` | A, B, X, Y, LB, RB, LT, RT, Select, Start, DpadUp, DpadDown, DpadLeft, DpadRight, LeftStick, RightStick, LeftStickClick, RightStickClick |
| `ControlType` | Button, Joystick, Trigger, Bumper, DPad, Touchpad |
| `ControlShape` | Shape definitions for virtual controls |
| `DPadDirection` | Up, Down, Left, Right, UpLeft, UpRight, DownLeft, DownRight |
| `Anchor` | Positioning anchors for VJoy UI elements |
| `KeyboardButton` | Keyboard key mappings for virtual keyboard |
| `IconScaleMode` | Icon scaling strategies |
| `InteractionStyle` | User interaction style definitions |
| `VJoyLayoutType` | Common, Game |

#### 9.8.3 Event consumers + callbacks

`VJoyButtonEventConsumer`, `VJoyAxisEventConsumer`, `VJoyDPadEventConsumer`, `VJoyEventCallbacks`, `VJoyEvent`, `VJoyLayoutSaveReceipt`, `MacroNode`, `LocalizedString`, plus chrome defaults: `VButtonChromeDefaults`, `DPadChromeDefaults`, `JoystickChromeDefaults`, `TouchpadChromeDefaults`.

---

### 9.9 In-Game Performance HUD

The HUD overlay (`com.winemu.ui.HUDLayer`) is populated by polling each metric on a timer via `HudDataProvider`. Full details in `gamehub_reports/GAMEHUB_HUD_DATA_SOURCES.md`.

#### 9.9.1 `HudData` model

```kotlin
data class HudData(
    val ramPercent:        Int,
    val gpuPercent:        Int,
    val fps:               Int,
    val cpuPercent:        Int,
    val isCharging:        Boolean,
    val powerMW:           Float,
    val tempC:             Float,
    val isDirectRendering: Boolean,
    val fpsHistory:        List<Int>
)
```

`HUDConfig` (8 boolean toggles, default true except `dualBattery`):
`showGPU`, `showCPU`, `showRAM`, `showPower`, `showTemperature`, `showFPS`, `showFPSGraph`, `dualBattery`.

`HudData` (com.xiaoji.egggame.common.winemu.bean — Compose mirror): `ramUsagePercent`, `gpuUsagePercent`, `fps`, `cpuUsagePercent` (int), `isCharging` (bool), `powerMilliwatts`, `temperatureCelsius` (float), `isDirectRenderingEnabled` (bool), `fpsHistory` (List\<Float\>).

#### 9.9.2 Data sources

| Metric | Source | API / Path |
|---|---|---|
| Battery % | Android `BatteryManager` | `getIntProperty(4)` — BATTERY_PROPERTY_CAPACITY |
| Battery watts | `BatteryManager` + `BATTERY_CHANGED` | `voltage_mV × current_µA / 1,000,000` (×2 if charging) |
| Charging state | `BATTERY_CHANGED` broadcast | `Intent.getIntExtra("plugged")` |
| GPU load % | Qualcomm KGSL sysfs | `/sys/class/kgsl/kgsl-3d0/gpubusy` (Adreno only) |
| RAM % | `ActivityManager` | `getMemoryInfo()` → (total − avail) / total × 100 |
| Temperature | sysfs thermal zone scan | `/sys/class/thermal/thermal_zoneN/temp` (19 paths tried) |
| FPS | WinEmu native (JNI) | `IHudDataProvider.c()` via `libwinemu.so` |
| Direct Rendering | WinEmu native (JNI) | `IHudDataProvider.b()` via `libwinemu.so` |

---

### 9.10 Performance Telemetry

In-process performance samples flow through a 3-layer wire format from the WinEmu HUD backend to the analytics endpoint at `events/device-performance-config` (Firebase datatransport).

#### 9.10.1 `CapturedPerfSample` — 13 fields (in-memory snapshot)

`userId`, `agreement`, `gameId`, `sourceType`, `sourceGameId`, `capturedAtWallClockMs`, `sessionDurationSec`, `fps` (int), `pwr` (float, watts), `ramMb` (int), `gpuPercent` (int), `cpuPercent` (float), `tmpCelsius` (int).

#### 9.10.2 `StoredPerfSample` — 16 fields (locally persisted with retry envelope)

Adds `schemaVersion` (optional, default 1) + `seq` (sequence id) on top of the `CapturedPerfSample` field set.

#### 9.10.3 `DevicePerfReportDataDto` — 13 fields (wire DTO, snake_case)

`agreement`, `gameId`, `source_type`, `source_game_id`, `fps`, `pwr` (float), `ram`, `gpu`, `cpu` (float), `tmp`, `session_duration`, `session_id`, `config` (`PerfConfigBodySnapshot` — optional).

#### 9.10.4 `DevicePerfReportEventDto` — outer envelope

`event_type`, `userId`, `data` (the `DevicePerfReportDataDto`).

#### 9.10.5 `PerfSessionMeta` — 12 fields (session-level metadata)

`schemaVersion` (opt), `sessionId`, `userId`, `agreement`, `gameId`, `sourceType`, `sourceGameId`, `sessionStartElapsedMs`, `sessionStartWallClockMs`, `configSnapshot`, `configAcked` (opt), `pendingCount` (opt).

#### 9.10.6 `PerfConfigBodySnapshot` — 12 fields (config in effect during session)

`container_id`, `component_ids`, `translations` (`PerfTranslationsSnapshot` — `box64`/`fex` opt), `controller` (`PerfControllerSnapshot` — `dinput`/`xinput`/`xboxLayout`/`vibration` opt), `audio_driver`, `cpu_limitations`, `video_memory`, `directx_panel`, `start_param`, `environment`, `surface_format`, `disable_window_manager`.

---

## 10. DTO Inventory

### 10.1 Base response wrappers (`core/network/model/`)

| Class | Fields |
|---|---|
| `BaseResult<T>` | `code` (Int?), `msg` (String?), `time` (String?), `data` (T?) |
| `BasePageResult<T>` | `list` (List\<T\>?), `total` (Long?), `page` (Int?), `pageSize` (Int?) |
| `BaseFirmwareResult<T>` | `status` (Int?), `update_time` (Int?), `update_status` (Long?), `data` (T?) |
| `RefreshResponse` | `code`, `msg`, `data` (RefreshResponseData?), `time` |
| `RefreshResponseData` | `access_token`, `refresh_token` |

### 10.2 Auth DTOs (`auth/dto/`)

| Class | Fields |
|---|---|
| `EmailLoginRequestDto` | `email`, `captcha` |
| `SmsLoginRequestDto` | `mobile`, `captcha`, `zone` |
| `OneMobileLoginRequestDto` | `accessToken` |
| `SendSmsCodeRequestDto` | `mobile`, `event`, `zone` |
| `BindMobileRequestDto` | `mobile`, `captcha`, `zone` |
| `UpdateMobileRequestDto` | `mobile`, `captcha`, `zone` |
| `ThirdPartyLoginRequestDto` | `platform`, `openid`, `extinfo?`, `openkey?`, `secretkey?`, `unionid?`, `access_token?` |
| `RemoteUserDto` | 28 — `id`, `username`, `nickname`, `mobile`, `avatar`, `avatar_colour`, `allow_sms_notice`, `allow_other_notice`, `allow_friend_notice`, `allow_video_notice`, `allow_reduce_notice`, `cloud_timer`, `uuid`, `third_platform`, `keyPrompt`, `guide`, `bio`, `firstLogin`, `verify_email`, `realname_auth_status`, `is_realname_authenticated`, `email`, `friend_num`, `access_token`, `refresh_token`, `device_id`, `device_type`, `bound_platforms` |
| `RemoteUserBoundPlatformDto` | 21 — `platform`, `nickname`, `email`, `openid`, `unionid`, `uid`, `sub`, `app_id`, `client_id`, `avatar`, `avatar_url`, `gender`, `locale`, `country`, `province`, `city`, `status`, `linked_at`, `last_login_at`, `unlinked_at`, `profile_json` |

### 10.3 Profile DTOs (`profile/dto/`)

| Class | Fields |
|---|---|
| `ProfileUpdateRequestDto` | `bio`, `username`, `avatar`, `avatar_colour` |
| `BindEmailRequestDto` | `email`, `captcha` |
| `EmailCaptchaRequestDto` | `email`, `event` |
| `VerifyIdAuthRequestDto` | `real_name`, `id_card` (Chinese real-name verification) |

### 10.4 Device / gamepad DTOs (`device/dto/`)

| Class | Fields |
|---|---|
| `DeviceMenuRequestDto` | `devices_id` |
| `GetDevicesRequestDto` | `devices_name` |
| `TutorialNetworkDto` | `id`, `name` |
| `GetDevicesSubMenuDto` | `menu_id`, `name`, `logo_img_active`, `logo_img_gary`, `jump_url`, `is_click` |
| `SubMenuItemDto` | `menu_id`, `name`, `logo_img_active`, `logo_img_gary`, `jump_url`, `is_click`, `sub_config` |
| `ProductDocNetworkDto` | `id`, `name`, `list` |

**`SubConfigDto`** — gamepad controller configuration (70+ fields):
- **Trigger:** `leftTriggerDeadZone`, `rightTriggerDeadZone`, `leftTriggerPressed`, `leftTriggerSync`, `rightTriggerPressed`, `rightTriggerSync`
- **Joystick:** `leftDeadZone`, `leftOriginalZone`, `leftSwopDPad`, `lJsInversionXAxis`, `lJsInversionYAxis`, `lJsReverseDeadZone`, `rightDeadZone`, `rightOriginalZone`, `rJsInversionXAxis`, `rJsInversionYAxis`, `rJsReverseDeadZone`, `joystickSwap`, `inversionXYAxis`, `diagonalLock`
- **Mode:** `leftQuickMode`, `rightQuickMode`, `layoutType`, `leftGrip`, `rightGrip`, `leftTrigger`, `rightTrigger`, `experienceGrip`, `experienceTrigger`
- **Lighting:** `lightingEffect`, `leftLightRingColor`, `rightLightRingColor`, `buttonLights`, `homeLight`, `lampStripLight`, `lightRingSync`
- **System:** `sleepTime`, `lowBatteryDisplay`, `autoOnOffOnDock`
- **Buttons:** `gamepadTest`, `gamepadKey`, `otaUpdate`, `gamepadReset`, `gamepadTutorial`, `productManual`, `l4Mapping`, `r4Mapping`, plus 30+ more

`DeviceInfoDto` (common/gamepadconnect, 21 fields): `id`, `name`, `deviceName`, `deviceImage`, `deviceType`, `firstDeviceType`, `isOfficial`, `connectionFailureText`, `firstStartText`, `keyOperationImage`, `keyOperationIcon`, `quickAccessImage`, `quickAccessIcon`, `gameMuteImage`, `gameMuteIcon`, `devicePermissionsImage`, `devicePopImage`, `deviceConnectionImage`, `adaType`, `extras`, `handleType`.

### 10.5 Feedback DTOs (`feedback/dto/`)

`FeedbackSubmitRequestDto` (11 fields): `account`, `contents`, `images`, `videos`, `mobile_model`, `system_ver`, `app_ver`, `device_model`, `mac_address`, `firmware_ver`, `mapping_text`.

### 10.6 Cloud / VTouch DTOs

- `CloudAppExchangeCodeRequestDto`: `cdkey` (activation code)
- `ModeNoticeDto` (vtouch/dto/): `img`, `title`

### 10.7 Domain models (`core/domain/`)

| Class | Fields |
|---|---|
| `AppUpgrade` | 11 — `id`, `version`, `versionCode`, `channelIds`, `upgradeMsgZh`, `upgradeMsgEn`, `downloadUrl`, `upgradeType`, `fileMd5`, `fileSize`, `createdTime` |
| `SearchRequest` | `keywords`, `classify_group_id?`, `top_category_id?`, `page?`, `page_size?` |
| `SaveInterestTagsRequest` | `game_ids` (List\<Long\>) |
| `LeaderBoardListRequest` | `type`, `category_id?`, `page?`, `page_size?` |
| `LeaderBoardItem` | 12 |
| `PendingActivityTaskContext` | 9 — in-app task/event context |
| `SteamUrlReplaceItem` | `cn`, `global` — URL regional override |
| `EventParam` | `user_id`, `event_type`, `data` |
| `SteamGameLaunchMetadata` | 2 — game launch metadata |
| `ServerGameId` | int value — typed server game ID |
| `LibraryGameId` | String value — typed local game ID |

### 10.8 Game API DTOs (`game/data/remote`)

| Class | Fields | Notes |
|---|---|---|
| `GameDetailEntity` | 34+ | Full game detail: name, description, ageRating, logos, images, videoUrl, screenshot, payPrice, isPay, gameCategory, gameTag, gameStartupParams, notFountCts, cstData, aiDesc, reviewScore, richTextDesc, opTags, platforms, sourceType/sourceId |
| `GameDetailPlatformEntity` | 40+ | Platform variant + parentId, isCurrent, sourceIcon, shareLink, fileSize, fileMd5, libraryCapsule |
| `GameStartupParam` (game) | 13 | startName, startIcon, startEIcon, startSIcon, newIcon, newCIcon, startType, jumpType, isAutoGame, downTypeDesc, startExt, gameFileSize, fileSize |
| `PcGamePlayTimeEntity` | 10 | gameId, steamAppid, sourceGameId, sourceType, gameName, coverImage, squareImage, totalSeconds, last14DaysSeconds, lastStartTime |
| `CloudGamePlayTimeEntity` | 5 | userId, gameId, totalTime, lastStartTime, updateTime |
| `CompatibilityInfo` | 5 | title, icon, desc, level, data (List\<CompatibilityItem\>) |
| `CompatibilityItem` | 4 | title, desc, level, isCheck |
| `GameCategoryGroupsResponse` | 1 | list wrapper |
| `GameCtsReportReArgs` | 5 | gameId, ctsLevel, comment, ctsInfo, generalInfo |
| `ShareLinkEntity` | 2 | sourceType, link |

`LocalGameInfoSvrEntity` (game/domain/model, 10 fields): `gameId` (int), `steamAppid`, `name`, `logo`, `coverImage`, `backImage`, `description`, `squareImage`, `heroCapsule`.

### 10.9 Home API DTOs (`home/data/remote`)

| Class | Fields |
|---|---|
| `RetroGameInfoEntity` | 24 — `id`, `sysLanguageId`, `platform`, `name`, `coverImage`, `videoUrl`, `gameStartupParams`, `retroPlatform`, `gamePrice`, `discountPrice`, `discount`, `currencySymbol`, `steamAppId`, `isPay`, `gameTag`, `weight`, ... |
| `GameStartupParam` (home) | 5 — `startName`, `startType`, `jumpType`, `fileSize`, `startExt` |
| `StartExt` | 4 — `startRes`, `exePath`, `pkgName`, `kernel` |
| `RetroPlatform` | 3 — `id`, `platform`, `platformText` |
| `PlayGameEntity` | 6 — `id`, `title`, `imageUrl`, `tags`, `description`, `isPopular` |
| `UserPlayInfoEntity` | 6 — `username`, `avatarUrl`, `playTimeHours`, `playTimeMinutes`, `isCheckedIn`, `checkInDesc` |
| `RetroGameDetailReArgs` | 1 — `id` (long) |
| `RetroGameListReArgs` | 3 — `classifyGroupType`, `page`, `pageSize` |

### 10.10 WebView activity bridge DTOs (`features/webview`)

| Class | Purpose |
|---|---|
| `ActivityTaskTriggerRequestDto` | Trigger request parameters |
| `ActivityBridgeClientParamsResponse` | Client params from JS bridge |
| `ActivityBridgeStatusResponse` | Activity status |
| `ActivityBridgeTokenResponse` | Auth token for WebView |
| `GamePlayTimeEntry` | Single play session record |
| `GamePlayTimeResponse` | Play time statistics |

The Java↔JS bridge itself is `defpackage.ix` mounted on the WebView as `androidJsBridge` with two `@JavascriptInterface` methods:

| Method | Signature | Notes |
|---|---|---|
| `call(String)` | single-arg JS-call channel | Logs at TRACE; dispatches to internal JS-bridge handler |
| `callAndroid(int, String, String)` | three-arg JS-call channel | Used by older H5 endpoints expecting `(actionCode, payload, extras)` |

(Retro emulator uses a different JS bridge — see §9.4.2.)

### 10.11 Retro game settings (`retro_emulators/util/setting`)

`RetroGameSettings`:
- `keyboardTheme` (int): `1` = white (default), `2` = black
- `platform` (String?) — emulator platform (gb/gba/...)
- `core` — RetroArch core selection

Constants: `KEYBOARD_THEME_WHITE=1`, `KEYBOARD_THEME_BLACK=2`.

---

## 11. Storage

### 11.1 Room databases (complete inventory)

| Database file | Module | Purpose |
|---|---|---|
| `egggame.db` | core | Main app DB — `user_account`, `auth_token`, `user_third_account`, `api_cache`, `bi_event_queue` |
| `db_game_library.db` | game | Game library — `t_game_library_base`, `t_game_install_state`, `t_game_launch_method`, `pc_game_history` |
| `ux_db.db` | core | UX preferences/state |
| `retro_emu_games.db` | retro_emulators | `retro_games` + `retro_game_sessions` |
| `cloud_game_sessions.db` | cloud | `cloud_game_sessions` + `cloud_timer` |
| `epic_storage.db` | common/epic | `epic_app_price` + `epic_offer_identity` |
| `db_pending_payment_v1.db` | features/pay | `pending_payment` — IAP retry queue |
| `exoplayer_internal.db` | androidx.media3 | ExoPlayer media cache |
| `countly.db` | Haima Countly | `countly_table` — analytics queue |
| `networkkit.db` + `networkkit_dynamic.db` | Huawei HMS | Network kit routing |
| `google_app_measurement.db` + `_local.db` | Firebase | Firebase Analytics |
| `_monitor.db` + `monitor.db` | internal | Internal monitoring |
| `db_bi_event_v1.db` | common/bi | BI analytics event queue — `bi_queued_event` (8-field retry queue) |
| `sdk_report.db` | MobPush/SDK | SDK event reporting |
| `traffic.db` | internal | Network traffic stats |
| `elp_msg.db` | FlyID (cn.fly.tcp) | FlyID TCP long-lived persistent message store |

> vJoy uses additional tables (likely in `ux_db.db` or a dedicated DB): `virtual_icon_asset`, `virtual_icon_collection`, `virtual_icon_group`, `virtual_icon_node`, `virtual_icon_node_closure` (closure tree), `virtual_key_layout`, `virtual_key_layout_binding`.

**Identity hashes (schema fingerprints):** `2af3da1aafcbd3ca616fc5cbf110c51d` (BiEventDatabase), `f18683c410e5cd9d73a45330d5a1fb69` (PayDatabase), plus 8 others for core databases.

#### 11.1.1 `AppDatabase` (egggame.db) DAO list

13 DAOs:

| DAO | Entity / Purpose |
|---|---|
| `apiCacheDao()` | `api_cache` — HTTP response cache |
| `authTokenDao()` | `auth_token` — JWT tokens |
| `cardDao()` | `CardEntity` — home/launcher cards |
| `downloadTaskDao()` | `DownloadTaskEntity` — download queue |
| `pcGameHistoryDao()` | `PcGameHistoryEntity` — PC play history |
| `userDao()` | `user_account` — user profile |
| `userThirdAccountDao()` | `user_third_account` — linked social accounts |
| `virtualIconCollectionDao()` | `virtual_icon_collection` — vJoy icon sets |
| `virtualIconNodeClosureDao()` | `virtual_icon_node_closure` — tree hierarchy |
| `virtualIconNodeDao()` | `virtual_icon_node` — icon nodes |
| `virtualKeyLayoutBindingDao()` | `virtual_key_layout_binding` — layout→game bindings |
| `virtualKeyLayoutDao()` | `virtual_key_layout` — key layout configs |
| `biEventQueueDao()` | `bi_event_queue` — analytics event queue |

#### 11.1.2 Key entity field counts

| Entity | Fields | Notes |
|---|---|---|
| `CardEntity` | 37 | leaderboardInfo, cardType, discount, gamePrice, gameChannelParams |
| `DownloadTaskEntity` | 18 | downloaderType enum, state enum, progress (download+install) |
| `PcGameHistoryEntity` | 11 | gameId, gameName, sourceType, sourceId, steamAppId, coverImage, heroCapsule |
| `VirtualIconNodeEntity` | 23 | id, userId, collectionId, nodeType enum, name, fileRelPath, mimeType, status enum |
| `VirtualKeyLayoutEntity` | 31+ | gameId, layoutType enum, source enum, publishStatus enum, catalog enum, acquire enum, upload/download result fields |

#### 11.1.3 Selected schemas

```sql
-- Game library base table (db_game_library.db) — 42 fields, most complete game entity
CREATE TABLE t_game_library_base (
    _id INTEGER PRIMARY KEY,
    localGameId TEXT, userId TEXT, serverGameId INTEGER, steamAppId TEXT,
    gameName TEXT, description TEXT, gameCategory TEXT, gameTag TEXT, gameLang TEXT,
    coverImage TEXT, coverVerImage TEXT, logo TEXT, backImage TEXT, squareImage TEXT,
    createTime INTEGER, modifyTime INTEGER, lastLaunchTime INTEGER,
    developer TEXT, publisher TEXT, company TEXT, releaseDate TEXT,
    launchMethodId INTEGER, extensionType INTEGER, extensionData TEXT,
    size INTEGER, ageRating TEXT, aiDesc TEXT, epicAppName TEXT,
    platforms TEXT, gameStartupParams TEXT
)

CREATE TABLE t_game_launch_method (
    id INTEGER PRIMARY KEY, launchMethodId INTEGER, linkedGameId TEXT,
    startName TEXT, startIcon TEXT, startEIcon TEXT, startSIcon TEXT,
    newIcon TEXT, newCIcon TEXT, startType INTEGER, isAutoGame INTEGER,
    lastUseTime INTEGER, extensionData TEXT
)

CREATE TABLE t_game_install_state (
    id INTEGER PRIMARY KEY, launchMethodId INTEGER, gameId TEXT,
    status TEXT, reason TEXT, operationId TEXT, updatedAt INTEGER
)

-- JWT token management (egggame.db)
CREATE TABLE auth_token (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id TEXT NOT NULL,
    access_token TEXT NOT NULL, refresh_token TEXT, token_type TEXT,
    access_token_expires_at INTEGER, refresh_token_expires_at INTEGER,
    issued_at INTEGER, is_current INTEGER NOT NULL,
    created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL,
    FOREIGN KEY(user_id) REFERENCES user_account(user_id) ON DELETE CASCADE
)

CREATE TABLE api_cache (
    cache_key TEXT PRIMARY KEY,
    response_body TEXT NOT NULL,
    last_updated INTEGER NOT NULL,
    headers TEXT
)

-- BI analytics retry queue (db_bi_event_v1.db)
CREATE TABLE bi_queued_event (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id TEXT NOT NULL, event_type TEXT NOT NULL, params_json TEXT NOT NULL,
    created_at INTEGER NOT NULL, attempt_count INTEGER NOT NULL,
    last_attempt_at INTEGER, last_error TEXT
)

CREATE TABLE download_tasks (
    task_id INTEGER PRIMARY KEY AUTOINCREMENT,
    downloader_type TEXT NOT NULL, url TEXT NOT NULL, name TEXT NOT NULL,
    save_path TEXT NOT NULL, cover TEXT NOT NULL, state TEXT NOT NULL,
    last_modify_time INTEGER NOT NULL,
    download_total_size INTEGER NOT NULL, downloaded_size INTEGER NOT NULL,
    download_percent INTEGER NOT NULL,
    install_total_size INTEGER NOT NULL, installed_size INTEGER NOT NULL,
    install_percent INTEGER NOT NULL,
    error_code INTEGER NOT NULL, metadata_json TEXT NOT NULL,
    created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL
)

-- Epic Games prices (epic_storage.db)
CREATE TABLE epic_app_price (
    app_name TEXT PRIMARY KEY,
    account_id TEXT NOT NULL,
    currency TEXT NOT NULL,
    original_price REAL NOT NULL, discount_price REAL NOT NULL,
    discount_percent INTEGER NOT NULL,
    original_formatted TEXT NOT NULL, discount_formatted TEXT NOT NULL
)

CREATE TABLE epic_offer_identity (
    account_id TEXT NOT NULL, namespace TEXT NOT NULL,
    app_name TEXT NOT NULL, title TEXT NOT NULL,
    offer_id TEXT NOT NULL, offer_type TEXT NOT NULL,
    catalog_item_ids TEXT NOT NULL, product_slug TEXT NOT NULL,
    PRIMARY KEY(account_id, app_name)
)
```

### 11.2 SharedPreferences / MMKV keys

| Key | Module | Purpose |
|---|---|---|
| `sp_winemu_unified_resources` | common/winemu | WinEmu unified resources cache (registry) |
| `sp_winemu_all_containers` | common/winemu | All Wine containers list |
| `sp_k_wine_screen_brightness` / `_switch` | features/winemu | Wine screen brightness override |
| `sp_k_hud_bg_transparency` | features/winemu/perf | HUD background transparency |
| `sp_k_cur_overlay_opacity` | features/winemu | Current overlay opacity (NOT `sp_k_overlay_opacity` — corrected Pass 30) |
| `sp_k_gamepad_sensitivity` | features/gamepadconfig | Gamepad analog sensitivity |
| `sp_k_virtual_gamepad_vibration_` | features/vjoy | Virtual gamepad vibration toggle |
| `sp_k_enable_touch_screen_mouse_control_` | features/winemu/input | Touch-as-mouse toggle |
| `sp_key_last_start_steam_type` | common/steam | Last-launched Steam type cache |
| `WineFile` (MMKV, multi-process mode=2) | WineActivity | Per-game Wine state |
| `InputControlsProfiles` (MMKV) | features/winemu/input | Saved input control / keymap profiles |
| `pc_emu_setting_kv` (MMKV) | features/winemu | Per-game PC-emulator settings KV |
| `pc_emu_setting_kv_global` (MMKV) | features/winemu | Global PC-emulator settings KV |
| `steam_event_collector` (MMKV) | common/steam | Steam event/telemetry buffer |
| `wine_loading_tips_cache` (MMKV) | common/winemu/loadingtips | Wine loading screen tips |
| `cloud_control_setting_device_active` | features/cloud | Cloud gamepad active device |
| `cloud_control_setting_scope` | features/cloud | Cloud controller settings scope |
| `cloud_normal_setting_idle` | features/cloud | Cloud idle timeout |
| `cloud_normal_setting_resolution` | features/cloud | Cloud streaming resolution |
| `cloud_normal_setting_scope` | features/cloud | Cloud general settings scope |
| `cloud_normal_setting_streaming_mode` | features/cloud | Cloud streaming mode |
| `cloud_setting_controller` / `cloud_setting_general` | features/cloud | Cloud session settings (landscape/portrait) |
| `cloud_setting_pane_result` | features/cloud | Cloud settings panel result |
| `pc_game_setting_landscape_scope` | features/winemu | PC game settings (landscape) |
| `compatibility_setting_scope` | features/winemu | Compatibility setting scope |
| `gamepad_config_menu_group_landscape` | features/gamepadconfig | Gamepad config menu group |
| `cid_cache_expire_time` / `cid_cache_interval` | core | Cloud ID cache TTL |
| `file_cache_size` / `sdk_config_version` | core | File cache and SDK config |
| `setting_logout_dialog_scope` | features/setting | Logout dialog state |
| `__wx_opensdk_sp__` | WeChat SDK | WeChat OAuth state |
| `.we_appcache_token` | Weibo SDK | Weibo auth token cache |
| `com.vivo.push_preferences.appconfig_v1` | Vivo push | Vivo push configuration |

### 11.3 FileProvider paths (`res/xml/util_code_provider_paths.xml`)

BlankJ UtilsFileProvider — broadest scope:

| Path type | Scope |
|---|---|
| `files_path` | App internal files |
| `cache_path` | App cache |
| `external_path` | Root external storage (all of `/storage/emulated/0/`) |
| `external_files_path` | App external files |
| `external_cache_path` | App external cache |
| `external_media_path` | External media paths |
| `root-path` | **Full filesystem root** — widest FileProvider scope |

`root-path` likely used for emulator container and game-file sharing across processes.

---

## 12. API Surface

GameHub 6.0 has **two distinct API surfaces** with very different reach and patch profiles. Documentation order: Catalog API → Client API → first-party literals → live verification matrix.

### 12.1 Catalog API — bare hostnames in the `mcj` enum

Stored as scheme-less hostnames in `mcj.smali` (`Lmcj;`), keyed by environment (Online / Beta / Test) with one CN slot and one oversea slot per environment. URL is built at runtime by `t40.smali` as `<scheme>://<host>`. **bannerhub-revanced patches the Online value's two `const-string` instructions** to swap both literals to `bannerhub-api.the412banner.workers.dev` (see `BANNERHUB_API_6.0_INTEGRATION.md` §2).

| Host | Resolved IP | Backend | Role |
|---|---|---|---|
| `landscape-api-cn.vgabc.com` | `119.23.38.142` | Aliyun direct | Production catalog (CN slot). **Patched by RedirectCatalogApiPatch** |
| `landscape-api-oversea.vgabc.com` | `43.159.95.190` | Tencent EdgeOne | Production catalog (oversea slot). Returns `ux-landscape-test/` test variant URLs. **Patched by RedirectCatalogApiPatch** |
| `landscape-api-cn-beta.vgabc.com` | `47.113.89.207` | Beta cluster | Beta catalog (CN slot). Not patched |
| `landscape-api-oversea-beta.vgabc.com` | `47.113.89.207` | Beta cluster (same backend) | Beta catalog (oversea slot). Not patched |

#### 12.1.1 Routes served on all four hosts (`/simulator/v2/*`)

| Path | Controls |
|---|---|
| `getAllComponentList` | Master catalog of every WinEmu component (Box64/FEX/DXVK/VKD3D/GPU drivers/libraries/games/Steam clients/Steam agents). Drives every "Select component" picker in PC game settings |
| `getComponentList` | Filtered subset by component-type integer (1=Box64/FEX, 2=GPU drivers, 3=DXVK, 4=VKD3D, 5=Games + Steam *agents*, 6=Libraries, 8=Steam clients in 6.0 — moved from type 7 in 5.x) |
| `getContainerList` | List of full Wine "containers" (Proton ARM64EC + plain Wine x64). Drives container selection. 6.0 returns `is_steam` per container — must be camelCased to `isSteam` for the worker |
| `getContainerDetail/{id}` | **6.0-only.** Single-container metadata (10 ids, 2–11). Used when picking a container to view/install |
| `getDefaultComponent` | Default per-game component selection (the auto-pick) |
| `getImagefsDetail` | Firmware image-FS metadata (vanilla 6.0 baseline was 1.3.4 / versionCode 24; BannerHub Worker bumped 6.0 path to 1.3.5 on 2026-05-07 and 1.3.6 on 2026-05-08; 5.x stays on 1.3.3). Decides whether a firmware update is needed |
| `executeScript` | Server-evaluated config/script delivery — runtime catalog overrides |

#### 12.1.2 Required POST body

All catalog calls (form-urlencoded preferred; JSON also accepted on legacy host):

| Field | Format |
|---|---|
| `clientparams` | Pipe-delimited 19-field string (built by `com.xiaoji.egggame.core.network.clientparams.PlatformClientParamsModule`):<br>`<version>\|<versionCode>\|<lang>\|<model>\|<resolution>\|<channel>\|<sub_channel>\|<brand>\|\|\|\|\|\|\|\|\|<package>\|\|<gpu_vendor>`<br>**Vanilla 6.0 example:** `6.0.0\|49908\|en\|SM-S928B\|1920 * 1080\|gamehub_android\|gamehub_android_Official\|samsung\|\|\|\|\|\|\|\|\|com.mihoyo.genshinimpact\|\|qcom` |
| `time` | Millisecond timestamp string |
| `token` | JWT from `jwt/email/login` (or `jwt/refresh/token`) |
| `sign` | MD5 of sorted-keys joined `key=value&key=value...&all-egg-shell-y7ZatUDk` |

### 12.2 Client API — `https://clientgsw.vgabc.com/clientapi/`

Hardcoded full URL in DEX. Tencent EdgeOne (`43.159.95.190` → CNAME `*.eo.dnse1.com`). **404s on every probed path from non-CN IPs** including realistic JSON+form bodies, `clientparams`, headers (App-Id, channel, platform, Version, User-Agent variants). Bare `/` returns 200 `hello gamesir world`; `/clientapi` 301→`/clientapi/`→404. Likely requires either a header set we have not identified or specific client-cert / app-attest material.

**Not patched** by bannerhub-revanced — vanilla problem we don't own.

#### 12.2.1 Auth / identity

| Path | Controls |
|---|---|
| `jwt/email/login` | Email + password login → returns JWT |
| `jwt/mobile/login` | Phone-number login |
| `jwt/oneMobile/login` | One-tap mobile login (Alibaba/CMIC SSO bridge) |
| `jwt/third/login` | Third-party OAuth login (WeChat/QQ/Apple/Google/Weibo/Epic/Facebook/Twitter) |
| `jwt/logout` | Invalidate JWT |
| `jwt/refresh/token` | Refresh JWT (separate signature flow vs other endpoints; returns 401 "Please login first" without specific signing) |
| `account/cancel` | Permanent account deletion |
| `bind/{apple,google,qq,wechat,email,mobile,customParam}` | Link a social/contact identity |
| `unbind/{apple,google,qq,wechat}` | Unlink |
| `profile/mobile` | Mobile profile metadata |
| `realname/auth` / `realname/status` | China real-name verification (legally required for game time) |
| `ems/send` / `sms/send` | Send email/SMS verification code |
| `user/getMobileCode` | Request phone verification code |
| `user/info` | Full user profile (avatar, level, badges, balances) |
| `user/get_simple_userinfo` | Lightweight profile (used in headers/feeds) |

#### 12.2.2 Game catalog / content (Client API side, distinct from Catalog API)

| Path | Controls |
|---|---|
| `game/v2/detail` | Per-game detail page (covers, screenshots, requirements, store links) |
| `game/v2/getClassify` | Game classifications/categories tree |
| `game/getCategoryGroups` | Category groups (genre clusters) |
| `game/getCustomPageGameList` | Curated list pages (hand-picked rails) |
| `game/getGameCircleList` | Community circles per game (forum-like) |
| `game/getH5ShareLink` | Build a sharable H5 link |
| `game/getRecommendGameList` | Recommended games rail |
| `game/getRetroGameStats` | Server-side retro play stats |
| `game/retroList` / `game/retroDetail` | Retro library list/detail |
| `game/opRes/list` | Operations resources (banners, marketing assets) |
| `game/saveInterestTags` | User-selected interest tags |
| `game/leaderboard/list` | Per-game leaderboards |
| `game/cts/report` | Submit compatibility report (CTS) |
| `game/checkLocalHandTourGame` | Detect if mobile game is locally installed (handheld) |

#### 12.2.3 Sessions / heartbeat / activity

| Path | Controls |
|---|---|
| `heartbeat/game/start` | Begin tracked session — drives playtime, achievements, daily-reward eligibility |
| `heartbeat/game/update` | Mid-session ping |
| `heartbeat/game/end` | End session |
| `heartbeat/game/getUserPlayTimeList` | Per-user aggregated play-time list |
| `activity/task/trigger` | Fire an in-app task/event milestone |
| `activity/h5?id=` | H5 activity page by id |
| `cloud_sign/getActivity` | Daily sign-in calendar + reward state |
| `cloud_sign/sign` | Record today's sign-in |

#### 12.2.4 Telemetry / config

| Path | Controls |
|---|---|
| `events/device-performance-config` | Device-perf telemetry endpoint (Firebase datatransport) — receives the `DevicePerfReportEventDto` envelope (see §9.10) |
| `privacy-sandbox/register-app-conversion` | Google Privacy Sandbox app-conversion registration |
| `config/app/` | App config bundle |
| `conf/style` | UI style/theming config |
| `settings/getNotifySwitch` | Notification toggle state |
| `location/conf` / `location/report` | Location config + reporting |

#### 12.2.5 Feedback / uploads / share

| Path | Controls |
|---|---|
| `feedback/submitFeedback` | Submit in-app feedback |
| `feedback/feedback_list.html?uid=` | H5 feedback list (WebView) |
| `feedback/feedback_detail.html` | H5 feedback detail |
| `uploads/uploadsImages` | Upload images (community/sharing) |
| `uploads/uploadsVideo` | Upload video |
| `share/icons` | Share icon assets |
| `share/media/blank.mkv` / `share/media/blank.ptna` | Share-media placeholder assets |
| `share/pixmap` | Share pixmap asset |

#### 12.2.6 WinEmu / Steam / Epic data

| Path | Controls |
|---|---|
| `xj_winemu/pc_game_setting_schemes` | Per-game-PC setting scheme bundles (drives the in-game settings UI generator — see §9.1.7) |
| `steam_data/steamkit` | Steam SDK data exchange (libsteamkit_core.so backend) |
| `epic_data/epickit` | Epic SDK data exchange (libepickit_core.so backend) |
| `epic_data/epic_recovery_governance_directive.json` | EGS recovery directive catalog |
| `epic_data/epic_recovery_governance_directive_execution.json` | Directive execution rules |
| `epic_data/epic_recovery_governance_execution.json` | Execution-state config |
| `epic_data/epic_recovery_governance_plan.json` | Recovery plan catalog |
| `epic_data/epic_recovery_governance_prompts.json` | Prompt catalog |
| `epic_data/epic_recovery_governance_prompt_account_history.json` | Account-scoped prompt history |
| `epic_data/epic_recovery_governance_prompt_session_history.json` | Session-scoped prompt history |
| `epic_data/epic_recovery_governance_strategy.json` | Strategy resolution rules |
| `epic_data/epic_android_recovery_governance_actions.json` | Android-specific recovery actions |
| `epic_data/epic_ios_recovery_governance_actions.json` | iOS-specific recovery actions |
| `emulator/auth/handler` | Per-emulator auth handler (Steam/Epic OAuth bridge) |
| `retro_emulator/cores/` | Retro emulator core listing (links to bigeyes CDN) |

#### 12.2.7 Cloud gaming (VTouch + cloud signaling)

| Path | Controls |
|---|---|
| `vtouch/startType` | Cloud-gaming launch mode selection |
| `cloud/game/auth_token` | Get session token |
| `cloud/game/start_token` | Start cloud-game session |
| `cloud/game/renew_token` | Renew session |
| `cloud/game/exit` | End session |
| `cloud/game/check_user_timer` | Check remaining time |
| `cloud/game/getQueueInfo` / `startQueue` / `getQueueCalendar` | Queue management |
| `cloud/game/getGoodsListV2` | Cloud-game store catalog |
| `cloud/game/getNewsList` / `getNewsDetail` | News feed for cloud-gaming |
| `cloud/game/confirmPlay` | Pre-play confirmation |
| `cloud/order/info` / `cloud/order_list` | Order info / list |
| `cloud/payment` | Cloud-gaming payment endpoint |
| `cloud/app/exchange_code` / `cloud/h5/exchange_code?uuid=` | Activation codes |
| `cloud/use_time_log` | Play-time reporting |
| `cloud/notify/apple` | Apple push for cloud gaming |
| `order/get_down_info` | Per-download order metadata |

> Earlier passes referenced "17 sub-paths under `cloud/game/*`". The actual count from this exhaustive smali sweep is **12** under `cloud/game/`, plus 6 more under `cloud/{app,h5,order,order_list,payment,use_time_log,notify}` and 1 under `order/`.

### 12.3 First-party standalone literals (full URLs in DEX)

| URL | In 6.0 DEX | Purpose |
|---|---|---|
| `https://clientgsw.vgabc.com/clientapi/` | ✅ literal full URL | Client API (see §12.2) |
| `https://statistic-gamehub-api.vgabc.com/events` | ✅ literal | Production analytics events bus |
| `https://landscape-api-beta.vgabc.com/events` | ✅ literal | Beta analytics events |
| `https://dev2-gamehub-api.vgabc.com/events` | ✅ literal | Dev/beta event tracking (global) |
| `https://gamehub-service-dev.xiaoji.com/xgp/exchange` | ✅ literal | Xbox Game Pass code redemption (new in 6.0) |
| `https://xgp.xiaoji.com` | ✅ literal | Xbox Game Pass portal |
| `https://gamehub.xiaoji.com/{en-us,zh-cn}` | ✅ literal | GameHub web (locale split) |
| `https://www.xiaoji.com/firmware/update/x1` | ✅ literal | OTA firmware update check (image-FS) |
| `https://retro-emulator-download.bigeyes.com/retroarch/` | ✅ literal | RetroArch WASM cores download root |

**Hosts referenced but NOT in 6.0 DEX (historical):**
`landscape-api.vgabc.com` (5.x legacy, still alive — used by BannerHub worker as fallback origin), `dev2-gamehub-api-cn.vgabc.com`, `dev2-gamehub-api-oversea.vgabc.com`, `landscape-api-cn-beta.vgabc.com/events`, `landscape-api-cn.vgabc.com/events`, `landscape-api-oversea-beta.vgabc.com/events`, `landscape-api-oversea.vgabc.com/events`, `api-cn-gamehub.xiaoji.com`, `api-international-gamehub.xiaoji.com`, `gamehub-dev.mx520.com`, `gamehub-dev-international.mx520.com`.

### 12.4 Live verification — host reachability matrix (probed 2026-05-03)

With valid token + signed body:

| Host | Resolved IP | Backend | `/simulator/v2/getAllComponentList` | `/user/info` | `/clientapi/...` |
|---|---|---|---|---|---|
| `landscape-api.vgabc.com` | `119.23.38.142` | Aliyun direct, no CDN | **200** | **200** | 404 |
| `landscape-api-cn.vgabc.com` | `119.23.38.142` (same backend as above) | Aliyun direct | **200** | (not tested) | (not tested) |
| `landscape-api-oversea.vgabc.com` | `43.159.95.190` (Tencent EdgeOne, vhost-routed differently than clientgsw) | EdgeOne edge → backend | **200** (returns `ux-landscape-test/...` paths) | (not tested) | (not tested) |
| `landscape-api-cn-beta.vgabc.com` | `47.113.89.207` | beta cluster | **200** | (not tested) | (not tested) |
| `landscape-api-oversea-beta.vgabc.com` | `47.113.89.207` (same backend as cn-beta) | beta cluster | **200** | (not tested) | (not tested) |
| `clientgsw.vgabc.com` | `43.159.95.190` → CNAME `*.eo.dnse1.com` (Tencent EdgeOne) | EdgeOne edge | 404 | 404 | **404 on every probe** |

**Key takeaways:**

- The catalog API (`simulator/v2/*`) is **fully reachable from non-CN IPs** on every `landscape-api*` host. EdgeOne does not block it. The `mcj` enum's cn/oversea hosts both work today.
- `landscape-api.vgabc.com` (no regional suffix) is **alive on the same backend as `landscape-api-cn`** — and is what the BannerHub worker uses as the fallback origin. Functionally equivalent to landscape-api-cn for catalog purposes.
- `clientgsw.vgabc.com` is the outlier: 404 on every probed path. Bare `/` returns 200 `hello gamesir world`; `/clientapi` 301→`/clientapi/`→404.
- `jwt/refresh/token` against landscape-api returns 401 "Please login first" — refresh has its own signature requirement different from regular signed requests.

---

## 13. CDN Structure

CDN hostnames are **server-driven** — the API response sets them rather than the app hardcoding them. Neither `cdn-img-uxdl.youwo.com` nor `zlyer-cdn-comps-en.bigeyes.com` appears as a literal string in the 6.0 DEX; both observed only in cached responses on-device (prefs + Coil cache + winemu registry XML).

| Domain | Used for | Verification |
|---|---|---|
| `zlyer-cdn-comps-en.bigeyes.com/ux-landscape/pc_zst/` | Production component/container `.tzst`/`.zst` archives (Box64/FEX/DXVK/VKD3D/Wine binaries) | ✅ confirmed in on-device `sp_winemu_unified_resources.xml` (hundreds of cached URLs) |
| `zlyer-cdn-comps-en.bigeyes.com/ux-landscape-test/pc_zst/` | Test/beta component archives | ✅ confirmed in on-device registry; oversea Catalog returns these |
| `cdn-img-uxdl.youwo.com/ux-landscape/game-image/` | Game cover/screenshot artwork | ✅ confirmed in `com.mihoyo.genshinimpact_preferences.xml` and Coil disk cache. **Fastly+GCS fronted** (response headers show `via: 1.1 varnish`, `x-served-by: cache-iad/ewr-...`, `x-guploader-uploadid: AAVLpEi...`) |
| `zlyer-cdn-comps-en.bigeyes.com/ux-landscape/game-image/` | (Historical) earlier game-image host | Replaced by `cdn-img-uxdl.youwo.com` in 6.0; both hosts may still resolve |
| `retro-emulator-download.bigeyes.com/retroarch/` | RetroArch WASM cores | ✅ literal in DEX |
| `dllhb.gamebrew.org/gbahomebrews/` | Bundled GBA demo ROMs | — |

**URL pattern for components:**
`https://zlyer-cdn-comps-en.bigeyes.com/ux-landscape/pc_zst/<md5[0:4]>/<md5[4:6]>/<md5[6:8]>/<filename>.tzst`

---

## 14. Third-Party SDK Endpoints

### 14.1 Cloud-gaming (Haima HMCP)

| URL | Purpose |
|---|---|
| `https://saas-rel.haimacloud.com/s/rest/api` | Primary HMCP auth/API — cloud-PC sessions |
| `https://saas-rel-bak.haimacloud.com/s/rest/api` | Failover endpoint |
| `https://saassdk.haimawan.com/saas_test_20M.data` | 20MB bandwidth test |
| `https://countly.haimacloud.com` | HMCP usage analytics (Countly) |

### 14.2 Connectivity probes

| URL | Purpose |
|---|---|
| `https://1.1.1.1/cdn-cgi/trace` | Cloudflare presence/IP detect |
| `https://api.ip.sb/geoip` | IP geolocation (region-gating decisions) |
| `https://connectivitycheck.gstatic.com/generate_204` | Android NCS probe |
| `https://www.google.com/generate_204` | Secondary NCS probe |

### 14.3 OAuth — WeChat

| URL | Purpose |
|---|---|
| `https://api.weixin.qq.com/sns/oauth2/access_token` | Exchange WeChat code → access token |
| `https://api.weixin.qq.com/cgi-bin/stable_token` | Stable token (server-to-server) |
| `https://api.weixin.qq.com/cgi-bin/ticket/getticket` | Get JS-API ticket (for share signing) |
| `https://mp.weixin.qq.com/publicpoc/opensdkconf?action=GetShareConf&appid=` | Mini-Program OpenSDK share config |
| `https://open.weixin.qq.com/connect/sdk/qrconnect` | QR-code login |
| `https://long.open.weixin.qq.com/connect/l/qrconnect` | Long-poll QR login |

### 14.4 OAuth — QQ / Tencent

| URL | Purpose |
|---|---|
| `https://openmobile.qq.com/oauth2.0/m_authorize` | QQ Connect authorize |
| `https://openmobile.qq.com/oauth2.0/me` | Current user info |
| `https://openmobile.qq.com/oauth2.0/m_jump_by_version` | Version-based jump |
| `https://openmobile.qq.com/v3/user/get_info` | User info (v3) |
| `https://openmobile.qq.com/user/user_login_statis` | Login statistics |
| `https://openmobile.qq.com/cgi-bin/qunopensdk/check_group` | Group membership check |
| `https://openmobile.qq.com/cgi-bin/qunopensdk/unbind` | Group unbind |
| `https://imgcache.qq.com/ptlogin/static/qzsjump.html` | Qzone ptlogin jump |
| `https://appsupport.qq.com/cgi-bin/qzapps/mapp_addapp.cgi` | Qzone mini-app add |
| `https://appsupport.qq.com/cgi-bin/appstage/mstats_batch_report` | AppStage telemetry batch |
| `https://cgi.connect.qq.com/qqconnectopen/openapi/policy_conf` | Connect policy config |
| `https://h.trace.qq.com/kv` | Tencent Tracing telemetry |
| `https://www.qq.com` / `https://qm.qq.com` | QQ root + landing |

### 14.5 OAuth — Weibo

| URL | Purpose |
|---|---|
| `https://api.weibo.com/oauth2/access_token` | Token exchange (+ `/default.html` redirect) |
| `https://open.weibo.cn/oauth2/authorize` | Authorize page |
| `https://service.weibo.com/share/mobilesdk.php` | Mobile-SDK share endpoint |

### 14.6 OAuth — Epic Games

| URL | Purpose |
|---|---|
| `https://www.epicgames.com/id/api/redirect?clientId=34a02cf8f4414e29b15921876da36f9a&responseType=code` | Auth start (clientId is GameHub's Epic app id) |
| `https://www.epicgames.com/id/login?redirect_uri=` | Login redirect |
| `https://store.epicgames.com/` | Store web view (game detail) |

### 14.7 Steam (deep links / web)

| URL | Purpose |
|---|---|
| `https://store.steampowered.com/app/` | Open Steam store page (game detail) |
| `https://store.steampowered.com/mobile` | Steam mobile store landing |
| `https://shared.fastly.steamstatic.com/store_item_assets/steam/apps/` | Steam store-item assets via Fastly |

### 14.8 Chinese carrier auth (one-tap phone login)

| URL | Purpose |
|---|---|
| `https://api-e189.21cn.com/gw/client/accountMsg.do` | China Telecom 21cn account msg |
| `https://card.e.189.cn/auth/preauth.do` | China Telecom 189 card pre-auth |
| `https://e.189.cn/sdk/agreement/detail.do` | 189 SDK agreement (terms page) |
| `https://crbt.i139.cn:8143/may/impower/V1` | China Mobile authorize/get-info (port 8143) |
| `https://wap.cmpassport.com/resources/html/contract.html` | CMPassport contract terms |
| `https://verify.cmpassport.com/h5/getMobile` | CMPassport H5 phone-fetch |
| `cert.cmpassport.com` / `config2.cmpassport.com` / `rcs.cmpassport.com` / `log2.cmpassport.com:9443` | CMPassport TLS-pinned cert host / config / RCS / log gateway |
| `https://msv6.wosms.cn/html/oauth/protocol2.html` | China Unicom SMS auth (production) |
| `auth.wosms.cn` / `ali.wosms.cn` / `test.wosms.cn` | Unicom SMS auth/Alibaba relay/sandbox |
| `https://nisportal.10010.com:9001/api` | Unicom CUCC get-auth-addr (port 9001) |
| `https://opencloud.wostore.cn/authz/resource/html/disclaimer.html` | Unicom open cloud authz disclaimer |
| `https://id6.me/auth/preauth.do` | ID6 carrier SSO |
| `https://dypnsapi-dualstack.aliyuncs.com` | Alibaba one-tap phone auth |

### 14.9 Alipay (in-app payment)

| URL | Purpose |
|---|---|
| `https://loggw-exsdk.alipay.com/loggw/logUpload.do` | SDK log upload |
| `https://mcgw.alipay.com/sdklog.do` | SDK log gateway |
| `https://mclient.alipay.com/cashier/mobilepay.htm` | Mobile cashier (mobile pay) |
| `https://mclient.alipay.com/home/exterfaceAssign.htm` | Mobile cashier home assign |
| `https://mclient.alipay.com/service/rest.htm` | Mobile REST service |
| `https://mclient.alipay.com/wapcashier/api/cashierMainMergeRequest.htm` | WAP cashier main merge request |
| `https://mobilegw.alipay.com/mgw.htm` | Mobile gateway (production) |
| `https://mobilegwpre.alipay.com/mgw.htm` | Mobile gateway (pre-prod) |
| `https://wappaygw.alipay.com/home/exterfaceAssign.htm` | WAP pay gateway home |
| `https://wappaygw.alipay.com/service/rest.htm` | WAP pay gateway REST |
| `mobilegw.{stable,aaa,test}.alipay.net/mgw.htm` | Stable/AAA-auth/test environments |

### 14.10 Push (Mob + carrier OEMs)

| URL | Purpose |
|---|---|
| `sdk.push.mob.com` / `abroad.sdk.push.mob.com` | MobPush gateway (CN / international) |
| `m.zzx.cnklog.com` | MobTech telemetry log (CN) |
| `https://cn.register.xmpush.xiaomi.com` | MiPush registration |
| `sandbox.xmpush.xiaomi.com` | MiPush sandbox |
| `https://resolver.msg.xiaomi.net/psc/?t=a` | MiPush resolver |
| `app.chat.xiaomi.net` / `cn.app.chat.xiaomi.net` | MiPush chat (intl/CN) |

### 14.11 FlyID (China device-fingerprint / messaging infra)

| URL | Purpose |
|---|---|
| `cfgc.zztfly.com` | Config gateway |
| `devc.zztfly.com` | Device channel |
| `errc.zztfly.com` | Error channel |
| `fdl.zztfly.com` | Feedback / data log |
| `gd.zztfly.com` | Get-data channel |
| `tgc.zztfly.com` | Token gateway |
| `upc.zztfly.com` | Upload channel |

### 14.12 Google

| URL | Purpose |
|---|---|
| `https://app-measurement.com/a` | Firebase Analytics ingestion |
| `https://firebaseinstallations.googleapis.com/v1/` | Firebase Installations registration |
| `https://firebase-settings.crashlytics.com/spi/v2/platforms/android/gmp/` | Crashlytics settings |
| `https://accounts.google.com/o/oauth2/revoke?token=` | Google OAuth revoke |
| `https://www.googleapis.com/auth/{games,games.firstparty,games_lite,appstate,datastoremobile,drive,drive.appdata,drive.apps,drive.file,plus.login,plus.me,userinfo.email,userinfo.profile}` | OAuth scope identifiers (Play Games + Drive + Plus + userinfo) |
| `https://pagead2.googlesyndication.com` | Google ads delivery |
| `https://pagead2.googlesyndication.com/pagead/gen_204` | Mobile Ads telemetry pixel |
| `https://www.googleadservices.com/pagead/conversion/app/deeplink` | Ads conversion deeplink |
| `https://play.google.com/store/apps/details?id=` | Open Play Store detail |
| `https://play.google.com/store/search?q=otpauth&c=apps` | Discover TOTP app for 2FA |
| `https://www.recaptcha.net/recaptcha/api3` | reCAPTCHA Enterprise |

### 14.13 Misc

| URL | Purpose |
|---|---|
| `https://h5.m.taobao.com/mlapp/olist.html` | Taobao mobile order list (Alipay context bridge) |
| `https://aomedia.org/emsg/ID3` | AOMedia ID3 metadata URL (ExoPlayer/AV1) |
| `https://www.baidu.com` | Baidu (connectivity / search fallback) |
| `https://cdn.jsdelivr.net/npm/echarts@5.3.0/dist/echarts.min.js` | ECharts (charts inside WebView dashboards) |

---

## 15. Custom URI Schemes

| Scheme | Purpose |
|---|---|
| `epic-auth://` | Epic Games auth callback (manifest deep link) |
| `tencent102667728://` | QQ OAuth callback |
| `genericidp://firebase.auth/` | Firebase generic IdP callback |
| `recaptcha://firebase.auth/` | Firebase reCAPTCHA callback |
| `tbopen://` | Taobao/Alipay deep link |
| `mqqapi://` | QQ Messenger deep links — `connect_miniapp`, `im`, `share`, `opensdk`, `profile`, `qzone`, `open_connect` |
| `auth://tauth.qq.com` | QQ tauth in-app authentication callback |
| `steammobile://store?appid=%s` | Open game detail in Steam mobile app |
| `gamesir://local_file` | GameSir controller local file access |
| `auth://` | Internal auth callback — `browser`, `cancel`, `close`, `on`, `onLoginSubmit`, `progress` |
| `sdklite://h5quit` | SDK lite H5 exit callback |
| `otpauth://totp/` | TOTP 2FA (Firebase Auth / authenticator app) |
| `alipayhk://platformapi` / `alipays://platformapi` / `alipayjsbridge://(call\|on\|set\|show)` | Alipay payment bridges |
| `intent://platformapi` | Alipay platform intent fallback |
| `weixin://(registerapp\|sendreq\|sendresp\|unregisterapp)` | WeChat SDK IPC schemes |
| `sinaweibo://browser` | Weibo browser callbacks |
| `js://localWebPay` / `js://update` / `js://wappay` | JS bridge schemes for WebView payment |
| `app://com.google.android.googlequicksearchbox` / `app://com.google.appcrawler` | Google App search/crawler indexing |
| `market://details` | Google Play Store details page |
| `keystore://firebear_main_key_id_for_storage_crypto.` / `keystore://firebear_master_key_id.` | Firebase Auth (Firebear) storage encryption key references |
| `ldap://localhost` | BouncyCastle LDAP test reference (cert chain validation) |

---

## 16. External `content://` Providers Queried

App reads/writes the following system & vendor `content://` providers (badges, push, launcher integration, device IDs):

| Authority | Owner / Purpose |
|---|---|
| `com.google.android.gms.phenotype` | GMS Phenotype (feature flags) |
| `com.google.android.gsf.gservices` | Google Services Framework GServices |
| `com.huawei.android.launcher.settings` / `com.hihonor.android.launcher.settings` | Huawei / Honor launcher (shortcuts) |
| `com.bbk.launcher2.settings` | BBK / Vivo launcher |
| `com.huawei.hms.contentprovider` | HMS content provider |
| `com.huawei.hwid` | Huawei ID |
| `com.hihonor.android.pushagent.provider.` | Honor push agent |
| `com.meizu.flyme.openidsdk` | Meizu OpenID SDK |
| `com.sec.badge` | Samsung badge |
| `com.android.badge` | Generic launcher badge |
| `cn.nubia.provider.deviceid.dataid` | Nubia device ID |
| `com.tencent.mm.sdk.comm.provider` | WeChat SDK common provider |
| `com.tencent.mm.sdk.plugin.provider` | WeChat SDK plugin provider |
| `com.vivo.push.sdk.service.` / `com.vivo.vms.` | Vivo push / VMS |
| `com.xiaomi.push.providers.` | Xiaomi push |

---

## 17. Game Launch Types

`com.xiaoji.egggame.launcher.model.LaunchType` — full enum with integer codes and category groups:

| LaunchType | Code | Category | Description |
|---|---|---|---|
| `LaunchOtherApp` | 1001 | LaunchOtherApp | Launch external app |
| `OpenUrl` | 1201 | OpenUrl | Open URL in browser/webview |
| `XboxCloudGaming` | 1202 | XboxCloudGaming | Xbox Cloud Gaming |
| `HidGame` | 1301 | Mobile | HID-connected game |
| `MobilePlay` | 1302 | Mobile | Mobile game play |
| `PsLink` | 1401 | PsStream | PlayStation Link (remote play) |
| `PcLink` | 1402 | PcStream | PC link (remote desktop-style) |
| `PcEmulator` | 1403 | PcEmulator | Wine/WinEmu PC emulation (local) |
| `MovingCloudGaming` | 1406 | CloudGaming | Cloud gaming on mobile |
| `SteamGameByPcEmulator` | 1407 | PcEmulator | Steam game via WinEmu |
| `EpicGameByPcEmulator` | 1408 | PcEmulator | Epic Games via WinEmu |
| `GogGameByPcEmulator` | 1409 | PcEmulator | GOG.com via WinEmu |
| `SteamGameDetailByWeb` | 1501 | SteamWebDetail | Steam web detail view |
| `MobileInstallApp` | 1502 | Mobile | Mobile app install |
| `TypeHid` | 7 | Mobile | HID type |
| `TypeMobilePlay` | 10 | Mobile | Mobile play type |
| `Unknown` | INT_MIN | Unknown | Fallback |

Also referenced (without explicit codes captured): `PcStream`, `CloudGaming`, `Mobile`, `SteamWebDetail`, `PsStream`, plus 1 alias `SteamWebDetail`/`SteamGameDetailByWeb`.

**`LaunchMethodExtensionType`** enum (game/database/entity):

| Value | Int |
|---|---|
| `PC_EMULATOR` | 1 |
| `STEAM` | 2 |
| `MOBILE` | 3 |
| `STREAMING` | 4 |

**Launch method models** (`game/di/model/launchMethod`): `LaunchMethod` (base), `PcEmulatorLaunchMethod`, `PcStreamLaunchMethod`, `PsStreamLaunchMethod`.

**Game extension models** (`game/di/model/game`):

| Class | Fields |
|---|---|
| `GameInfo` | base game info |
| `CloudExtension` | `cloudServiceType`, `cloudGameId`, `jumpUrl` |
| `MobileExtension` | `packageName`, `versionCode/Name`, `fileMd5`, `localMobileAppId`, `mobileIconUrl` |
| `PcEmulatorExtension` | `filePath`, `steamAppid`, `steamGameInfo`, `localGameIconPath`, `exeFileBgType`, `isLocalGame` |
| `PcStreamingExtension` | `pcStreamingCoverImage` |
| `PsStreamingExtension` | `isShortcut` |

---

## 18. Third-Party SDK Inventory

| SDK | Package(s) | Purpose |
|---|---|---|
| ExoPlayer (Media3) | `androidx.media3.*` | HLS/video/image/offline media playback |
| Google Firebase | `com.google.firebase.*` | Analytics, Auth, FCM, Crashlytics |
| Google Play Services | `com.google.android.gms.*` | GMS, Sign-In, Credentials |
| Google Protobuf | `com.google.protobuf.*` | Data serialization |
| Google Gson | `com.google.gson.*` | JSON parsing |
| Glide | `com.bumptech.glide.*` | Image loading |
| Huawei HMS | `com.huawei.*` | AGConnect, HMS Push |
| Hi Honor | `com.hihonor.*` | Honor device push |
| HeyTap | `com.heytap.mcs.*` | OPPO push |
| Vivo | `com.vivo.*` | Vivo push / VMS |
| Xiaomi MiPush | `com.xiaomi.mipush.*` | Xiaomi push notifications |
| Meizu Push | `com.meizu.cloud.pushsdk.*` | Meizu Flyme push (MobPush channel) |
| MobPush | `com.mob.pushsdk.*` | Multi-channel push aggregator (Xiaomi/OPPO/vivo/Honor/Meizu/Unicom) |
| MobID | `com.mob.id.*` | Identity verification |
| FlyID | `cn.fly.*` | FlyID auth/identity |
| CMIC SSO | `com.cmic.sso.*` | SSO login (phone carrier) |
| Alibaba Phone Auth | `com.mobile.auth.gatewayauth.*` | One-tap phone login |
| Alipay | `com.alipay.sdk.*` | Payment |
| WeChat | `com.tencent.mm.opensdk.*` + `wxapi/` | Auth, payment, sharing |
| QQ / Tencent | `com.tencent.tauth.*`, `com.tencent.connect.*` | QQ auth, Tencent open platform |
| Weibo | `com.sina.weibo.sdk.*` | Weibo auth/sharing |
| JieLi BT OTA | `com.jieli.jl_bt_ota.*` + `libjl_ota_auth.so` | JieLi controller firmware |
| GameSir | `com.xiaoji.egggame.common.gamepadota.ble.gamesirg6.*` | GameSir G6 OTA |
| Nordic DFU | `no.nordicsemi.android.dfu.*` | BLE DFU (gamepad firmware) |
| RxAndroidBLE | `com.polidea.rxandroidble2.*` | BLE peripheral communication |
| Haima IJK Player | `com.haima.*`, `tv.haima.ijk.*` | IJK media player (Haima fork) |
| Haima RTC / HMCP | `libhaima_rtc_so.so`, `com.haima.hmcp.*`, `org.webrtc.haima.*`, `org.hmwebrtc.*` | Full cloud-gaming stack: WebRTC + RTMP + WebSocket signaling + virtual input + DNS + Protobuf. Bundled FastJSON + Volley |
| Haima Countly | `countly.haimacloud.com` | Custom analytics |
| Nirvana Tools | `com.nirvana.tools.*` | App utility tools |
| AndroidUtils (blankj) | `com.blankj.utilcode.*` | Android utility library |
| LDNetDiagno | `com.netcheck.LDNetDiagnoService.*` | Network diagnostics |
| Qiniu | `com.qiniu.android.*` | Qiniu cloud storage (upload) |
| Koin | `org.koin.*` | Dependency injection |
| Ktor | `io.ktor.client.*` | Kotlin HTTP client |
| OkHttp3 | `okhttp3.*` | HTTP client |
| RxJava2 | `io.reactivex.*` | Reactive programming |
| BouncyCastle | `org.bouncycastle.*` | Cryptography (incl. post-quantum `pqc`) |
| Rustls | `org.rustls.platformverifier.*` | Rust-based TLS platform verifier |
| SnakeYAML | `org.yaml.snakeyaml.*` | YAML parsing |
| MsgPack | `org.msgpack.*` | MessagePack serialization |
| Compottie | `com.multiplatform.webview.*`, `com.radzivon.bartoshyk.*` | Compose Lottie / WebView |
| FileKit | `io.github.vinceglb.filekit.*` | KMP file picker |
| MMKV | `libmmkv.so` | Fast key-value store |
| Room | `androidx.room.*` | SQLite ORM |
| DataStore | `androidx.datastore.*` | Preferences storage |
| Zstd-JNI | `libzstd-jni-1.5.7-4.so` | Zstandard compression |
| awxkee/avif | `com.github.awxkee.*` | AVIF image codec |
| Luben/Zstd | `com.github.luben.zstd.*` | Zstd JVM bindings |
| EpicKit (UniFFI) | `uniffi.epickit_core.*` | Epic Games SDK (Rust) |
| KRLY platform | `com.krly.platform.*` | Unknown (likely CN platform) |
| MCS AIDL | `com.mcs.aidl.*` | MediaCodec service AIDL |
| Unicom | `com.unicom.online.account.*` | China Unicom auth |
| JNA | `libjnidispatch.so` | Java Native Access |
| Fanttv Crash | `libfntvcrash.so` | Crash reporting |

---

## 19. Removed Since 5.3.5

| URL | Was used for | Status (probed 2026-05-03) |
|---|---|---|
| `https://clientegg.vgabc.com/uxapi/` | Old secondary API | — |
| `https://landscape-api.vgabc.com/` | Production landscape API | **Still alive** (Aliyun direct, no CDN, no geo-restriction). `/user/info` returns 200 with valid token. **Not referenced anywhere in 6.0 DEX.** Useful as a fallback origin for 5.x clients only — 6.0 will never call it on its own. Routes are 5.x-shaped: `/game/v2/getClassify` returns 404, while `user/info`/`jwt/*` continue to work |
| `https://test-landscape-api.vgabc.com/` | Test environment | — |
| `https://dev-gamehub-api.vgabc.com/` | Old dev API | — |
| `https://gamehub-lite-api.emuready.workers.dev/` | EmuReady Lite mode API | — |
| `https://gamehub-lite-token-refresher.emuready.workers.dev/token` | Lite token refresh | — |
| `https://cdn-library-logo-global.bigeyes.com/` | Game logo CDN | — |
| `https://uxdl.bigeyes.com/` | Game image CDN (old) | Replaced in 6.0 by `cdn-img-uxdl.youwo.com` (Fastly+GCS) |
| `https://www.xiaoji.com/url/gsw-app-rules` | App rules page | — |
| `https://www.xiaoji.com/url/obscure-click` | Click tracking | — |

---

## 20. Themes & Styles

- `Theme.GameHub` — main app Compose theme (used by `MainActivity`)
- `Theme.WineUI` — custom AppCompat theme for Wine emulation UI (`WineActivity`)
- 13+ `haima_hmcp_*` styles — Haima HMCP cloud gaming UI (dialogs, buttons, virtual keyboard, guide steps)
- `attrs.xml`: `shortcutMatchRequired` (boolean) — custom attribute for launcher shortcut intent-filter matching
- `res/values/styles.xml` — 711 distinct style entries (most are AppCompat / Material defaults shipped via library merge)

---

## 21. Third-Party Metadata

| Key | Value |
|---|---|
| Alipay SDK App ID | `2021005104662679` |
| HiHonor push SDK version | `8.0.12.307` |
| Haima HMCP SDK version | `7.40.1` |
| Firebase Messaging | `25.0.1` |
| Firebase Crashlytics | `20.0.3` |
| Firebase Installations | `19.0.1` |
| HMS Framework (common/network/grs) | `8.0.1.304` |
| Alibaba phone-number auth (com.mobile.auth) | `2.14.17` |
| China Unicom account shield (com.unicom.online.account.shield) | `6.1.3` |
| Xiaomi Push SDK | `6_0_1-C` |
| Nordic Semi DFU | `2.3.0` |
| RxAndroidBLE | `1.11.1` |
| JieLi BT OTA | `1.10.0` |
| Zstandard JNI (luben) | `1.5.7-4` |
| WeChat App ID (primary) | `wx2075ef952b9b60c4` |
| WeChat App ID (secondary) | `wxf9d9756e4f820261` |
| QQ / Tencent OpenAPI App ID | `102667728` (also embedded in `tencent102667728://` callback scheme) |
| Epic OAuth Client ID | `34a02cf8f4414e29b15921876da36f9a` |

---

## 22. New in 6.0 vs 5.3.5

| Area | Change |
|---|---|
| Package namespace | Entire `com.xj.*` tree renamed to `com.xiaoji.egggame.*`; only 2 `com.xj.muugi.shortcut` classes survive |
| UI framework | Further migration to Jetpack Compose; 31 KMP resource modules vs ~10 in 5.x; ≈119 Compose nav routes |
| Card system | New `com.xiaoji.egggame.cardsystem` module — mini game launcher / card UI system |
| XGP integration | New — Xbox Game Pass redemption at `xgp.xiaoji.com` + `gamehub-service-dev.xiaoji.com/xgp/exchange` |
| Epic Games SDK | New — `libepickit_core.so` (UniFFI Rust) + full EGS catalog/download/cloud-save integration + recovery governance state machine |
| Retro emulation | New — Nostalgist.js 0.19.0, RetroArch WASM, 6 platforms (GB/GBA/GBC/NES/SNES/MD), JS bridge with 14 methods |
| Cloud gaming | New VTouch subsystem with queue, billing, session management |
| EmuReady Lite | Removed — all `emuready.workers.dev` endpoints gone |
| API endpoints | Old `landscape-api.vgabc.com` + `clientegg.vgabc.com` removed from DEX; `clientgsw.vgabc.com` retained as Client API base |
| HDR shaders | New — 4 Vulkan SPIR-V shaders for tone-mapping (GammaOetf, HLG, SMPTE2084, SMPTE428) |
| AV1 decoders | New — both libaom (encoder) and libdav1d (fast decoder) bundled |
| AVIF images | New — awxkee AVIF codec for cover art |
| Retro game DB | New Room database: `retro_games` + `retro_game_sessions` + `retro_game_stats` |
| Cloud game DB | New Room database: `cloud_game_sessions` |
| IAP system | New — Apple IAP + WeChat Pay + `db_pending_payment_v1.db` retry queue |
| GOG support | New LaunchType `GogGameByPcEmulator` — GOG.com via WinEmu |
| PlayStation | New LaunchTypes `PsLink` + `PsStream` — PlayStation remote play / streaming |
| Xbox Cloud Gaming | Explicit `XboxCloudGaming` LaunchType (in addition to XGP redemption) |
| Daily sign-in | New `cloud_sign/getActivity` + `cloud_sign/sign` reward system |
| ExoPlayer Media3 | New — `androidx.media3` (HLS, offline, image) |
| Analytics regions | CN + overseas separate API domains (6 new endpoint variants) |
| DEX count | 6 dex files (53,053 classes) vs 13 dex files in 5.3.5 |
| Min SDK | 31 (Android 12) — same as 5.x |
| Target SDK | 36 (Android 16) — up from 34 in 5.x |
| Native libs | 27 libs vs ~20 in 5.x; added libepickit_core.so, libdav1d.so, libcoder.so |
| Push channels | 6 channels: FCM + HMS Push + MobPush (Xiaomi/OPPO/vivo/Honor/Meizu/Unicom) vs 3 in 5.x |
| Crypto | BouncyCastle now includes post-quantum (`pqc`) package |
| Compose Navigation | v3 (`androidx.navigation3`) — 5.x used v2 |
| Steam component type | `7 → 8` for Steam *clients* (agents stay at type 5) |
| Imagefs firmware | 1.3.4 (vanilla 6.0 baseline) — Worker now serves 1.3.6 to 6.0; 5.x stays on 1.3.3 |
| WinEmu SDK | `com.winemu.*` package unchanged — HUDLayer, GPUInfoQuery, ProfilePuller, trans_layer all present |
| Steam SDK | `libsteamkit_core.so` retained; `SteamCloudSaveService` retained |

---

## 23. Decompile Output Locations

| Tool | Output path |
|---|---|
| apktool (full, with res) | `~/gamehub-6.0-decompile/` |
| apktool (smali only, ephemeral, regenerate from APK as needed) | `/tmp/gh600_smali/` |
| jadx (Java source) | `~/gamehub-6.0-jadx/` |
| Source APK | `~/GameHub_beta_6.0.0_global.apk` |

Rebuild commands:
```
java -jar ~/apktool.jar d ~/GameHub_beta_6.0.0_global.apk -o /tmp/gh600_smali -f --no-res
```

---

## 24. Related Reports

| Report | Location | Contents |
|---|---|---|
| BannerHub-API ↔ 6.0 integration | `gamehub_reports/BANNERHUB_API_6.0_INTEGRATION.md` | Worker behavior, ReVanced patches, `is60` gate, reshapeFor60, Steam remap, allowlist, 6.0 component-type table |
| HUD data sources (full) | `gamehub_reports/GAMEHUB_HUD_DATA_SOURCES.md` | Per-metric data path detail (sysfs, BatteryManager, JNI) |
| GameHub 5.3.5 master map | `gamehub_reports/GAMEHUB_535_MASTER_MAP.md` | 5.x baseline for diff comparisons |

---

## 25. Appendix A — Scan History (Passes 22–32)

After 21 initial passes (2026-05-01) the report was re-verified across 11 dimensions on 2026-05-02. Significant deltas surfaced before reaching the 3-consecutive-clean stop condition:

| Pass | Findings |
|---|---|
| **22** | Alipay/CN-carrier endpoints (5 new gateway hosts), full WinEmu native-server JNI surface (9 classes, 30+ native methods), 6 new MMKV IDs, additional URI schemes (Firebase Firebear, market://, app://, mqqapi sub-routes, weixin SDK schemes), 13+ external content:// providers, OEM-skinned package variants (`realme`, `redmagic`), secondary WeChat App ID, FlyID TCP DB (`elp_msg.db`), Compose nav routes (`HomeProfile`, `HomeTabPortrait`) |
| **23** | China-Telecom/Mobile/Unicom carrier hosts (8 new), MobPush gateways (`abroad.sdk.push.mob.com`, `sdk.push.mob.com`), FlyID server farm (`*.zztfly.com`, 7 hosts), Xiaomi push sandbox + chat hosts, Xiaoji internal dev domains (`*.mx520.com`) |
| **24** | Full SDK version inventory (15 SDKs), Alipay test/staging environments (`*.alipay.net`), Firebase Auth providers shipped (Facebook, Twitter, Play Games), Compose Navigation v3 + compottie (Lottie for Compose), AndroidX Privacy Sandbox Ads |
| **25** | `Theme.GameHub` main theme, additional vendor-launcher permission (`GET_INSTALLED_APPS`), full multi-process layout (`:p0` for MobLReceiver), AndroidApp / BaseAndroidApp manifest entry separation |
| **26** | Additional WeChat / QQ / Weibo / Google API endpoints (16 new operational paths), Google OAuth scopes |
| **27** | Port-bearing carrier endpoint URLs (`crbt.i139.cn:8143`, `nisportal.10010.com:9001`) |
| **28** | Host-diff returned only doc/license false positives (1st clean) |
| **29** | Full deep-link intent extras (11 keys vs 2 in prior map) |
| **30** | SP/MMKV key fix (`sp_k_overlay_opacity` → `sp_k_cur_overlay_opacity`), 9 new app-level SP keys |
| **31** | Host-diff still clean (2nd clean) |
| **32** | JNI surface diff clean (3rd consecutive clean) — **stop condition met** |

### 2026-05-03 layered passes (post-32)

After passes 22–32 reached the stop condition, four targeted re-verification passes added significant detail:

- **Live API + CDN verification** (2026-05-03 morning) — pulled vanilla 6.0 APK from device, extracted 7 DEX, dumped strings, probed all reachable hosts, cross-referenced against bannerhub-revanced. Surfaced the **two API surfaces** correction (Catalog vs Client), CDN host correction (`cdn-img-uxdl.youwo.com` not `bigeyes`), full probe matrix.
- **Endpoint Functional Map** (2026-05-03 mid-day) — first-pass functional grouping of every URL by what user-facing or runtime behavior it drives.
- **Reorganization + lightly-covered expansion** (2026-05-03 evening — this revision) — full restructure under §1–25, BannerHub-API integration extracted to its own report, decompile passes for: WinEmu native-server JNI methods (full signatures from jadx), all 43 Card serializer fields, perf telemetry layered DTOs (CapturedPerfSample → StoredPerfSample → DevicePerfReportDataDto → DevicePerfReportEventDto), VJoy serializer field lists (VJoyLayout/VJoyControl/ControlPosition/ControlAppearance + 30 chrome fields), WebView Java↔JS bridge methods (both `defpackage.ix` `androidJsBridge` channel and the retro emulator `JSBridgeApi` 14-method surface), `BaseAndroidApp.onCreate` actual init order (line numbers), full `cloud/*` path enumeration via smali grep (12 under cloud/game/, not 17 as earlier passes claimed), 10 epic_data/* recovery-governance JSON endpoints, 4 newly-found clientapi paths (`bind/customParam`, `jwt/oneMobile/login`, `heartbeat/game/getUserPlayTimeList`, `share/media/blank.{mkv,ptna}` + `share/pixmap`).
- **Backup of pre-rewrite map** retained at `gamehub_reports/GAMEHUB_600_MASTER_MAP.backup-2026-05-03.md`.

---

## 26. 6.0.0 → 6.0.1 Deltas (added 2026-05-07)

XiaoJi shipped GameHub 6.0.1 on 2026-05-07 (versionCode 110 → 111). This section documents the *delta* against the 6.0.0-derived map in §§ 1–25; it does NOT re-enumerate the unchanged surface. Cross-reference `BANNERHUB_API_6.0_INTEGRATION.md` § 14 for the BannerHub Worker + bannerhub-revanced patch updates triggered by these changes.

### 26.1 APK Identity bump

| Field | 6.0.0 | 6.0.1 |
|---|---|---|
| versionName | 6.0.0 | 6.0.1 |
| versionCode | 110 | 111 |
| platformBuildVersionName | 16 | 16 |
| compileSdkVersion | 36 | 36 |
| signing cert SHA-256 | f6dc89251d2edf60c5721524d59f2dc6373825a73b1b81d031cafeeff31c9775 | unchanged (same `gamesir` cert) |
| r8-map-id (source comment) | `60560d24e8bcc45c0b2a1383d0d901f6ddb757a48af5ae5971565c863742b7e9` | `1c1886510d561c4653513192b80f6aeca10d1a5fcff2e7c8e7498396fe52a4ea` |

R8 map-id changed → expect class-letter shifts everywhere. Manifest declarations are otherwise structurally identical (same providers, same activities, same permissions modulo the new vjoy nav-keys discussed in § 26.3).

### 26.2 R8 class-letter remap

The full set of letters that bannerhub-revanced patches care about. Verified against `/tmp/gh601_smali/` (apktool d --no-res from `GameHub_6.0.1.apk`). Each row is a structural anchor — re-derive on any future minor bump by matching shape, not by chasing letters.

| 6.0.0 | 6.0.1 | Role | Structural anchor |
|---|---|---|---|
| `Los0;` | `Lrs0;` | Auth-session impl | Class with three instance fields of the same StateFlow-impl type AND ctor accepting `UserDao` + `AuthTokenDao` |
| `Lis0;` | `Lls0;` | Auth-session interface | Interface with abstract `h()`/`e()`/`d()` returning a StateFlow type, default `a()Z` |
| `Lxm7;` | `Lhp7;` | GameLibraryRepository | Class with `b:AUTH_INTERFACE` field AND ctor taking `GameLibraryDatabase` + `AUTH_INTERFACE` |
| `Lg8e;` | `Lade;` | Navigator | Class with `b:AUTH_INTERFACE` field AND two methods (`i`/`r`) whose body matches `iget…ls0->a()…if-nez…new-instance Lca0;` |
| `Lga0;` | `Lca0;` | Login navigation intent | The `new-instance` referenced inside the navigator gates above |
| `Lrh0;` | `Lph0;` | Navigator gate param type | The single param type to navigator's `i`/`r` methods |
| `Ll4m;` | `Lfdm;` | Auth token wrapper | 10-field data class (S,S,S,S,Long,Long,J,Z,J,J) returned by `AUTH_INTERFACE.f()` |
| `Lf4m;` | `Ladm;` | User account | 27-field data class (a..z+A) returned by `AUTH_INTERFACE.b()` |
| `Lf3k;` | `Lr8k;` | StateFlow read interface | Interface with single abstract `getValue()Object` |
| `Lr8o;->r(Object)Lf3k;` | `Lumn;->h(Object)Lt8k;` | MutableStateFlow factory | Static `(Object)→MutableStateFlowImpl` whose body is `new-instance` + `<init>(p0)V` + `return v0` |
| `Lmcj;` | `Lzhj;` | Catalog Environment enum | The unique class containing both `landscape-api-cn.vgabc.com` AND `landscape-api-oversea.vgabc.com` string literals |
| `Lzdb;` | `Lohb;` | Static URL-path helper (Ktor pipeline) | Static method `(LBuilder;String)V` whose body starts iget-object the builder's URL field then calls a string-trim helper |
| `Lqx9;` | `Lj1a;` | Ktor URL-builder type | The first param type of the URL-path helper above |
| `Lyw9;` | TBD | Ktor URL-builder interface implemented by `Lqx9;`/`Lj1a;` | Implements interface inherited by URL builder |

bannerhub-revanced action: all 13 letters are now centralized in named const blocks at the top of `BypassLoginPatch.kt`, `RedirectCatalogApiPatch.kt`, `PrefixApiPathPatch.kt` plus the two Java extensions (`FakeAuthToken.java`, `FakeUserAccount.java`). Each const has a structural-anchor comment describing the recipe to re-derive it on the next R8 reshuffle.

### 26.3 New vjoy/Scheme cloud-share subsystem

6.0.1 introduces a full "share your touch overlay / virtual joystick layout" feature. Architecture:

#### Compose nav keys (un-mangled, kept by R8 keep-rules)
- `com.xiaoji.egggame.core.navigation.AppNavKey$VJoyMain` — main vjoy screen (entry point)
- `AppNavKey$VJoyMainSheet` — bottom sheet picker
- `AppNavKey$VJoyEdit`, `AppNavKey$VJoyHudEdit` — editing screens
- `AppNavKey$VJoyHudMain` — HUD overlay
- `AppNavKey$VJoyIconFolder`, `AppNavKey$VJoyHudIconFolder` — icon picker
- `AppNavKey$GamepadKeyMapping`, `AppNavKey$GamepadKeyMappingP1` — physical-controller key mapping (separate from vjoy)

#### Data model (kotlinx-serializable, R8-kept)
Layout schema lives in `com.xiaoji.egggame.common.ui.vjoy.model.*`:
- `VJoyControl`, `VJoyIconConfig`, `VJoyTextAlign`, `IconScaleMode`
- `ControlAction` + `ControlAction.SwitchLayer` (multi-layer schemes — matches the upstream feature note "Virtual button layouts can now be switched dynamically via keypress")
- `ControlAppearance`, `ControlPosition`, `ControlShape`, `ControlType`
- `Anchor`, `AxisRole`, `GamepadButton`, `DPadDirection`, `DPadChromeDefaults`, `VButtonChromeDefaults`, `InputMapping`
- `com.xiaoji.egggame.common.vjoy.data.OfficialLayoutEntry` + `OfficialPackEntry` — bundled official packs
- `com.xiaoji.egggame.core.domain.vjoy.model.VJoyFeedPage` — server feed page wrapper

Cloud catalog entry: `com.xiaoji.egggame.features.winemu.data.remote.SchemeDetailEntity` (21 fields):
`id` (long), `shareCode`, **`configBody`** (the full vjoy layout JSON), `gameId`, `sourceGameId`, `sourceType` (int), `createdBy`, `createdTime` (long), `shareUserAvatar`, `downloadCount` (int), `downloadRatio` (double), `activeUserRatio` (double), `matchLevel`, `matchLevelLabel`, `gpuGroupName`, `isCommon` (int), `isOfficial` (int), `isRecommend` (int), `status` (int), `schemeSource`.

`SchemeShareEntity` (4 fields): `id`, `shareCode`, `sourceGameId`, `sourceType`. Used for the lighter share-record payloads.

#### sourceType enum (`Lxu7;`)
| Value | Server name | UI/source label |
|---|---|---|
| `unknow` | UnKnow | (placeholder) |
| `steam_game` | SteamDownload | Steam-imported game |
| `pc_imported_game` | PcGameHubMgrImport | PC import via GameHub Manager |
| `imported_game` | LocalImport | Local import |
| `gamehub_download_pc_game` | GameHubSvrDownload | GameHub-hosted PC game |

#### Repository / ViewModel
- Repository: `Lnyf;` implements `Lkyf;` — config-share API surface. Constructor `<init>(Lj40;Lzi5;Lhp7;)V` (CoroutineScope + HTTP client + GameLibraryRepository).
- ViewModel: `Lf1g;` extends `Lxc1;` — fields `i:Ljcf;`, `j:Lkyf;`. Has 23 methods (`a..K`).
- Feed loader UI tag: `VJoy_MainRecommend` (Logcat tag visible during failures)
- In-app cache key shape: `vjoy_recommend_list:gameId=<n>:type=<n>:page=<n>:size=20`

#### Bundled assets
- `composeResources/com.xiaoji.egggame.common.vjoy/files/vjoy/layout/index.json` — official packs index
- `composeResources/com.xiaoji.egggame.common.vjoy/files/vjoy/icons/index.json` — official icon set
- 30+ drawable assets under `composeResources/com.xiaoji.egggame.features.vjoy/drawable/features_vjoy_*.{xml,png,jpg}`

#### On-device storage
No Room entity / table for downloaded schemes — the `configBody` JSON is persisted via **MMKV** (the app's primary KV store, accessed via `MMKV.mmkvWithID(...)` in `WineActivity.smali`). Path on device: `/data/data/<variant pkg>/files/mmkv/`. The 30-MB SP key prefix `gamepad_key_mapping_p1_` (in `Ldw5;`) tracks the physical-controller mapping separately.

### 26.4 New API endpoint family

| Path | Method | Purpose |
|---|---|---|
| `/vcontroller/recommendMapList` | GET | Recommended vjoy layouts feed (paginated; `game_id`, `is_official`, `page`, `page_size`) |
| `/vcontroller/shareMap` | POST | Upload a layout to share |
| `/vcontroller/getMapByShareCode` | GET | Resolve a layout by share code |
| `/simulator/configList` | GET | Per-game saved-config list (`list_type`, `game_id`, `steam_appid`, `source_game_id`, `source_type`, `page`, `page_size`, `steam_id`, `game_type`, `gpu_*`) |
| `/simulator/getConfigById` | GET | Fetch one config |
| `/simulator/shareConfig` | POST | Upload a per-game config |
| `/simulator/deleteShareConfig` | POST | Remove a shared config |
| `/simulator/reportConfigApply` | POST | Telemetry: user applied a config |
| `/readLayoutType/query` | GET | Read user's chosen layout-type preference |
| `/writeLayoutType/set` | POST | Persist user's layout-type preference |

**Authentication shape (captured live 2026-05-07):** GET requests carry `clientparams` + `sign` (MD5-of-sorted-params + secret) + `time` headers — no `token`, no `Authorization`, no token-in-query. Upstream returns `{code:401, msg:"Please login first"}` for any unauthenticated request. The bannerhub-revanced bypass-login patch makes the *client* think it's logged in (so the call fires) but does NOT add a token to the wire — the BannerHub Worker fixes this server-side via the proxy in `BANNERHUB_API_6.0_INTEGRATION.md` § 14.5.

### 26.5 New 6.0.1-only NavigationInterceptor (`Lar0;`)

A separate interceptor class added in 6.0.1. Implements `Llxb;` (NavigationInterceptor-style interface), declares `getOrder() == 10`. Its `a(Ldxb;Lgvb;Laf3;)Object` method:
- iget-object `Lar0;->a:Lls0;` (auth-session field)
- invoke-interface `Lls0;->a()Z`
- if-nez `:cond_0` (skip on logged-in)
- new-instance `Lcyb;` with `Lm64;` arg → return as a "redirect-to-login" navigation result
- `:cond_0` → delegate to the next interceptor in the chain via `Lgvb;->a(Ldxb;Lbf3;)`

Acts as a parallel auth gate independent of the navigator class (`Lade;` in 6.0.1 / was `Lg8e;` in 6.0.0). The `BypassLoginPatch` short-circuits this gate identically (replaces `invoke-interface a()Z` + `move-result` with `const/4 vN, 0x1`).

### 26.6 Firmware version bump

- 6.0.0 + earlier 6.0.1 client → asks Worker for `getImagefsDetail` → BannerHub Worker returned **firmware 1.3.4** (versionCode 24, asset `imagefs_v134.zst`, MD5 `76a186c04196c0ffe31ea1ab88705b83`, 168 MB)
- Worker bumped 2026-05-07 (commit `687a9ac`) → returns **firmware 1.3.5** (versionCode 25, asset `imagefs_v135.zst`, MD5 `d2242c284e42cbbe49289caf4506b95d`, 164 MB)
- Worker bumped 2026-05-08 (commit `280687f`) → **current: firmware 1.3.6** (versionCode 26, asset `imagefs_136.zst`, MD5 `bc95fcb8dc02dac7d61e1be7dd374aeb`, 171,913,961 B / ~164 MB)
- File listing inside 1.3.6 is byte-identical to 1.3.5 (same 7,799 entries); the only meaningful delta is `usr/lib/libGameScopeVK.so` rebuilt — 2,218,920 → 2,218,904 B (-16 B), MD5 `17993261…` → `6d611691…`. Same Vulkan ICD JSON (`api_version 1.3.216`). No UI surface change.
- 5.x clients still get firmware 1.3.3 from the static `imagefs.zst` (untouched by all three bumps; the `/v6/` gate routes 6.0 traffic to the current asset only)
- v134 + v135 both retained on the Components release as rollback safety

### 26.7 Upstream feature highlights (XiaoJi-side, from the 6.0.1 release notes)

These are XiaoJi's own client-side changes that BannerHub users inherit by virtue of running v1.0.1-601:

1. Improved Steam login + game download stability
2. Faster Steam game launch speeds
3. Virtual button layouts can now be switched dynamically via keypress (matches the new `ControlAction.SwitchLayer` data class — a layout can declare named layers and a keybind switches between them at runtime)
4. Multiple new touchscreen input methods
5. Gyroscope support for camera control
6. AI frame generation now supported across all games (separate from any LSFG-VK / DLL-based frame-gen experiments — this is XiaoJi's own host-code feature)
7. Numerous bug fixes

---

### 26.8 — AI Frame Generation — Technical Deep Dive

> Internal name: **AI Frame Interpolation**. User-facing name: **AI Frame Generation**. Classes live under `com.xiaoji.egggame.common.winemu.bean.*` (R8-kept). The user-facing toggle is in the **Wine in-game sidebar/drawer** — not in pre-launch settings.

#### 26.8.1 Data classes (kotlinx-serializable, kept)

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
  └─ Extreme   (model=1, multiplier=1, flowScale=0.8, enabled=true)   ← model 1, mult=1 (UI label only — see 26.8.4)
```

Each mode carries:
- `enabled: boolean` — whether selectable (Disabled is the only `enabled=false`)
- `model: int` — 0 = standard interpolation, 1 = "clear/extreme" (different shader path)
- `multiplier: int` — frame multiplier (2 = 60→120 fps; 1 = unusual, see 26.8.4)
- `flowScale: float` — optical-flow algorithm strength, range 0.2–1.0
- `nameResId: int` — `iih.ai_frame_interpolation_mode_*`
- `sliderLabelResId: int` — `iih.ai_frame_interpolation_label_*`

`Companion.defaultEnabled` = `Balanced`.

#### 26.8.2 Persistence — `WineInGameSettingType`

```
WineInGameSettingType.AiFrameInterpolation
  ├─ key   = "AiFrameInterpolation"
  ├─ scope = WineSettingScope.Game        (per-game / per-container)
  └─ codec = WineSettingCodec.Json(AiFrameInterpolation.class)
```

Stored via `p0o.x(WineInGameSettingType, value)` → MMKV.encode under the variant package's MMKV root. Sits alongside other in-game settings (FullScreen, Hdr, Crt, SuperResolution, FpsLimit, NativeRendering, RedMagicPerformanceMode, KeyControlsAlpha, VirtualGamepadVibration, TouchScreenMouseControl, SimulateTouchScreen, ScreenTouchInput, GyroAim, GamepadSensitivity, DrawerGuideShown).

#### 26.8.3 Runtime IPC — `etc/gamescope.control` mmap

The Java side communicates with the in-imagefs compositor via a 10-byte memory-mapped file at `<wineprefix>/etc/gamescope.control`. Wrapper class: `defpackage.ca2` (file constructor — `ca2(File file)`).

**Buffer layout (10 bytes, little-endian):**

| Offset | Size | Field | Initial | Setter | Notes |
|---|---|---|---|---|---|
| 0–1 | 2 B | uint16 reserved/version | 0 | (init only) | `putShort((short) 0)` in ctor |
| 2 | 1 B | **enabled flag** | 0 | `ca2.G(boolean)` | 0=AI frame interp off, 1=on |
| 3 | 1 B | NativeRenderingMode (0=Auto, 1=Never, 2=Always) | 0 (Auto) | `sz4.b(NativeRenderingMode)` | not new in 6.0.1 — pre-existing slot |
| 4–7 | 4 B | **AI flowScale float** | 0.6 | `sz4.a(...)` | clamped 0.2–1.0 via `br5.x()` |
| 8 | 1 B | **AI model byte** | 0 | `sz4.a(...)` | `0` = standard, `1` = clear/extreme |
| 9 | 1 B | **AI multiplier byte** | 2 | `sz4.a(...)` | clamped 2–4 via `br5.y()` |

Total file size = 10 bytes. Created via `RandomAccessFile("rw")` + `channel.map(READ_WRITE, 0, 10)`. Each write is followed by `MappedByteBuffer.force()` to flush. `ca2.G(boolean)` writes only the enabled byte (offset 2).

#### 26.8.4 The `multiplier=1` quirk

`AiFrameInterpolationMode.Extreme` has `multiplier=1` in the Kotlin enum, BUT the IPC writer (`sz4.a()`) clamps via `br5.y(multiplier, 2, 4)` so the byte at offset 9 is always 2-4 inclusive. **Extreme's multiplier=1 is silently coerced to 2 at the IPC layer.** This implies `multiplier=1` is a UI-label-only marker (used elsewhere to choose iconography or label text) and the actual frame-multiplier delivered to the compositor is always 2× minimum. Reverse-engineered hypothesis: `multiplier` in the enum is not the literal frame multiplier — it's a "model variant" tag the UI uses to differentiate Clear (`mult=2`) from Extreme (`mult=1`) presets while both run at 2× compositor multiplication.

#### 26.8.5 Compositor side — `libGameScopeVK.so`

Path inside imagefs (firmware 1.3.5 / 1.3.6): `usr/lib/libGameScopeVK.so`. Size: 2,218,920 B in 1.3.5; **2,218,904 B in 1.3.6** (-16 B, rebuilt — different MD5, same Vulkan ICD api version). ARM64 ELF, NDK r28-beta1. Sizes/strings below were captured from the 1.3.5 build.

**Internal name:** `GameScopeVK`. Built from a Mac dev tree (`/Users/me/Documents/GameScopeVK/gamescope/...`). Source files referenced in DWARF strings:
- `direct_rendering_client.cpp`
- `gamescope.cpp`
- `gamescope_shader.cpp`
- `gamescope_swapchain.cpp`
- `vulkan_dispatch.cpp`

**Architecture:** Vulkan **ICD** (Installable Client Driver). It chains in front of the real Vulkan driver via the loader's ICD chain. Exports the standard ICD entry points: `vk_icdGetInstanceProcAddr`, `vk_icdGetPhysicalDeviceProcAddr`, `vk_icdNegotiateLoaderICDInterfaceVersion`.

**Registered via** `<wineprefix>/usr/home/steamuser/.config/vulkan/icd.d/GameScopeVK_icd.json`:
```json
{
  "file_format_version": "1.0.0",
  "ICD": {
    "library_path": "/data/data/com.winemu/files/usr/lib/libGameScopeVK.so",
    "api_version": "1.3.216"
  }
}
```
Note: the path is hardcoded for `com.winemu` — likely a placeholder rewritten at install time, OR an artifact from XiaoJi's separate `com.winemu` standalone-runtime APK that GameHub may install/bind-mount.

**Linked dependencies** (ELF NEEDED): only standard system libs — `libandroid`, `liblog`, `libEGL`, `libGLESv2`, `libGLESv3`, `libX11`, `libX11-xcb`, `libxcb`, `libxcb-dri3`, `libxcb-present`, `libvulkan`, `libm`, `libdl`, `libc`. **NO ML inference framework** (no NCNN, no ONNX Runtime, no TensorFlow Lite). The "AI" is implemented as Vulkan compute shaders embedded inside `libGameScopeVK.so`, using `VK_NV_optical_flow` for hardware-accelerated motion vector estimation.

**Embedded class names:** `gamescope::FPSCounter`, `gamescope::FPSCallback`, `gamescope::FPSCounterWithCallback`, `gamescope::Swapchain`.

**Diagnostic strings present** (sample): `"Frame interpolation backend created"`, `"Frame interpolation backend creation failed"`, `"Frame interpolation execution failed: {}"`, `"Frame interpolation warmup failed: {}"`, `"begin warmup command buffer failed"`, `"warmup ingest failed"`, `"warmup submit failed"`, `"invalid warmup input"`, `"GameScope control enabled"`, `"Failed to open control file: {}"`, `"GameScopeVK: [BYPASS_XSERVER] Status changed: {}"`.

**Environment variables consumed** (loader-level config):
- `GAMESCOPE_CONTROL_PATH` — path to the 10-byte `gamescope.control` mmap (overrides default location)
- `GAMESCOPE_DRIVER_PATH` — real Vulkan ICD to chain to (the underlying GPU driver)
- `GAMESCOPE_DEVICE_MEMORY_LIMIT` — memory-cap override
- `GAMESCOPE_DUMP_FAILURES` — diagnostic dump toggle
- `GAMESCOPE_SURFACE_USING_BGRA` — pixel-format hint

#### 26.8.6 The `VK_NV_optical_flow` ↔ Adreno bridge

> **Full driver-nerd writeup is its own report: `gamehub_reports/VK_NV_OPTICAL_FLOW_ON_ADRENO.md`.** This subsection is the in-context summary; the dedicated report covers chip-level dispatch, embedded compute pipelines, ICD chaining, and the silent-fail recipe in detail.

`VK_NV_optical_flow` is **a Vulkan extension specification, not a hardware lock.** NVIDIA designed the spec around their RTX 40-series fixed-function Optical Flow Accelerator (OFA), but Vulkan extension names are namespaced by *who proposed* the spec — the ABI is open. Any vendor's driver can answer the same entrypoints and advertise support.

XiaoJi's Mesa Turnip fork (`libvulkan_freedreno.so`, 13 MB, NDK r29 / Android 34, also in the imagefs) **legitimately implements** the extension as plain Vulkan compute shaders running on Adreno's regular shader cores. Confirmed by symbol presence — full per-chip C++ template instantiation set:

```
libvulkan_freedreno.so:
  tu_CreateOpticalFlowSessionNV<chip 6>     Adreno 6xx (640/650/660/680)
  tu_CreateOpticalFlowSessionNV<chip 7>     Adreno 7xx (730/740/750)        ← verified-working device (A750)
  tu_CreateOpticalFlowSessionNV<chip 8>     Adreno 8xx / Adreno X1
  tu_DestroyOpticalFlowSessionNV<chip 6/7/8>
  tu_BindOpticalFlowSessionImageNV<chip 6/7/8>
  tu_CmdOpticalFlowExecuteNV<chip 6/7/8>
```

Plus the Vulkan loader-facing entrypoints (`vkCreateOpticalFlowSessionNV`, `vkCmdOpticalFlowExecuteNV`, `vkGetPhysicalDeviceOpticalFlowImageFormatsNV`) and the spec's struct-type strings (`VkPhysicalDeviceOpticalFlowFeaturesNV`, `VK_STRUCTURE_TYPE_OPTICAL_FLOW_SESSION_CREATE_INFO_NV`, etc.). Turnip advertises the extension via `vkEnumerateDeviceExtensionProperties` and exposes the feature struct via `vkGetPhysicalDeviceFeatures2(VkPhysicalDeviceOpticalFlowFeaturesNV)` — from the application's perspective the device looks identical to an RTX 40-series.

**Per-chip dispatch is not cosmetic.** The `IL4chip{6,7,8}EE` template parameter is Mesa's standard "compile this function separately per Adreno generation" pattern — generations vary in wave width, FP16 dot-product accumulator widths, texture-gather ISA, and image-store coherency. `tu_physical_device->info->chip` indexes into the right specialisation at session-create time. **One Turnip build covers Adreno 6xx through Adreno X1.**

**Implementation strategy:** Adreno has no fixed-function OFA, so the chip-specific `tu_*` functions can only be dispatching Vulkan compute pipelines — almost certainly leveraging Adreno's image-gather instructions (block-matching cost-volume), FP16 dot-product MAD lanes (SAD/NCC accumulation), and hardware mip-map generation (cheap pyramid building for hierarchical OF). Performance is much worse than RTX OFA — the AI Frame Generation report budgets ~10–20% extra GPU cost on Adreno — but the contract is identical.

**Consumer side (`libGameScopeVK.so`):** Vulkan ICD shim. NEEDED list is only `libvulkan`, `libandroid`, `liblog`, `libEGL`, `libGLES*`, `libX11*`, `libxcb*`, `libm/dl/c` — **no NCNN, ONNX, TFLite, or CUDA**. The "AI" is an embedded compute pipeline visible as named stages in the binary's strings: `delta0..delta9` (10 stages) + `gamma0..gamma4` plus a `gamma23` fused stage. On `vkQueuePresentKHR` the shim calls `vkCmdOpticalFlowExecuteNV` against the chained driver, then dispatches its delta/gamma pipelines consuming the OF vectors as input alongside the two reference frames, and blits the synthetic mid-frame into the swapchain.

**This is the technical magic enabling AI frame-gen on phone GPUs.** Without `VK_NV_optical_flow` on the device's Vulkan ICD chain, libGameScopeVK fails at `vkCreateOpticalFlowSessionNV`, logs `"Frame interpolation backend creation failed"` via `liblog`, and the swapchain falls back to passthrough — silent no-op. Devices on stock vendor Vulkan drivers (Qualcomm / ARM / PowerVR) won't get AI frame-gen even with GameHub 6.0.1 installed; only devices running through XiaoJi's bundled Turnip fork (or another Turnip build with the OF feature flag enabled — `Turnip_v26.2.0_R3` is the confirmed-good driver from our 2026-05-08 successful run) will.

#### 26.8.7 UI surface

User-facing strings (`res/values-en/strings.xml`):

| Key | English |
|---|---|
| `ai_frame_interpolation_plus` | "AI Frame Generation" (top-level feature title) |
| `ai_frame_interpolation_header` | "Frame Generation" (section header) |
| `winemu_sidebar_ai_frame_interpolation_enable` | "Enable frame generation" (toggle label) |
| `winemu_sidebar_ai_frame_interpolation_preset` | "Preset" (sub-section) |
| `ai_frame_interpolation_mode_disabled` | "Disabled" |
| `ai_frame_interpolation_mode_fast` | "Power Saving" |
| `ai_frame_interpolation_mode_smooth` | "Smooth mode" |
| `ai_frame_interpolation_mode_balanced` | "Balanced mode" |
| `ai_frame_interpolation_mode_enhanced` | "Enhanced mode" |
| `ai_frame_interpolation_mode_clear` | "Clear mode" |
| `ai_frame_interpolation_mode_extreme` | "Extreme mode" |
| `ai_frame_interpolation_label_fast` | "Eco" (slider pill) |
| `ai_frame_interpolation_label_smooth` | "Flow" |
| `ai_frame_interpolation_label_balanced` | "Bal" |
| `ai_frame_interpolation_label_enhanced` | "Boost" |
| `ai_frame_interpolation_label_clear` | "Clear" |
| `ai_frame_interpolation_label_extreme` | "Max" |

Per-mode descriptions (in `winemu` Compose-resources strings under `winemu_sidebar_ai_frame_interpolation_*_desc`):
- Disabled: "Disabled. Frame rate and power usage will not be changed."
- Fast: "Lowest overhead, suitable for lower-end devices or battery-sensitive play."
- Smooth: "Low overhead smoothness boost for most lightweight games."
- Balanced: "Recommended. Balances smoothness, power usage, and stability."
- Enhanced: "Stronger motion smoothing for users who prefer extra fluidity."
- Clear: "Prioritizes a steadier, cleaner image with fewer motion artifacts."
- Extreme: "Highest quality preset with the highest power and performance cost."

The sidebar slider track shows 6 enabled positions (Eco · Flow · Bal · Boost · Clear · Max). "Disabled" is a separate off-state above the slider, not a slider position.

Translations present in: ar, en, es, ja-rJP, pt-rBR, ru-rRU, zh-rCN, plus dozens more locale folders (full multi-language support — XiaoJi treats this as a flagship feature).

#### 26.8.8 Action / state classes (Java/Kotlin)

| Class | Role |
|---|---|
| `defpackage.r1o` | `UpdateAiFrameInterpolationMode(mode)` — UI/store action (user picked a mode) |
| `defpackage.e3o` | `ApplyAiFrameInterpolationMode(mode)` — service action (commit to mmap) |
| `defpackage.sz4.a(AiFrameInterpolationMode)` | The actual mmap writer (3-step: model byte + flowScale float + multiplier byte + force) |
| `defpackage.ie9` | `ysj` adapter — receives `e4o` actions, fans out to setting-specific handlers |
| `defpackage.wzn` | `xc1` ViewModel — holds Wine activity state including current AI mode |
| `defpackage.g1j` | Slider position picker (maps slider float → AiFrameInterpolationMode by index) |
| `defpackage.m5o` | Static `int[]` ordinal-index dispatch tables for all 7 enum values |
| `defpackage.y1m` | Polymorphic invoke lambda — handles AiFrameInterpolationMode default fallback to `Disabled` |

#### 26.8.9 Per-GPU capability gating

**No client-side gate exists in the APK** — searched `com.xiaoji.egggame.*` for any GPU-vendor / device-model / Vulkan-extension check on `AiFrameInterpolation` and found nothing. The release-note phrasing "AI frame generation now supported across all games" means **no per-game allowlist** in the client; it does NOT mean every device can use it.

The runtime gate is **silent** in `libGameScopeVK.so`: if `VK_NV_optical_flow` isn't available on the device's loaded Vulkan ICD chain, the swapchain interpolation backend creation fails with `"Frame interpolation backend creation failed"` (logged via `liblog`) and the swapchain falls back to passthrough — frame-gen no-ops without any user-visible error. Users will simply see no fps doubling.

**To verify on a given device:** check whether the active Vulkan driver advertises `VK_NV_optical_flow`. With XiaoJi's bundled Turnip Mesa fork (`libvulkan_freedreno.so`, Adreno chip-6 family) → yes. With the device's stock vendor Qualcomm/ARM/PowerVR Vulkan driver → almost certainly no.

---

### 26.9 — Steam SDK Refresh

`com.xiaoji.egggame.common.steam_sdk.bridge.AndroidSteamBridgeTransport` gained 11 new SuspendLambda inner classes for cancellable / async operation handling. Native lib `libsteamkit_core.so` grew **+510 KB** (10,000,064 → 10,522,712). New DTOs:
- `AppcacheRootDto` + `AppcacheRootRequestDto` — Steam appcache management
- `DownloadCancelledEventDto` — explicit cancellation event payload

Removed: `SetPreferDeviceCodeRequest$$serializer` (cleanup).

The 11 new lambda classes implement: `cancelOperation$1`, `close$1`, `executeCancellable$2$1`, `pollOperation$1`, `sendNetworkStatus$2`, `syncNetworkStatus$1`, `syncNetworkStatus$1$1`, `syncNetworkStatus$1$2`, `syncNetworkStatus$1$3`, plus a `submitOperation$1` and the `b` package-companion. Together these enable: graceful cancellation of in-flight Steam downloads, periodic network-status sync to upstream Steam, and clean resource teardown on activity destroy. Matches the 6.0.1 release-note bullets "Improved Steam login and game download stability" + "Faster Steam game launch speeds".

Also: SQL schema for `download_tasks` table now exposes new query shapes filtering by `downloader_type` + `source_id` (cancellable-download support).

### 26.10 — vjoy Multi-Layer Architecture

The vjoy/Scheme system gained per-layer composition support — matches the 6.0.1 release-note bullet "Virtual button layouts can now be switched dynamically via keypress".

New classes under `com.xiaoji.egggame.common.ui.vjoy.model.*`:
- `VJoyLayer` — a single layer (collection of controls)
- `VJoyLayer$Companion` + `VJoyLayer$$serializer`
- `VJoyLayerDefaults` — default layer configuration
- `VJoyLayoutJson` — top-level layout container that holds a list of layers
- `VJoyLayoutCompatKt` — backwards-compat shim for legacy single-layer layouts (auto-wraps them in a single `VJoyLayer`)
- `VJoyLegacyMappingCompatKt` — backwards-compat for older `mapping` field shapes
- `ControlAction` (sealed) + `Companion`
- `ControlAction$SwitchLayer` + `Companion` + `$$serializer` — concrete action that switches the active layer when bound to a button
- `VJoyTextAlign` + `Companion` — text alignment values for control labels
- `AxisRole` — analog stick axis role (existed conceptually, now formalized)

Interaction model: a `VJoyControl`'s `mapping` field can now (in addition to `keyboard` / `directional` classes) be a `ControlAction` like `SwitchLayer(targetLayerId)`. Pressing such a button switches the active layer in the overlay, exposing a different set of buttons. Multiple layers can be defined per layout (e.g., "movement layer" + "combat layer" + "menu layer").

Schema-side: the existing `.gtheme` ZIP format's `layout.json` gained a `layers` array (nullable for backwards compat — single-layer layouts get wrapped at load time via `VJoyLayoutCompatKt`).

### 26.11 — Gyroscope + New Touchscreen Input Methods

New `WineInGameSettingType` enum entries (registered in 26.8.2's table):
- `GyroAim` (key=`"GyroAim"`, scope=Game, codec=Json(`GyroAim.class`)) — matches "Gyroscope support for camera control" release-note bullet
- `ScreenTouchInput` (key=`"ScreenTouchInput"`, scope=Game, codec=Json(`ScreenTouchInput.class`)) — matches "Multiple new touchscreen input methods"

New data classes:
- `com.xiaoji.egggame.common.winemu.bean.GyroAim` (+ Companion)
- `com.xiaoji.egggame.common.winemu.bean.GyroAimTargetMode` — enum, **5 values**: `Mouse` (gyro drives mouse look), `GamepadSlot0`, `GamepadSlot1`, `GamepadSlot2`, `GamepadSlot3` (gyro drives a virtual gamepad slot — supports up to 4 simultaneous virtual gamepads).
- `com.xiaoji.egggame.common.winemu.bean.ScreenTouchInput`
- `com.xiaoji.egggame.common.winemu.bean.ScreenTouchInputMode` — enum, **4 values**: `Disabled`, `Trackpad` (raw screen-touch routes through a virtual trackpad cursor), `Touchscreen` (game-native touchscreen passthrough), `RightStick` (screen touch becomes a virtual right-analog-stick — for camera control in shooters).

Also new MMKV key `gyro_aim` (legacy migration target).

The vjoy-side enum additions (used by VJoyControl `mapping.class:"directional"` configs):
- `com.xiaoji.egggame.common.ui.vjoy.model.AxisRole` — enum, **4 values**: `LeftStick`, `RightStick`, `MousePointer`, `Unknown`. Tags an analog stick's role for virtual-gamepad-stick vs mouse-cursor binding.
- `com.xiaoji.egggame.common.ui.vjoy.model.VJoyTextAlign` — enum, **4 values**: `Left`, `Center`, `Right`, `Justify`. Per-control label-text alignment.

### 26.12 — Box64 Per-Game Tunable UI (~80 new strings)

A major new "Box64 advanced" UI surfaces ~30 individual tunable parameters per game with title/description string pairs and value-label sets. New string-resource keys (`tp_*` prefix, ~80 total in `res/values-en/strings.xml`):

**Title/description pairs** (each tunable has `tp_<Name>Title` + `tp_<Name>Desc`):
- `AlignedAtomics`, `BigBlock`, `Box64AVX` (separate from generic `AVX`?), `CallRet`, `CpuType`, `DF`, `DIV0`, `Dirty`, `Dynarec`, `FastNan`, `FastRound`, `HalfBarrierTSOEnabled`, `HideHypervisorBit`, `IgnoreINT3`, `MaxInst`, `MemcpySetTSOEnabled`, `MonoHacks`, `Multiblock`, `NativeFlag`, `Pause`, `RDTSC1GHZ`, `SMCChecks`, `SmallTSCScale`, `TSOEnabled`, `VectorTSOEnabled`, `VolatileMetadata`, `VolatileMetadataBox64`, `Wait`, `WeakBarrier`, `X87Double`, `X87ReducedPrecision`

**Value-label sets** (per-tunable enumerations, e.g. `tp_avx_0`/`tp_avx_1`/`tp_avx_2` for the 3-value AVX selector):
- `tp_aligned_atomics_*` (2 vals), `tp_avx_*` (3), `tp_big_block_*` (4), `tp_call_ret_*` (2), `tp_cpu_type_*` (2), `tp_dirty_*` (3), `tp_fast_nan_*` (2), `tp_fast_round_*` (2), `tp_pause_*` (4), `tp_safe_flags_*` (3), `tp_smc_checks_*` (3 — full/mtrack/none), `tp_strong_mem_*` (4), `tp_wait_*` (2), `tp_weak_barrier_*` (3), `tp_x87_double_*` (2)

These map 1:1 to the Box64 environment-variable tuning options documented at https://github.com/ptitSeb/box64/blob/main/docs/USAGE.md — XiaoJi has surfaced them as per-game UI controls. Power users can now tune Box64 dynarec / TSO / x87 / SMC behavior per game without editing config files.

### 26.13 — Wine HUD Overlay Strings (MangoHud Integration)

7 new string-resource keys for in-game HUD labels: `winemu_hud_label_charging`, `winemu_hud_label_cpu`, `winemu_hud_label_fps`, `winemu_hud_label_gpu`, `winemu_hud_label_power`, `winemu_hud_label_ram`, `winemu_hud_label_temperature`. Wires up the existing `MangoHud.aarch64.json` implicit Vulkan layer (already in the imagefs at `usr/share/vulkan/implicit_layer.d/`) to a localizable label set. Also new `defpackage.com.xiaoji.egggame.common.winemu.hud.HUDConfig` (referenced from `defpackage.ie9.java` imports).

### 26.14 — PC Game Data Backup / Restore (NEW Feature)

New string-resource keys: `winemu_pc_game_data_backup_{loading,fail,finish}`, `winemu_pc_game_data_recover_{loading,fail,finish}`, `winemu_pc_game_data_backup_recover_tips`, `winemu_pc_game_data_backup_recover_permission_tips`. Per-game Wine `drive_c` snapshot/restore — useful for save-game preservation across container reinstalls.

### 26.15 — Wine Performance Modes (Power Profiles)

New string keys: `wine_performance_mode`, `wine_performance_mode_balanced`, `wine_performance_mode_boost`, `wine_performance_mode_powersaving`. Three switchable power profiles for Wine. Implementation likely throttles Box64 dynarec / GPU clock / CPU governor differently per profile. Note this is **separate from `RedMagicPerformanceMode`** (which is device-vendor-specific to Nubia Red Magic phones and pre-existed in 6.0.0).

### 26.16 — Setup / Install Flow Rewrite

~30 new string keys covering the first-run setup + per-game imagefs/component installation experience, with a focus on better progress UI:
- `winemu_imagefs_installation`, `winemu_imagefs_installation_complete`
- `winemu_setup_check_{common,dep,steam,virtual}_component_*`
- `winemu_setup_download_{base,dep_component,dep_child_component}_complete_tips`
- `winemu_setup_downloading_{info,remaining,remaining_default,speed,tips}`
- `winemu_setup_install_{component,dep,depcomponent_*,env_*}`
- `winemu_setup_applying_game_settings`, `winemu_setup_game_settings_applied`
- `winemu_setup_server_null_tips`, `winemu_setup_check_virtual_container_install_fail`

### 26.17 — Container State Check + Game-File Validator

Pre-launch validation strings: `winemu_check_virtual_container_fail_no_container`, `winemu_check_virtual_container_fail_try_again`, `winemu_container_state_check`, `winemu_choose_game_file_parse_failure`, `validator_error_exe_file_not_found`, `pc_s_local_game_exe_path_error`, `pc_s_miss_dxvk_tips`, `pc_s_miss_translator_tips`, `pc_s_miss_vkd3d_tips`, `pc_cc_broken`, `disable_graphics_enhancement_plugin`, `disable_plugin_warning`, `force_enable`. Better error UX when a game's required components aren't installed or the .exe path is wrong.

### 26.18 — DTO Package Move (`core.domain.base.*` → `core.network.model.baseinfo.dto.*`)

Three classes moved package without changing shape:
- `core.domain.base.BaseInfoDto` → `core.network.model.baseinfo.dto.BaseInfoDto`
- `core.domain.base.SteamUrlReplaceItem` → `core.network.model.baseinfo.dto.SteamUrlReplaceItemDto` (note: also renamed, gained `Dto` suffix)
- (third old removal: `SetPreferDeviceCodeRequest` — fully removed, no replacement)

`BaseInfoDto` gained 3 new fields per the new MMKV keys (Pass 4): `epic_games_hidden`, `retro_games_hidden`, `steam_games_hidden` (Boolean flags). Lets the catalog hide entire game-source families per-user.

### 26.19 — Resource Asset Additions

| File | Size | Purpose |
|---|---|---|
| `assets/composeResources/com.xiaoji.egggame.features.home/drawable/features_home_library_game_default.png` | 873 KB | New default cover image for library games (replaces older smaller default; ~90× size jump = much higher resolution) |
| `assets/composeResources/com.xiaoji.egggame.features.home/drawable/lib_second_ic_guide_finger.png` | 1.7 KB | Tap-here guide finger icon for the landscape library import flow |
| `assets/composeResources/com.xiaoji.egggame.features.splash/files/splash/launcher_en.gif` | 154 KB | English animated splash GIF |
| `assets/composeResources/com.xiaoji.egggame.features.splash/files/splash/launcher_zh.gif` | 172 KB | Chinese animated splash GIF |
| `res/{7_,No,jH,wc}.xml` | 752 B each | 4 new tiny compiled-resource XMLs (likely overlay/theme deltas) |

Removed: 10 small `res/*.webp` files (3,242–14,596 B each) — obsolete static assets superseded by the new defaults.

Also: 4 new launcher-icon vector path-include files in `drawable*/` (`$ic_launcher_foreground__1.xml` through `$ic_launcher_foreground__4.xml`) — AAPT split a refined launcher-icon vector into additional path-layer files. Cosmetic refinement, no behavior change.

### 26.20 — Native Library Refresh

`lib/arm64-v8a/` count unchanged at 27. Two existing libs got refreshed:

| Lib | 6.0.0 | 6.0.1 | Δ |
|---|---|---|---|
| `libsteamkit_core.so` | 10,000,064 B | 10,522,712 B | **+510 KB** (Steam SDK refresh — see 26.9) |
| `libepickit_core.so` | 4,767,696 B | 4,717,576 B | -50 KB (Epic SDK minor update) |

**No new `.so` files for AI frame generation in the APK.** The frame-gen library `libGameScopeVK.so` lives inside the imagefs/firmware (firmware 1.3.5, `imagefs.zst` asset on the upstream catalog) — see 26.6 + 26.8.5.

### 26.21 — Manifest Correction

One-line fix: `android.hardware.usb.host` was incorrectly declared as `<uses-permission>` in 6.0.0; corrected to `<uses-feature>` in 6.0.1. No other manifest deltas — same activities, services, providers, receivers, permissions, intent-filters, meta-data values, authorities, resource refs.


### 26.22 — Additional sidebar features (ZH-only translations as of 6.0.1 ship; EN translation pending)

9 new string keys present only in `res/values-zh-rCN/strings.xml` (English translations missing — XiaoJi shipped 6.0.1 before EN translation caught up; the underlying features exist):

- **Gyro calibration state machine** — 4 outcomes for the gyro setup flow:
  - `winemu_sidebar_gyro_aim_calibration_started`
  - `winemu_sidebar_gyro_aim_calibration_success`
  - `winemu_sidebar_gyro_aim_calibration_failed`
  - `winemu_sidebar_gyro_aim_calibration_unavailable`
  Implies a per-device calibration step (likely sample the resting gyroscope offset and store as a per-device baseline) with success/failure states. The "unavailable" state covers devices without a usable gyroscope sensor.
- **Force-exit game** — `winemu_exit_game_force`, `winemu_exit_game_progress` — adds a "force kill the running Wine container" action with a progress UI (probably for runaway games that don't respond to normal exit).
- **Trackpad sensitivity slider** — `winemu_sidebar_touch_input_trackpad_sensitivity` (separate slider from `key_trackpad_pointer_speed` MMKV key in §26 main string list — sensitivity is the multiplier, pointer speed is the absolute speed).
- **Virtual gamepad toggle** — `winemu_sidebar_virtual_gamepad_enable` — in-sidebar on/off for the virtual on-screen gamepad overlay (alongside the existing `WineInGameSettingType.VirtualGamepadVibration`).
- **Mouse speed description** — `winemu_sidebar_mouse_speed_desc` (new help-text body for an existing slider).


---

## 27. 6.0.1/6.0.2 → 6.0.4 Deltas (added 2026-05-12)

Audit basis: 6.0.4 apktool decompile at `gamehub-6.0.4-nologin/apktool_out/` vs the 6.0.0/6.0.2 reference at `gamehub-6.0-decompile/` + `gamehub-600-jadx/`. APK source: `/storage/emulated/0/Download/GameHub_6.0.4-Patched.apk` (141,518,945 B).

### 27.1 APK Identity Bump

| Field | 6.0.0/6.0.1 | 6.0.4 |
|---|---|---|
| versionCode | 110 | **114** |
| versionName | 6.0.0 / 6.0.1 | **6.0.4** |
| minSdkVersion | 31 | **29** (Android 10 — broader device support) |
| targetSdkVersion | 36 | 36 (unchanged) |

The minSdk widening from 31 → 29 is paired with new legacy Bluetooth permissions gated to `maxSdkVersion=30`:

- `android.permission.BLUETOOTH` (maxSdkVersion=30)
- `android.permission.BLUETOOTH_ADMIN` (maxSdkVersion=30)

These are the pre-Android-12 BT perms; on API 31+ the runtime `BLUETOOTH_CONNECT`/`BLUETOOTH_SCAN` flow handles permissions, but legacy SDK paths still need the old perms declared for ≤30.

### 27.2 New MTDataFiles SDK

New third-party SDK: **Matryoshka MTDataFiles** (`bin.mt.file.content.*`), a SAF-style file-content provider that exposes the app's game-data directory to Android's Documents UI. This is the same SDK used by mt-manager and similar Chinese file-manager apps.

New manifest entries:

- **Activity:** `bin.mt.file.content.MTDataFilesWakeUpActivity` (exported, taskAffinity=`com.xiaoji.egggame.MTDataFilesWakeUp`)
- **Provider:** `bin.mt.file.content.MTDataFilesProvider` (authorities=`com.xiaoji.egggame.MTDataFilesProvider`, exported, grantUriPermissions=true, requires `android.permission.MANAGE_DOCUMENTS`)
- **Intent filter:** new action `android.content.action.DOCUMENTS_PROVIDER` on the provider

Effect: third-party file managers can browse the app's external files dir directly through the SAF picker. Likely added so power users can install/manage Wine mods and game saves from their preferred file manager without needing root.

### 27.3 AI Frame Interpolation Mode Enum (Beans)

New smali beans formalize the AI frame-gen mode selection that was UI-only in 6.0.1 ([[GAMEHUB_600_MASTER_MAP § 26.8]]):

- `smali_classes4/com/xiaoji/egggame/common/winemu/bean/AiFrameInterpolation.smali`
- `smali_classes4/com/xiaoji/egggame/common/winemu/bean/AiFrameInterpolationMode.smali`
- `smali_classes4/com/xiaoji/egggame/common/winemu/bean/AiFrameInterpolationMode$Companion.smali`

New string keys for the six modes:

| Internal key | English label | ZH label (existing) |
|---|---|---|
| `ai_frame_interpolation_mode_disabled` | (off) | (off) |
| `ai_frame_interpolation_mode_fast` | Fast | (existing) |
| `ai_frame_interpolation_mode_balanced` | Balanced | (existing) |
| `ai_frame_interpolation_mode_enhanced` | Enhanced | (existing) |
| `ai_frame_interpolation_mode_smooth` | Smooth | (existing) |
| `ai_frame_interpolation_mode_extreme` | Extreme | (existing) |

Plus short label strings for compact UI: `ai_frame_interpolation_label_eco`/`_bal`/`_flow`/`_boost`/`_clear`/`_max`. Header string `ai_frame_interpolation_header` = "Frame Generation".

**No new VK_NV_optical_flow or mmap-protocol strings detected** in smali or resources — the underlying frame-gen runtime stays inside `libwinemu.so` + the imagefs-shipped `libGameScopeVK.so` (see § 26.8). The 6.0.4 deltas are surface-level (mode selection + localization), not pipeline changes.

### 27.4 Native Library Refresh

`lib/arm64-v8a/` count unchanged at 27. Two libs got refreshed:

| Lib | 6.0.1 | 6.0.4 | Δ |
|---|---|---|---|
| `libsteamkit_core.so` | 10,522,712 B (~10.0 MB) | ~11 MB | **+~500 KB** (continued Steam SDK refresh) |
| `libwinemu.so` | 668 KB | 643 KB | -3.7% (minor optimization) |

All other libs (`libhaima_rtc_so.so`, `libaom.so`, `libepickit_core.so`, etc.) byte-stable.

### 27.5 New Resource Qualifier Folders

| Folder | Purpose |
|---|---|
| `res/values-en/` | English-specific strings (split from default — previously English lived in `res/values/` as fallback) |
| `res/values-v30/` | API 30+ resource overrides |
| `res/values-v31/` | API 31+ resource overrides |

The English split lets XiaoJi maintain English translations cleanly without falling back to the Chinese-first default. The `-v30`/`-v31` folders pair with the minSdk widening to 29: certain styles/strings need version-gated variants now that the app runs on API 29 too.

### 27.6 Alipay SDK Pruning

Two Alipay subpackages removed:

- `com.alipay.apmobilesecuritysdk` — Alipay APM (Antifraud / Mobile Security SDK)
- `com.alipay.android` — Alipay Android app framework

Retained: lightweight payment SDKs (`com.alipay.sdk`, `com.alipay.mobile`, `com.alipay.tscenter`). Likely a size/security optimization — the removed SDKs are device-fingerprinting + antifraud telemetry that bloat the APK without contributing to actual payment flow.

### 27.7 R8 Class-Letter Remap Update

Hand-spot-checked re-anchoring of known-cited classes against § 26.2 / § 26.5:

| Old (6.0.0/6.0.1) | New (6.0.4) | Identity |
|---|---|---|
| `Lar0;` | **`Lixo;`** | NavigationInterceptor (was 6.0.1-only — see § 26.5) |
| `defpackage/{various}` | `com.xiaoji.egggame.BaseAndroidApp` | **BaseAndroidApp now deobfuscated** in 6.0.4 (kept in plain package, was previously R8-renamed to defpackage in some passes) |

Same R8 build id is in play (`r8-map-id-6a5cde6143fc8cf76f6f3a447d0fececd4794d83066e6ead7a9537e6527b057b` source line on most defpackage classes), so the bulk of the remap is incremental, not a wholesale shuffle. Anyone re-anchoring smali patches from 6.0.1 to 6.0.4 should grep for the symbolic identity (string literal it operates on, layout id it inflates) rather than blindly porting letter names.

### 27.8 New `org/` Package — BouncyCastle Post-Quantum Crypto

New top-level smali package: `smali/org/bouncycastle/` ships BouncyCastle. The agent did not find evidence of size change, so this is likely the same BC version that was previously bundled inside other packages — surfaced into its canonical `org.bouncycastle.*` namespace in 6.0.4 (which makes it easier to call directly and supports the PQ-crypto interfaces that newer Android/Java toolchains expect).

No new functional surface for the GameHub side; this is a dependency-organization change.

### 27.9 Smali Class Count Growth

| | 6.0.0/6.0.1 | 6.0.4 | Δ |
|---|---|---|---|
| Total `.smali` files across all `smali*/` dirs | 53,053 | 53,768 | **+715 (+1.3%)** |

Most of the +715 lives in:

- New `bin.mt.file.content.*` (MTDataFiles SDK, § 27.2)
- New `org.bouncycastle.*` (PQ-crypto, § 27.8)
- New `com.xiaoji.egggame.common.winemu.bean.AiFrameInterpolation*` (§ 27.3)
- Internal R8 lambda/synthetic churn (the source build-id changed, so many `defpackage/` lambdas got fresh names even where behavior is unchanged)


