# GameNative → BannerHub: GOG download improvements port — credits

Tracks the upstream commits from [`utkarshdalal/GameNative`](https://github.com/utkarshdalal/GameNative) being ported into BannerHub's `extension/GogDownloadManager.java`. Each entry records the source commit, PR, author(s), and current port status so contributors can be credited in BannerHub release notes when the work ships.

**Port branch:** `feature/gog-toast-diagnostic` (may rename when port lands)
**Last upstream sync point:** `dd25c2a4` (BannerHub fork base — pre-port)
**Date created:** 2026-05-14
**Driving user report:** POSTAL 2 (GOG id `1207658755`) download failing on 2 of 1475 files due to CDN chunk refusal — see in-progress diagnostic toast work on the same branch

## 🚀 Port status: SHIPPED in v3.7.3 (2026-05-14) — 📱 device-confirmed 2026-05-14

All four pieces ported on `feature/gog-toast-diagnostic`, merged to main as `a477165` (the `--no-ff` GOG-overhaul merge commit), shipped as part of the **v3.7.3 stable** (tag commit on `c884fab` after the framegen-onresume merge). Device-confirmed during pre-release testing on POSTAL 2 (multi-CDN fallback survived a single-CDN failure mid-install) and Citadel Remonstered (468/468 files clean on Auto).

Original hypothesis was first device-confirmed via the **diagnostic toast build (commit `974508f`)** with the same user:
- Toast text on diagnostic build (verified in `bh_gog_debug (1).txt` line 300): `Download failed: 4/1475 (hart.ukx +3) files`
- Same 4 `.ukx` files in `Paradise Lost/Animations/` failed all 3 retry attempts
- Identical chunk-refusal pattern to original report (`bh_gog_debug.txt`), now worsening (4/4 fail vs original 2/4 fail) — confirmed CDN edge node consistently blocks these specific chunks for this user's network

Implementation landed in:
- `extension/BhCdnHelper.java` (new) — Java port of CdnRankingUtils with `probeAndRank` (for the picker UI) and `rankByLatency` (for the download path)
- `extension/GogDownloadManager.java` — `parseCdnUrl` → `parseCdnUrls` (List), `appendPathBeforeQuery` helper, multi-CDN cycling in the runGen2 retry loop (`attempt N → fCdnBases.get((attempt-1) % cdnCount)`), backoff capped at 8s, max attempts auto-scaled to `min(6, max(3, 2 × cdnCount))`

CDN picker UI + ↻ Refresh button + install-state PARTIAL recovery + diagnostic toast all landed as follow-up commits on the same branch before the merge. All four pieces shipped together in v3.7.3.

---

## The "multi-CDN" package (ships together — pieces interdepend)

These 4 commits all feed into one mechanic: parse all CDN URLs from GOG's `secure_link` response → HEAD-probe rank them by latency → build a list of N candidate URLs per chunk → on retry attempt N use a different CDN node. Without all 4, the user gains nothing — half a port is no port.

### 1. CDN URL HEAD-probe ranking (`CdnRankingUtils`)

| Field | Value |
|---|---|
| **Commit** | [`e78d402e`](https://github.com/utkarshdalal/GameNative/commit/e78d402e98b9f7882200c0ba3be4e3fb3b63545b) |
| **PR** | [#1220 — "Aligned epic downloads to GOG to make it faster from eg India"](https://github.com/utkarshdalal/GameNative/pull/1220) |
| **Author** | Utkarsh Dalal `<dalal.utkarsh@gmail.com>` |
| **Co-author** | Utkarsh Dalal `<utkarsh.dalal@toptal.com>` |
| **Date** | 2026-04-14 |
| **Upstream file** | `app/src/main/java/app/gamenative/utils/CdnRankingUtils.kt` |
| **BannerHub target** | New helper (likely `extension/BhCdnHelper.java`), called from `GogDownloadManager.runGen2` after `parseCdnUrls` |
| **Status** | 🚀 Shipped in v3.7.3 (2026-05-14) — 📱 device-confirmed 2026-05-14 (branch feature/gog-toast-diagnostic merged to main as a477165) |

### 2. Per-chunk URL candidates + token-in-query-string-safe URL builder

| Field | Value |
|---|---|
| **Commit** | [`979c278f`](https://github.com/utkarshdalal/GameNative/commit/979c278f193612c56d91211724231469e886e3ef) |
| **PR** | [#1219 — "Jb/streaming assembly utkarsh"](https://github.com/utkarshdalal/GameNative/pull/1219) |
| **Author** | Utkarsh Dalal `<dalal.utkarsh@gmail.com>` |
| **Co-authors** | Jeremy Bernstein `<jeremy.d.bernstein@googlemail.com>`, Utkarsh Dalal `<utkarsh.dalal@toptal.com>` |
| **Date** | 2026-04-14 |
| **Upstream files** | `app/src/main/java/app/gamenative/service/gog/api/GOGManifestParser.kt` (`buildChunkUrlCandidates`), `GOGDownloadManager.kt` (`urlCandidates[attempt % size]` retry loop) |
| **BannerHub target** | `GogDownloadManager.runGen2` — replace inline chunk URL builder at lines 403–405 with `appendPathBeforeQuery`; replace retry loop at lines 393–444 with multi-URL round-robin |
| **Status** | 🚀 Shipped in v3.7.3 (2026-05-14) — 📱 device-confirmed 2026-05-14 (branch feature/gog-toast-diagnostic merged to main as a477165) |

### 3. GOG chunk URL parser — token-in-query-string fix (`appendPathBeforeQuery`)

| Field | Value |
|---|---|
| **Commit** | [`749c0c6e`](https://github.com/utkarshdalal/GameNative/commit/749c0c6e6cb24e0866a3c2c579d6c4013a14ea49) |
| **PR** | [#1215 — "GOG chunk URL broken when CDN token is in query string"](https://github.com/utkarshdalal/GameNative/pull/1215) |
| **Author** | Bart Zaalberg (UnbelievableFlavour) `<bart.zaalberg@shift2.nl>` |
| **Date** | 2026-04-14 |
| **Upstream file** | `app/src/main/java/app/gamenative/service/gog/api/GOGManifestParser.kt` (`appendPathBeforeQuery` helper) |
| **BannerHub target** | `GogDownloadManager.java` — replaces inline `qIdx = fCdnBase.indexOf('?')` workaround at lines 403–405 with proper builder that handles trailing slashes, missing `?`, and edge cases |
| **Status** | 🚀 Shipped in v3.7.3 (2026-05-14) — 📱 device-confirmed 2026-05-14 (appendPathBeforeQuery helper replaces the inline lines 403-405 workaround) |

### 4. Download efficiency refactor (`downloadChunkWithRetry`)

| Field | Value |
|---|---|
| **Commit** | [`d958c0fd`](https://github.com/utkarshdalal/GameNative/commit/d958c0fd97816c3bf76cd21c07f53a0b5c326e1f) |
| **PR** | [#1277 — "feat/refactor: Improve GOGDownloadManager download efficiency"](https://github.com/utkarshdalal/GameNative/pull/1277) |
| **Author** | Joshua Tam (JT) `<297250+joshuatam@users.noreply.github.com>` |
| **Date** | 2026-04-23 |
| **Upstream file** | `app/src/main/java/app/gamenative/service/gog/GOGDownloadManager.kt` — `downloadChunkWithRetry` function structure with exponential backoff (`RETRY_DELAY_MS * (1 shl attempt)`) and cross-CDN cycling |
| **BannerHub target** | `GogDownloadManager.runGen2` — backoff loop pattern + cycle URL candidates per attempt |
| **Status** | 🚀 Shipped in v3.7.3 (2026-05-14) — 📱 device-confirmed 2026-05-14 (branch feature/gog-toast-diagnostic merged to main as a477165) |

---

## How to credit in release notes

When the port ships in a BannerHub stable release, the release notes should include something like:

> **Improved GOG download reliability** — multi-CDN URL ranking + retry-across-CDNs port from upstream [utkarshdalal/GameNative](https://github.com/utkarshdalal/GameNative). Thanks to:
> - Utkarsh Dalal (utkarshdalal/GameNative maintainer) — [PR #1220](https://github.com/utkarshdalal/GameNative/pull/1220), [PR #1219](https://github.com/utkarshdalal/GameNative/pull/1219)
> - Joshua Tam — [PR #1277](https://github.com/utkarshdalal/GameNative/pull/1277)
> - Bart Zaalberg — [PR #1215](https://github.com/utkarshdalal/GameNative/pull/1215)
> - Jeremy Bernstein (co-author on #1219)

---

## How to update this doc

When porting begins for a piece:
- Update Status to `🚧 In progress (BannerHub commit: <sha>)`

When a piece lands in a BannerHub commit:
- Update Status to `✅ Ported (BannerHub commit: <sha>, branch: <branch>)`

When the port ships in a BannerHub stable release:
- Update Status to `🚀 Shipped in v<X.Y.Z> (release date)`

When user-confirmed working (device test or community report):
- Append `📱 device-confirmed YYYY-MM-DD` to the Status line

---

## Verification log

All commit hashes and PR numbers verified 2026-05-14 against `utkarshdalal/GameNative` at upstream HEAD (post-`5df274c9`). Author identities and co-author trailers pulled from `git show --format='%an <%ae>'` and commit body `Co-authored-by:` lines. URLs constructed against `https://github.com/utkarshdalal/GameNative/commit/<sha>` and `https://github.com/utkarshdalal/GameNative/pull/<n>` — both schemes confirmed against existing PRs in the repo.
