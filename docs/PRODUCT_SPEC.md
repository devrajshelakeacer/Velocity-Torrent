# VELOCITY — Product Specification

## 1. Product Identity & Core Mission
- **Product Name**: VELOCITY
- **Tagline**: Intelligent Torrent Downloading
- **Target Platform**: Windows 10 (Build 19041+) and Windows 11 (64-bit architecture)
- **Primary Language**: C++20
- **UI Framework**: Qt 6 / QML (Direct3D 11/12 via Qt RHI)
- **Torrent Engine**: `libtorrent-rasterbar`
- **Build System**: CMake + Ninja
- **License**: GNU General Public License v3.0 or later (GPL-3.0-or-later)
- **Cost**: 100% Free, Zero Ads, Zero Subscriptions, Zero Mandatory Accounts

---

## 2. Target Performance Profile: 200 Mbps Broadband Optimization
- **Theoretical Maximum**: 200 Mbps $= 25.0$ MB/s.
- **Controlled Baseline Target**: $22.0\text{–}24.0$ MB/s sustained goodput under healthy swarm conditions.
- **Protocol Overhead Budget**: Approximately $4\text{–}6\%$ allocated to TCP/IP framing, uTP packet headers, BitTorrent message framing, and tracker announces.
- **Bottleneck Attribution Transparency**: VELOCITY never makes false promises of universal maximum speed. If external constraints (peer unchoke limits, ISP shaping, Wi-Fi interference, or disk latency) limit throughput, the V200 engine explicitly isolates and reports the exact constraining factor in real-time.

---

## 3. Subsystem Definitions
1. **VSE-X (Velocity Swarm Intelligence Engine)**:
   - Dynamic Peer Utility Scoring (PUS) combining throughput, RTT, availability, and piece reliability.
   - Bandwidth-Delay Product (BDP) based adaptive request scheduling.
   - Targeted Endgame request distribution to avoid redundant bandwidth waste.
2. **V200 (200 Mbps Pipeline Optimizer)**:
   - Zero-copy ring buffers and dynamic Winsock buffer tuning.
   - Real-time 5-layer Bottleneck Attribution Engine.
   - High-precision throughput telemetry stream.
3. **V-FORCE & Thermal Guardian**:
   - 3-tier resource allocation profiles: BALANCED, TURBO, and V-FORCE MAX.
   - Automated Thermal Guardian regulation: queries WMI thermal zones and steps down workload at $\ge 85^\circ\text{C}$.
   - Hardware safety guarantee: never modifies system voltages, clocks, or overrides firmware protections.
4. **V-SHIELD (Security Architecture)**:
   - Zero-tolerance path traversal and reparse point sanitization.
   - Native Microsoft Defender / AMSI malware scanning upon file completion.
   - Absolute zero automatic execution policy for completed downloads.
   - Adapter-bound Network Lock (Kill-Switch) preventing IP leaks.
5. **Download Intelligence**:
   - Swarm persistence forecasting, ISP throttle detection, and historical verification receipts.

---

## 4. User Personas & Core Workflows
1. **The Modern Power User**: Expects instant saturation of a 200 Mbps fiber/cable connection, deep telemetry into peer dynamics, and zero bloatware or background crypto-mining.
2. **The Security-Conscious User**: Requires guaranteed protection against malicious `.torrent` files, path traversal exploits, unexpected IP leakage on VPN disconnects, and automatic scanning of downloaded files.
3. **The Laptop / Resource-Constrained User**: Needs an application that respects battery life, avoids excessive RAM usage, preserves SSD endurance, and prevents fans from screaming via the Thermal Guardian.
