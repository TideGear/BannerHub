# BannerHub Community Config System — Full Implementation Report

**Date:** 2026-04-03
**Stable release:** v2.8.7

---

## Overview

The community config system allows BannerHub users to export their per-game settings (including installed components) to a JSON file, share that file to an online community database, and import configs from that database on any device. It was designed so that no credentials, API keys, or sensitive information are ever stored in the app, the GitHub repo, or any user-facing file.

---

## What Gets Exported

When a user exports a game config, BannerHub reads two data sources:

### 1. Game Settings (`pc_g_setting<gameId>` SharedPreferences)
All key/value pairs stored by GameHub for that game — renderer settings, CPU translator choice (Box64/FEXCore), DXVK/VKD3D selection, FPS limit, controller mappings, VRAM limit, core affinity, and every other per-game option.

### 2. Installed Custom Components (`banners_sources` SharedPreferences)
The Component Manager tracks every component installed with a download URL. On export, these are collected into a JSON array:
```json
{
  "name": "DXVK-async-2.6",
  "url":  "https://github.com/...",
  "type": "DXVK"
}
```
Only components that have a tracked download URL are included — manually sideloaded components without a URL are skipped since they can't be auto-downloaded on another device.

### Output JSON format
```json
{
  "settings": {
    "cpu_translator": 2,
    "fps_limit": 60,
    ...
  },
  "components": [
    { "name": "DXVK-async-2.6", "url": "https://...", "type": "DXVK" },
    { "name": "Box64-0.3.4",    "url": "https://...", "type": "Box64" }
  ]
}
```

### Filename
```
GameName-Manufacturer-Model-UnixTimestamp.json
```
Example: `Cyberpunk_2077-Samsung-Galaxy_S24-1743712345.json`

The Unix timestamp ensures every upload is unique — no two uploads ever overwrite each other, even from the same device.

---

## Architecture

The system has three layers:

```
BannerHub APK
    │
    │  HTTP (no auth required)
    ▼
Cloudflare Worker
(bannerhub-configs-worker)
    │
    │  GitHub Contents API (server-side auth)
    ▼
GitHub Repo
(The412Banner/bannerhub-game-configs)
```

### Layer 1 — BannerHub App (`BhSettingsExporter.java`)

A Java extension class injected into the BannerHub APK handles all local and network operations:

- Reads/writes SharedPreferences for settings and component tracking
- Saves configs to `/sdcard/BannerHub/configs/` on the device
- Makes plain HTTP POST requests to the Cloudflare Worker for uploads
- Makes plain HTTP GET requests to the Worker to list and download community configs
- Shows AlertDialogs for user choices (export destination, import source, missing components)
- Downloads and injects missing components via reflection to `ComponentInjectorHelper.injectComponent`

**No credentials are stored in the app.** Upload requests contain only the game name, filename, and base64-encoded JSON. The Worker validates and writes to GitHub using server-side secrets the app never sees.

### Layer 2 — Cloudflare Worker

A small JavaScript Worker deployed to Cloudflare's edge network acts as the authenticated middleware between the app and GitHub. The Worker exposes three public endpoints:

| Endpoint | Method | Purpose |
|---|---|---|
| `/list?game=<name>` | GET | List all configs for a game, sorted newest first |
| `/upload` | POST | Write a config file to the GitHub repo |
| `/download?game=<name>&file=<filename>` | GET | Proxy raw file content from GitHub |

The Worker holds the GitHub API token as an encrypted Cloudflare secret (set at deploy time via the CF REST API — never written to any file or repo). When the app calls `/upload`, the Worker uses this token server-side to commit the file to GitHub via the GitHub Contents API. The app itself never has access to this token.

**Security model:** Upload is intentionally open (no app-side secret). The only files that can be written are JSON files inside the `configs/` directory of the `bannerhub-game-configs` repo. The worst-case abuse scenario is spam uploads of junk game configs — this has no impact on the app's security, the user's device, or any other system.

### Layer 3 — GitHub Repo (`The412Banner/bannerhub-game-configs`)

A public GitHub repository that stores all shared configs:

```
bannerhub-game-configs/
└── configs/
    ├── Cyberpunk_2077/
    │   ├── Cyberpunk_2077-Samsung-Galaxy_S24-1743712345.json
    │   └── Cyberpunk_2077-OnePlus-11-1743800000.json
    ├── The_Witcher_3/
    │   └── The_Witcher_3-Xiaomi-14_Pro-1743900000.json
    └── ...
```

Each game gets its own subfolder. Files are never overwritten — timestamps in the filename guarantee uniqueness. The repo is public so configs are browsable and downloadable directly at:
**https://github.com/The412Banner/bannerhub-game-configs**

---

## How Import Works

1. User taps **Import Config** → chooses **My Device** or **Browse Community**

**My Device path:**
- Lists all `.json` files in `/sdcard/BannerHub/configs/`
- User picks one → apply flow starts

**Browse Community path:**
- App calls `GET /list?game=<gameName>` on the Worker
- Worker queries the GitHub Contents API for that game's folder
- Returns a sorted list: `[{ filename, device, date, download_url, ... }]`
- App shows a dialog with device + date labels
- User picks one → app downloads the raw JSON
- Apply flow starts

**Apply flow (both paths):**
1. Parse the JSON
2. Build a `SharedPreferences.Editor` with all settings — but **don't apply yet**
3. Check `components` array against `banners_sources` SP to find missing components
4. If none missing → `editor.apply()` immediately
5. If some missing → show dialog listing missing components
   - **Skip** → `editor.apply()` immediately
   - **Download All** → download each component in a background thread, inject via `ComponentInjectorHelper.injectComponent` (called via Java reflection since the class is smali-only), register in `banners_sources` SP, then `editor.apply()`

Settings are always applied **after** the component choice so component-dependent settings (like CPU translator selection) are registered correctly.

---

## How It Was Added to BannerHub

BannerHub has no source code — everything is patched into a decompiled GameHub APK using apktool smali bytecode injection. The config system required changes at three levels:

### 1. New Java extension class
`extension/BhSettingsExporter.java` — compiled into the extension JAR and included in `classes18.dex` (a new DEX added to avoid the 65535-method limit on the existing DEX files).

### 2. New smali lambda classes
Two smali files in `patches/smali/` are copied directly into the decompiled APK:
- `BhExportLambda.smali` — triggered when user taps "Export Config"; holds `GameDetailSettingMenu` (for Activity context via `.z()`) + `GameDetailEntity` (for game ID and name)
- `BhImportLambda.smali` — triggered when user taps "Import Config"; same structure

Both get the Activity context via `GameDetailSettingMenu.z()` — critical because `AlertDialog` requires a live Activity window token, not an Application context.

### 3. Smali injection into `GameDetailSettingMenu.W()`
The build workflow's Python patch script injects code into `GameDetailSettingMenu.W()` (a Kotlin coroutine that builds the game settings options list) to add two new `Option` entries — "Export Config" and "Import Config" — each backed by their respective lambda.

The injection navigates a coroutine state machine: `W()` is compiled to a smali state machine with labels 0/1/2. At the injection point, `v5` holds the continuation object and `v5.L$0` holds the `GameDetailEntity` (saved by Kotlin before the first suspend point). The `GameDetailSettingMenu` reference (`this`) lives in `p0` which maps to register `v19` — out of range for standard `invoke-direct` (max v15), so it's moved to `v4` first via `move-object/from16`.

### 4. CI workflows
Both `build-quick.yml` (pre-release, Normal APK only) and `build.yml` (stable, 9 APKs) run the Python patch script. One key difference: `build.yml` decompiles to `apktool_out_base/` while `build-quick.yml` decompiles to `apktool_out/` — the patch script paths must match accordingly.

---

## What Is NOT Stored Anywhere Sensitive

| Item | Where it lives | What has access |
|---|---|---|
| GitHub API token | Cloudflare encrypted secret | Worker only (server-side) |
| Cloudflare account credentials | Local terminal session only | Never written to any file |
| User game settings | Device SharedPreferences + local JSON | User's device only |
| Shared configs | Public GitHub repo | Anyone (intentionally public) |

- No credentials in any committed file
- No credentials in any report or documentation
- No credentials in the APK
- No credentials in the Cloudflare Worker source code (token is an environment binding, not a hardcoded value)

---

## Community Database

**Repo:** https://github.com/The412Banner/bannerhub-game-configs

The database starts completely empty. It grows entirely through user contributions. Users with working configs for specific games on specific devices are encouraged to share them via "Save Locally + Share Online" so that less experienced users can import a tested starting point instead of tuning from scratch.

---

## Files Involved

| File | Purpose |
|---|---|
| `extension/BhSettingsExporter.java` | All export/import logic, community HTTP calls, component download+inject |
| `patches/smali/.../BhExportLambda.smali` | Lambda for Export Config menu tap |
| `patches/smali/.../BhImportLambda.smali` | Lambda for Import Config menu tap |
| `.github/workflows/build-quick.yml` | Pre-release build — smali injection into `GameDetailSettingMenu.W()` |
| `.github/workflows/build.yml` | Stable build — same injection, `apktool_out_base/` path |
| `/tmp/bannerhub-configs-worker.js` | Cloudflare Worker source (local only, deployed via CF REST API) |
| `The412Banner/bannerhub-game-configs` | Public GitHub repo storing all shared config files |
