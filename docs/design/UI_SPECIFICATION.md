# VELOCITY — UI Specification for 12 Core Views

This document defines the layout, data bindings, interactive controls, and visual states for all 12 production views in VELOCITY.

---

## Screen 1: Dashboard
- **Purpose**: Executive overview of download operations, aggregate throughput, swarm health, and thermal status.
- **Header**: Search bar, global pause/resume button, active V-FORCE profile pill, theme toggle.
- **Hero Metrics (3 Cards)**:
  1. *Total Throughput*: Real-time Download and Upload speeds in MB/s (Geist Mono 24px) with V200 line efficiency percentage.
  2. *Swarm Health*: Aggregate ratio of active seeders to leechers, average swarm availability, and active peer count.
  3. *Thermal Guardian*: Live CPU package temperature (°C), thermal policy state (`NORMAL`, `THROTTLED`), and system workload.
- **Active Transfers Section**: Top 3 active downloads with real-time speed, progress bar, ETA, and quick pause button.
- **Throughput Timeline Chart**: 60-second real-time graph displaying download rate (Cyan/Blue) and upload rate (Green) with 25 MB/s reference line.

---

## Screen 2: All Downloads
- **Purpose**: High-density management table for all torrent transfers (active, completed, queued, paused, seeding).
- **Toolbar**: Add Torrent button (`+ Add Torrent`), Paste Magnet link button, Filter pills (`All`, `Downloading`, `Seeding`, `Completed`, `Paused`), Search input.
- **Data Table Columns**:
  1. Status (GeistBadge with micro-dot)
  2. Name (Filename with file-type icon)
  3. Size (Total size formatted in MB/GB)
  4. Progress (Slim progress bar + percentage text)
  5. Down Speed (MB/s in Geist Mono)
  6. Up Speed (KB/s or MB/s in Geist Mono)
  7. ETA (Formatted time remaining `42s`, `5m 12s`)
  8. Seeds / Peers (Ratio, e.g. `48 (120)`)
  9. Actions (Pause, Resume, Delete, Open Folder)
- **Empty State**: Minimalist icon with "No active downloads" and a prominent "Add Magnet or Torrent" action.

---

## Screen 3: Torrent Details
- **Purpose**: In-depth inspection of a single selected torrent transfer.
- **Tabbed Hierarchy**:
  - **Files Tab**: Tree view of torrent files with individual file sizes, progress percentages, and priority selectors (High, Normal, Low, Skip).
  - **Trackers Tab**: List of announce URLs, protocol (UDP/HTTP/WSS), tier, status (Working, Updating, Error), seeders reported, next announce countdown.
  - **Pieces Tab**: High-resolution visual piece heatmap showing acquired pieces (White/Green), pending blocks (Amber), and missing pieces (Dark Gray).
  - **Integrity Log**: SHA-1 / SHA-256 info-hash verification results, verified piece count, bad blocks detected and discarded.

---

## Screen 4: Peer Explorer
- **Purpose**: Swarm intelligence visualization showing connected peers across all active swarms.
- **Data Table Columns**:
  1. IP & Port (IPv4 / IPv6 notation with country flag)
  2. Client Identifier (e.g. `qBittorrent 4.6.3`, `Transmission 4.0.5`)
  3. Connection Transport (`uTP / LEDBAT` or `TCP`)
  4. Encryption Status (RC4 / Plaintext icon)
  5. Down Rate & Up Rate (Real-time speed per peer)
  6. Peer Utility Score (PUS rating 0–100 calculated by VSE-X)
  7. Pieces Available (Percentage of torrent the peer possesses)
  8. Choke State (Unchoked, Choked, Interested)

---

## Screen 5: Network Monitor
- **Purpose**: System-level network topology, interface status, and socket diagnostics.
- **Interface Cards**: Displays each detected network adapter via Windows IP Helper (Ethernet, Wi-Fi, VPN):
  - Adapter name and MAC/GUID
  - IPv4 address, IPv6 address, subnet mask, default gateway
  - Link speed (e.g. `1000 Mbps Full Duplex`)
  - Active socket count bound to this adapter
- **Port Forwarding Status**: UPnP and NAT-PMP status indicators, external listening port (`6881`), NAT traversal health.
- **Routing & Buffer Diagnostics**: Winsock send/receive buffer allocations and MTU size.

---

## Screen 6: V200 Performance
- **Purpose**: Dedicated 200 Mbps broadband pipeline analyzer and bottleneck attribution engine.
- **Line Utilization Gauge**: High-precision circular or linear meter showing current speed relative to the 200 Mbps (~25 MB/s) ceiling.
- **Bottleneck Attribution Panel**: Real-time diagnostic breakdown identifying which subsystem is currently bounding performance:
  - *Swarm Seed Capacity*: Percentage of available seeder upload bandwidth utilized.
  - *Network Congestion / RTT*: One-way delay and bufferbloat metrics.
  - *Socket Stack Efficiency*: Winsock buffer fill percentage.
  - *CPU Verification*: Hashing thread utilization.
  - *Disk Storage Pipeline*: Write queue depth and write latency (ms).
- **Optimization Recommendations**: Plain-English actionable suggestions (e.g. "Swarm upload capacity is constrained; adding more trackers via DHT recommended").

---

## Screen 7: V-FORCE Control Center
- **Purpose**: Hardware-safe performance scaling and Thermal Guardian controller.
- **Profile Selector**:
  1. *BALANCED*: 128 MB cache, 2 hash threads, energy-efficient.
  2. *TURBO*: 512 MB cache, 4 hash threads, high request pipelining.
  3. *V-FORCE MAX*: 1.5 GB cache, full AVX2 hashing, maximum socket concurrency.
- **Thermal Guardian Live Telemetry**:
  - Live CPU Package Temperature (°C) with safety threshold line at 85°C.
  - Thermal policy status: `ACTIVE`, `MONITORING`, `THROTTLED`.
  - Auto-Stepdown Toggle: Automatically drops profile to Balanced if 85°C is reached.
- **Cache & Disk Metrics**: Dirty buffer size, write coalescing ratio, flush interval countdown.

---

## Screen 8: V-SHIELD Security Center
- **Purpose**: Security, sandbox integrity, malware defense, and privacy lock.
- **Security Posture Overview**: Overall shield rating with status chips:
  - Path Traversal Guard: `ACTIVE` (100% paths sanitized).
  - Microsoft Defender Integration: `CONNECTED` or `STANDBY`.
  - Network Lock (Kill-Switch): `ENGAGED` or `DISABLED`.
  - BitTorrent v2 Merkle Hash Integrity: `ENFORCED`.
- **Security Event Log**: Real-time log of security actions (e.g. `Blocked path traversal attempt in torrent metadata: ../../evil.dll -> sanitized to evil.dll`).
- **File Quarantine List**: Files identified as suspicious by Defender and safely isolated with `.velocity_quarantine`.

---

## Screen 9: Download Intelligence
- **Purpose**: Predictive analytics, swarm availability trends, and historical metrics.
- **Swarm Availability Projections**: Graph showing projected seed persistence over time based on historical swarm churn.
- **ISP Throttling Detector**: Heuristic analysis detecting whether your ISP is shaping or rate-limiting BitTorrent protocol traffic.
- **Lifetime Statistics**: Total data downloaded, total data uploaded, global share ratio, average throughput.

---

## Screen 10: Settings
- **Purpose**: Application configuration grouped into clean tabbed sections.
- **Sections**:
  1. *General*: Start with Windows, minimize to system tray, file associations (`.torrent`, `magnet:`).
  2. *Downloads*: Default download folder, incomplete torrents folder, pre-allocation mode.
  3. *Connection*: Listening port, UPnP/NAT-PMP toggles, proxy configuration (SOCKS5/HTTP with DPAPI encrypted credentials).
  4. *Bandwidth*: Global download/upload rate limits, alternative scheduler limits.
  5. *V-FORCE & Cache*: Default profile selection, custom cache override.
  6. *V-SHIELD*: Network Lock adapter binding, automatic Defender scan toggle, quarantine folder path.
  7. *Appearance*: Theme selector (Dark, Light, System), font size scaling.

---

## Screen 11: Download History
- **Purpose**: Searchable log of all completed transfers with verification receipts.
- **Features**:
  - Full-text search across completed torrent names.
  - Completion date and time stamps.
  - Cryptographic verification receipt (SHA-1 / SHA-256 hash stamp).
  - "Open Folder" and "Re-add to Swarm" actions.
  - Export history to CSV / JSON receipt.

---

## Screen 12: About & Open Source Licenses
- **Purpose**: Legal compliance, Software Bill of Materials (SBOM), and project identity.
- **Content**:
  - VELOCITY version (`v1.0.0-rc1`), build date, commit SHA.
  - License notice: GNU General Public License v3.0 or later (GPL-3.0-or-later).
  - Complete Third-Party SBOM Table:
    - `Qt 6.7` (LGPLv3 / GPLv3)
    - `libtorrent-rasterbar 2.0.10` (BSD-3-Clause)
    - `OpenSSL 3.3` (Apache-2.0)
    - `SQLite 3.45` (Public Domain)
    - `Geist Font Family` (SIL Open Font License 1.1)
  - Security vulnerability reporting link (`docs/SECURITY.md`).
  - GitHub repository link and contributor acknowledgments.
