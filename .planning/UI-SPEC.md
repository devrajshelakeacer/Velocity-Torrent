# UI Design Contract — VELOCITY Game Engine Hub & Advisor

> **Design System**: VELOCITY High-Contrast Dark Theme  
> **Target Audience**: PC Gamers downloading 50 GB – 150 GB+ releases  
> **Key Philosophy**: Complete transparency, non-destructive defaults, explicit guidance before action.

---

## 1. Color Palette & Typography Tokens

| Token | Hex Value | Usage |
| :--- | :--- | :--- |
| `--bg-canvas` | `#000000` | Deep pitch-black background |
| `--bg-surface` | `#0A0A0A` | Card & modal backgrounds |
| `--bg-surface-elevated`| `#141414` | Component rows, drawer panels |
| `--border-hairline` | `#1F1F1F` | Subtle structural dividers |
| `--border-card` | `#262626` | Card and modal borders |
| `--accent-blue` | `#0070F3` | Primary action buttons, active tabs |
| `--accent-green`| `#00E599` | 100% Integrity verification badge, download speed |
| `--accent-amber`| `#F5A623` | Storage space warning, optional file guidance callout |
| `--accent-purple`| `#7928CA` | Game Mode active badge, VSE-X intelligence |
| `--font-sans` | `'Inter', sans-serif` | General UI, buttons, headings |
| `--font-mono` | `'Geist Mono', Consolas`| File paths, hashes, sizes, telemetry numbers |

---

## 2. Core UI Components

### 2.1 Game Component Advisor & Guidance Modal (`#game-advisor-modal`)
* **Trigger**: Automatically surfaced when a newly added torrent contains recognized repack tokens (`selective-*.bin`, `optional-*.bin`, `language-*.bin`).
* **Design & Layout**:
  - Width: `640px`, backdrop blur `8px`.
  - **Header**:
    - Title: `🎮 Game Component Optimization Advisor`
    - Subtitle: `Optional voiceovers and bonus assets detected. VELOCITY never removes files automatically.`
  - **Guidance Banner** (Amber subtly tinted card):
    - Icon: `💡`
    - Text: *"Yes, this game will run completely smoothly in English without non-English voice packs or 4K bonus clips. You can choose which components to download below."*
  - **Interactive Component Table**:
    - Columns: `Component Name`, `Type`, `Size`, `Action`.
    - Types: `Required Base Game`, `Optional Language`, `Optional 4K Textures`, `Installer / Setup`.
    - Checkboxes bound to file priorities (`0` = Excluded, `1` = Included). All default to **CHECKED** unless the user applies the preset.
  - **Dynamic Savings Footer**:
    - Left: `Selected: 54.2 GB / 88.0 GB · Saves 33.8 GB bandwidth (~7 min download time)`
    - Right:
      - `[Download All Files (Default)]` (Secondary button)
      - `[Apply Recommended English Setup]` (Primary button)

---

### 2.2 Deep Inspector "Game Hub" Tab (`#tab-game`)
* **Added to**: Existing Inspector Drawer alongside `Files`, `Trackers`, `Peers`, `Info`.
* **Sub-Components**:
  1. **Game Metadata & Size Breakdown**:
     - Visual breakdown bar: Base Game (Green) vs Languages (Amber) vs Textures (Blue).
  2. **Installer & Executable Card**:
     - Displays detected executable (`setup.exe`, `autorun.inf`, `launcher.exe`).
     - Sequential prioritization toggle: `⚡ Prioritize Installer & First Data Archive`.
  3. **Integrity & Checksum Card**:
     - Status badge:
       - `Waiting for download...` (Muted)
       - `🔄 Verifying MD5/SFV archive integrity...` (Spinning amber)
       - `✅ 100% Verified Authentic — Zero Bit Corruption (Anti-ISDone.dll Armor)` (Bright green)
  4. **Post-Download Automation Bar**:
     - `⚡ Mount ISO Image` (Powershell integration)
     - `🎮 Launch Game Setup` (Native launcher with confirmation)
     - `📦 Extract Multi-Part Archive`

---

### 2.3 Smart Gaming Mode Header Indicator (`#hdr-game-mode`)
* **Location**: Top navigation header next to Profile Pill.
* **States**:
  - **Idle**: `🎮 Gaming Mode: Auto (Idle)` (Opacity 0.6)
  - **Active**: `🎮 Valorant Detected · Ping Guard Active (↓ 2 MB/s · 18 ms)` (Pulsing green dot)
* **Popover Controls**:
  - Toggle: `Enable Auto-Throttling during Online Gaming` (Enabled by default).
  - Background speed slider (Default: 2 MB/s).
  - Process monitor list with add custom `.exe` capability.

---

### 2.4 Pre-Allocation Disk Space Guard (`#disk-guard-banner`)
* **Location**: Top of Dashboard table when disk free space is tight (< 20 GB extra).
* **Alert Design**:
  - Border: Amber `#F5A623`.
  - Message: `⚠️ Storage Notice: Drive D:\ has 62 GB free space. This game requires 58 GB download + 20 GB temporary install space. Free up space to prevent installation failure.`
