# BannerHub

Rebuild pipeline for **GameHub 5.3.5 ReVanced Normal** using apktool. Applies smali and resource patches to add a Component Manager and BCI launcher button directly inside GameHub.

## Features

### Component Manager
Accessible via GameHub's left side menu → **Components**.

- Lists all installed components from `files/usr/home/components/`
- **Inject WCP/ZIP** — pick any `.wcp` or `.zip` file via the Android file picker. Supports:
  - **ZIP** (Turnip / adrenotools GPU drivers) — flat extraction to component root
  - **zstd tar** — DXVK, VKD3D, Box64: preserves `system32/`+`syswow64/` structure; FEXCore: flat to component root
  - **XZ tar** — same logic as zstd path
- **Backup component** — copies component folder to `Downloads/BannerHub/{name}/`
- Component folder is fully cleared before every injection (no stale files)
- Extraction runs on a background thread; errors are surfaced as toasts

### BCI Launcher Button
Tap the banner icon in GameHub's top-right toolbar to open **BannersComponentInjector** (`com.banner.inject`). Shows a toast if it is not installed.

### UI Tweaks
- "My" tab renamed to "My Games"

## How it works

1. The original APK is stored as a GitHub Release asset under the `base-apk` tag (GameHub 5.3.5 ReVanced Normal, 136 MB).
2. CI downloads it, decompiles with apktool, overlays everything in `patches/`, rebuilds, zipaligns, and signs.
3. The rebuilt APK is uploaded as a GitHub Release asset.

No external library injection — the Component Manager uses GameHub's own bundled libraries (commons-compress, zstd-jni, tukaani xz) via their correct runtime signatures.

## Installation

1. Download `Gamehub-rebuilt.apk` from the [latest stable release](https://github.com/The412Banner/bannerhub/releases/latest).
2. Uninstall any existing copy of the same GameHub package first.
3. Install the APK.

> Built on GameHub 5.3.5 ReVanced Normal. Coexists with other GameHub variants (Lite, AnTuTu, etc.).

## Triggering a build

- Push a `v*` tag: `git tag v2.1.0 && git push origin refs/tags/v2.1.0`
- Or: **Actions → Build APK → Run workflow**

## Signing

Signed with the committed `keystore.jks` (debug key).
- Alias: `bannerhub`
- Password: `bannerhub123`
