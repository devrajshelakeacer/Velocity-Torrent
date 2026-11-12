# GSD Explore — Next-Gen Large PC Game Engine Specialization

> **Goal**: Specialize VELOCITY as the definitive high-speed web torrent client for large PC games (50 GB – 150 GB+).  
> **Guiding Principle**: Zero data loss, zero automatic file exclusions without explicit user permission, and 100% corruption-free game delivery.

---

## 1. Socratic Inquiry & Trade-Off Analysis

### Q1: How should optional language and bonus files be handled without violating user autonomy?
* **Constraint**: The user gave a strict instruction:  
  > *"IMP NOTE - App should not remove any file from the torrent without any permission of the user, App must have to show the Guidence message like yes game will run smoothly without this file like language files if detected"*
* **Solution**:
  - All files default to `priority = 1` (Active / Normal Download). No file is ever removed, skipped, or modified silently.
  - When a torrent contains identified repack patterns (`selective-*.bin`, `optional-*.bin`, `language-*.bin`), the engine marks the torrent as a **"Game Repack Candidate"**.
  - The UI displays an informative **Optimization Guidance Card**:
    - Clearly explains the file's purpose: e.g. *"French Voice Pack (18.4 GB). If you only play in English, skipping this file will save 18.4 GB of bandwidth and ~7 minutes of download time. The game will run 100% smoothly in English without it."*
    - Provides two explicit actions: **[Keep All Files (Default)]** and **[Apply Recommended English Setup]**.
    - The user must explicitly click the action; without clicking, all files download normally.

---

### Q2: How to eliminate the 100 GB NTFS Disk Allocation Freeze?
* **Problem**: Allocating 100 GB in standard clients zero-fills the space, locking the disk for 5–15 minutes and causing high UI latency.
* **Technical Solution**:
  - Use `libtorrent`'s sparse allocation mode (`sparse_regions`) paired with Windows Win32 fast file allocation API (`SetFileValidData`).
  - Disk Space Pre-Flight Check:
    - Before allocating, calculate `game_size + 20 GB` (extraction margin).
    - If free space on the destination drive is insufficient, alert the user with exact numbers (`Free: 42 GB | Required: 98 GB`) before any bytes are requested from the swarm.

---

### Q3: How to prevent the dreaded `ISDone.dll` / `Unarc.dll` installer crashes?
* **Problem**: Repack installers (InnoSetup, FreeArc) decompress gigabytes of high-ratio archives. A single corrupted piece causes decompression failure after hours of waiting.
* **Technical Solution**:
  - **Strict Piece Hash Gate**: Pieces are only committed to disk once SHA-1 verification matches the torrent metadata bitfield.
  - **Automated Checksum Auditor**: If `.sfv`, `.md5`, `checksums.txt`, or `QuickSFV.ini` is present inside the torrent, VELOCITY automatically initiates an asynchronous post-download CRC32/MD5 hash verification pass.
  - If all files match, display: `✅ Verified 100% Authentic — Zero Bit Corruption (Safe to Install)`.

---

### Q4: How to achieve Smart Gaming QoS without degrading multiplayer ping?
* **Problem**: Downloading at 200 Mbps (~24 MB/s) exhausts router NAT buffers and causes bufferbloat, elevating multiplayer ping from 20 ms to 300+ ms.
* **Technical Solution**:
  - Background process sensor inspects running processes every 3 seconds for active games (`cs2.exe`, `Valorant.exe`, `FortniteClient-Win64-Shipping.exe`, `r5apex.exe`, etc.).
  - When gaming is detected:
    - Dynamically throttle download speed to a configurable background rate (e.g. 2 MB/s).
    - Reduce maximum concurrent swarm peer connections from 500 to 30.
    - Display header status pill: `🎮 Gaming Mode Active (Ping Guard Enabled)`.
  - When the game terminates, automatically restore full 200 Mbps line saturation.

---

### Q5: How to streamline Post-Download Setup?
* **Technical Solution**:
  - Detect output type upon 100% completion:
    - **ISO Image (`.iso`)**: Provide `⚡ Mount ISO Image` button using PowerShell `Mount-DiskImage`.
    - **Installer Executable (`setup.exe`)**: Provide `🎮 Launch Game Installer` button.
    - **Multi-Part Archive (`.part01.rar`, `.7z`)**: Provide `📦 Extract Game Files` action.

---

## 2. Decision Record
1. **Decision**: Never deselect or delete any torrent file automatically. Always require explicit user confirmation via an informative Guidance Card.
2. **Decision**: Implement lightweight process detection with zero third-party requirements (ctypes / tasklist fallback, with psutil enhancement).
3. **Decision**: Integrate automated CRC32/MD5 checksum verification for game archives.
4. **Decision**: Adhere strictly to the Vercel Geist design tokens for all new UI components.
