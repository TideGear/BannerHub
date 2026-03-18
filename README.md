# BannerHub

**GameHub 5.3.5 ReVanced** — enhanced with a full Component Manager, in-app component downloader, RTS touch controls, VRAM unlock, per-game CPU core affinity, Steam offline launch, and more. Built with apktool — no root required.

## Video — Installation & Feature Showcase

[![BannerHub Installation & Features](https://img.youtube.com/vi/Vwv8YNnWWdg/maxresdefault.jpg)](https://youtu.be/Vwv8YNnWWdg?si=Ypz66yMU8ZQUngU9)

*Installing the app, installing games, and showcasing all features.*

---

## Features

### Component Manager
Accessible via GameHub's left side menu → **Components**.

- Lists all installed components from `files/usr/home/components/`
- **Add New Component** — inject a WCP or ZIP file as a brand new component slot; it appears in GameHub's DXVK / VKD3D / Box64 / FEXCore / GPU Driver selection menus immediately and persists across restarts
- **Inject file** — replace an existing component's contents with a new WCP or ZIP file
- **Backup** — copies a component folder to `Downloads/BannerHub/{name}/`
- **Remove** — unregisters the component from GameHub's in-memory map and deletes the folder
- Supports ZIP (Turnip / adrenotools GPU drivers), zstd tar (DXVK, VKD3D, Box64), and XZ tar (FEXCore nightlies)
- FEXCore: flat extraction to component root; all other types preserve `system32/` + `syswow64/` structure
- Component folder cleared before every inject (no stale files); extraction runs on a background thread

### In-App Component Downloader
Inside the Component Manager type-selection menu, tap **↓ Download from Online Repos** to browse and download components directly from GitHub without leaving GameHub.

- **3-level navigation:** repo → category (DXVK / VKD3D / Box64 / FEXCore / GPU Driver) → filtered asset list
- **Two sources built-in:**
  - **The412Banner Nightlies** — nightly builds of DXVK, VKD3D-Proton, Box64, FEXCore fetched via GitHub Releases API
  - **Arihany WCPHub** — curated WCP component pack fetched via flat `pack.json`
- Tap any asset to download it to cache and inject it as a new component automatically

### BCI Launcher Button
Tap the icon in GameHub's top-right toolbar to open **BannersComponentInjector** (`com.banner.inject`) directly from inside GameHub. Shows a toast if it is not installed.

### RTS Touch Controls
*Thanks to [@Nightwalker743](https://github.com/Nightwalker743) for making this possible!*

Enable via **Settings → Controls tab** in the in-game sidebar. Adds a full gesture overlay for PC and RTS games:

- **Tap to click** — moves cursor and left-clicks at tap position
- **Drag for box selection** — holds LMB while dragging to draw a selection box
- **Long press for right-click** — 300ms hold triggers right-click
- **Double-tap for double-click** — two taps within 250ms / 50px
- **Two-finger pan** — camera pan (configurable)
- **Pinch-to-zoom** — mouse wheel scroll (configurable)
- **Gesture settings dialog** — tap the gear icon in the Controls tab to customize two-finger and pinch actions

### VRAM Limit Unlock
PC game settings → **VRAM Limit** now includes 6 GB, 8 GB, 12 GB, and 16 GB options in addition to the original 512 MB–4 GB range. The selected value is saved to MMKV and reflected in the settings summary immediately.

### PC Game Settings: Offline Mode
Opening PC game settings while offline no longer blocks the menus. Previously a `NoCacheException` from the remote API made all settings non-interactive. Both the container list and component list now fall back to empty data so the UI remains fully usable without a network connection.

### Per-Game CPU Core Affinity
PC game settings → **Core Count** now opens a multi-select dialog to choose exactly which CPU cores a game may use.

- 8 cores listed individually: Core 0–3 (Efficiency), Core 4–6 (Performance), Core 7 (Prime)
- **Apply** saves the selected core bitmask for that game
- **No Limit** clears the affinity mask (unrestricted)
- **Cancel** discards changes with no save
- Selecting all 8 cores and tapping Apply is treated as No Limit
- Tapping Apply with nothing selected shows a warning toast and does not save
- The settings row label refreshes immediately after any change

### Offline Steam Launch
When autoLogin fails and no network is available at cold start, the Steam login screen is skipped and the game launch pipeline proceeds using cached config. When network is available and autoLogin fails, the login screen is shown as normal.

### UI Tweaks
- "My" tab renamed to **"My Games"**
- EmuReady API toggle defaults to **off** on fresh installs (Settings → Advanced)

---

## Installation

Download the APK matching your existing GameHub package from the [latest release](https://github.com/The412Banner/bannerhub/releases/latest):

| APK | Package | App Label |
|-----|---------|-----------|
| `Bannerhub-5.3.5-Revanced-Normal.apk` | `gamehub.lite` | GameHub Revanced |
| `Bannerhub-5.3.5-Revanced-PuBG.apk` | `com.tencent.ig` | GameHub Revanced PuBG |
| `Bannerhub-5.3.5-Revanced-AnTuTu.apk` | `com.antutu.ABenchMark` | GameHub Revanced AnTuTu |
| `Bannerhub-5.3.5-Revanced-alt-AnTuTu.apk` | `com.antutu.benchmark.full` | GameHub Revanced AnTuTu |
| `Bannerhub-5.3.5-Revanced-Ludashi.apk` | `com.ludashi.aibench` | GameHub Revanced Ludashi |
| `Bannerhub-5.3.5-Revanced-Genshin.apk` | `com.mihoyo.genshinimpact` | GameHub Revanced Genshin |
| `Bannerhub-5.3.5-Revanced-Original.apk` | `com.xiaoji.egggame` | GameHub Revanced |

Each APK uses a unique package name and provider authority — all 7 variants can be installed simultaneously without conflicts. All APKs are signed with AOSP testkey (v1/v2/v3).

> **Note:** You must uninstall any previous BannerHub build before installing a new one if the signing certificate changed.

---

## How It Works

1. The original GameHub 5.3.5 ReVanced APK is stored as a release asset under the `base-apk` tag (136 MB).
2. CI downloads it, decompiles with apktool, overlays everything in `patches/`, rebuilds, zipaligns, and signs.
3. The rebuilt APKs are uploaded as GitHub Release assets.

No external library injection — the Component Manager uses GameHub's own bundled libraries (commons-compress, zstd-jni, tukaani xz) via their runtime signatures.

---

## Signing

Signed with AOSP testkey (`testkey.pk8` / `testkey.x509.pem`), v1 + v2 + v3 signatures.
