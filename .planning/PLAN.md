# GSD Plan — VELOCITY Game Engine Specialization (Phase 3)

> **Phase Goal**: Transform VELOCITY into the premier high-speed web torrent client for large PC games (50 GB – 150 GB+).  
> **Strict Guardrail**: Zero automatic file exclusions without user consent; all language files remain included by default with clear guidance provided before any action.

---

## 1. Work Breakdown Structure (Waves)

```mermaid
flowchart TD
    subgraph Wave 1: Core Engine Classification
        W1_1[backend/game_engine.py File Classifier] --> W1_2[Guidance Generator Engine]
        W1_2 --> W1_3[Disk Space Preallocation Guard]
    end

    subgraph Wave 2: Gaming QoS & REST API
        W2_1[Gaming Process Detection Thread] --> W2_2[Auto-Throttle Dynamic QoS]
        W2_2 --> W2_3[REST Endpoints for Components & Presets]
    end

    subgraph Wave 3: Checksum & Post-Download
        W3_1[SFV / MD5 Checksum Verification Pass] --> W3_2[Windows Mount-DiskImage Integration]
        W3_2 --> W3_3[Safe Installer Launcher]
    end

    subgraph Wave 4: Frontend UI Components
        W4_1[Game Advisor Guidance Modal] --> W4_2[Inspector Game Hub Tab]
        W4_2 --> W4_3[Header Game Mode Status Pill]
    end

    subgraph Wave 5: QA & CDP Verification
        W5_1[tests/test_game_engine.py] --> W5_3[Zero Regression Release Gate]
        W5_2[tests/verify_all_buttons_cdp.py Updates] --> W5_3
    end

    Wave 1 --> Wave 2 --> Wave 3 --> Wave 4 --> Wave 5
```

---

## 2. Detailed Task Specifications

### Wave 1: Core Game Classifier & Guidance Generator
- **[NEW] `backend/game_engine.py`**:
  - Class `GameRepackClassifier`:
    - Recognizes pattern tokens in filenames:
      - `LANGUAGE_PACK`: `selective-french`, `optional-german`, `lang-russian`, etc.
      - `TEXTURE_PACK`: `optional-4k`, `high-res-textures`, `4k-videos`.
      - `INSTALLER`: `setup.exe`, `install.exe`, `autorun.inf`.
      - `CHECKSUM`: `*.sfv`, `*.md5`, `checksums.txt`, `QuickSFV.exe`.
      - `BASE_GAME`: All primary game archives (`data1.bin`, `fg-01.bin`, `base.iso`).
    - Generates human-friendly guidance strings:
      - For languages: *"Optional Voiceover Pack. Yes, the game will run 100% smoothly in English without this file. Skipping will save {size} of bandwidth."*
      - For 4K textures: *"Optional 4K Ultra Texture Pack. The game will run with standard 1080p/1440p textures without this file."*
  - Class `DiskSpaceWarden`:
    - Calculates available bytes on the download root drive using `shutil.disk_usage()`.
    - Enforces safety margin: `available >= required_game_bytes + 15_GB`.

---

### Wave 2: Process-Aware Smart Gaming QoS & REST Routes
- **[NEW / ENHANCE] `backend/app.py` & `backend/game_engine.py`**:
  - Background process monitor thread checking every 3 seconds for active online games:
    - `cs2.exe`, `Valorant.exe`, `FortniteClient-Win64-Shipping.exe`, `r5apex.exe`, `Overwatch.exe`, `GTA5.exe`, `RainbowSix.exe`.
  - When game detected:
    - Scales global download throttle to 2 MB/s.
    - Limits swarm peer connections to 35.
    - Emits `gaming_mode: { active: true, game: "Valorant.exe", protected_ping: "18 ms" }` over the WebSocket.
  - When game terminates:
    - Restores previous profile limits (200 Mbps line saturation).
  - New REST API Endpoints:
    - `GET /api/torrents/{info_hash}/game-classification` -> returns structured components with guidance text.
    - `POST /api/torrents/{info_hash}/apply-game-preset` -> applies user-confirmed selective downloads.
    - `GET /api/system/game-mode` -> returns active gaming telemetry.
    - `POST /api/system/game-mode/toggle` -> user toggle for auto-throttling.

---

### Wave 3: Checksum Verifier & Post-Download Orchestration
- **[ENHANCE] `backend/game_engine.py`**:
  - Asynchronous background CRC32 and MD5 verifier against `.sfv` and `.md5` files:
    - Checks archive integrity without freezing the event loop.
    - Returns pass/fail status per archive.
  - Windows Post-Download Automation:
    - `POST /api/torrents/{info_hash}/mount-iso` -> PowerShell `Mount-DiskImage -ImagePath "..."`.
    - `POST /api/torrents/{info_hash}/launch-setup` -> Safely starts `setup.exe` in download root.

---

### Wave 4: Frontend UI Components
- **[MODIFY] `web/index.html`**:
  - Add `#game-advisor-modal` with guidance banners, file component breakdown, and explicit action buttons.
  - Add `#tab-game` to Inspector Drawer with installer actions, integrity status badge, and game breakdown stats.
  - Add `#hdr-game-mode` indicator in top header.
- **[MODIFY] `web/js/app.js`**:
  - Automatically detect repack candidates upon torrent load.
  - Open Game Advisor modal with informative guidance when optional components are present.
  - Wire interactive component checkboxes with dynamic savings calculation.
  - Wire Checksum verification button and ISO mounting.

---

### Wave 5: QA & Verification Gates
- **[NEW] `tests/test_game_engine.py`**:
  - Test classification of 10 real-world game repack directory structures (FitGirl, DODI, Steam backups).
  - Verify guidance message generation.
  - Verify disk space calculation and safety alerts.
  - Verify non-destructive default (all files remain selected until explicit user confirmation).
- **[MODIFY] `tests/verify_all_buttons_cdp.py`**:
  - Test Game Advisor modal interactions, Game Hub tab switching, Checksum verifier, and Gaming Mode status in real headless Chrome.
- **Regression Pass**:
  - Run `tests/benchmark_download_speed.py`.
  - Run `tests/security_penetration_audit.py`.

---

## 3. Verification Criteria
1. **Zero Silent Deselection**: In every test, newly added torrents start with 100% of files enabled (`priority = 1`).
2. **Clear Guidance**: Every optional file displays the guidance statement: *"Yes, the game will run smoothly without this file."*
3. **Smart Gaming QoS**: Simulating `cs2.exe` execution causes the daemon to throttle to 2 MB/s within 3 seconds, and immediately return to unconstrained 200 Mbps when closed.
4. **100% Headless Chrome CDP Verification**: All buttons, checkboxes, and tabs pass with 0 errors.
