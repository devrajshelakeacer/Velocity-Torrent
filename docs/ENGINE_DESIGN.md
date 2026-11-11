# VELOCITY — Engine Design Specification

## 1. VSE-X: Velocity Swarm Intelligence Engine

### A. Peer Utility Scoring (PUS) Algorithm
Every connected peer is evaluated on a continuous 2-second cycle:
$$\text{PUS} = w_1 \cdot \hat{R}_{\text{dl}} + w_2 \cdot \left(1 - \frac{\min(\text{RTT}, 500)}{500}\right) + w_3 \cdot \text{Availability} - w_4 \cdot \text{ChokeVolatility} - w_5 \cdot \text{BadPieces}$$

- **Weights**:
  - $w_1 = 0.40$: Normalized useful download rate ($\hat{R}_{\text{dl}} = \min(R_{\text{dl}} / R_{\text{target}}, 1.0)$).
  - $w_2 = 0.25$: Round-Trip Time score (rewards low-latency peers; clamped to 500ms max).
  - $w_3 = 0.20$: Piece availability (percentage of unpossessed pieces this peer can supply).
  - $w_4 = 0.15$: Choke volatility penalty (frequent choking/unchoking shifts).
  - $w_5 = 1.00$: Immediate heavy penalty for any failed block/piece hash check.

### B. Adaptive Request Scheduling (BDP Queue Sizing)
The request queue depth $Q_i$ for peer $i$ is calculated dynamically:
$$Q_i = \text{clamp}\left(\frac{\text{Throughput}_i \cdot \text{RTT}_i}{\text{BlockSize}}, 4, 128\right)$$
- Block size is fixed at $16\text{ KiB}$ ($16,384\text{ bytes}$).
- Fast peers with high RTT receive deeper pipelines to avoid transit pipeline starvation.
- Slow or jittery peers are throttled to 4 outstanding requests to prevent head-of-line blocking.

### C. Targeted Endgame Pipeline
- Activates when remaining unrequested pieces $< 1.5\%$ of total torrent size.
- Clones outstanding block requests strictly to peers with $\text{PUS} \ge 80$.
- Emits immediate `CANCEL` packets to all other peers as soon as a valid block arrives.

---

## 2. V200: 200 Mbps Pipeline Optimizer

### A. Line Saturation Metrics
- **Theoretical Target**: $200\text{ Mbps} = 25,000,000\text{ B/s} \approx 23.84\text{ MiB/s}$.
- **Target Sustained**: $22.0\text{–}24.0\text{ MB/s}$.

### B. Real-Time Bottleneck Attribution Engine
The system measures 5 distinct pipeline layers every 500ms and attributes the primary bottleneck:
1. **Layer 1: Peer Upload Supply**:
   - Condition: Aggregate seeder capacity across all connected unchoked peers is $< 20\text{ MB/s}$.
   - Classification: `"SWARM_CAPACITY_CONSTRAINED"`
2. **Layer 2: Local Network Congestion**:
   - Condition: RTT delta increases $> 60\text{ms}$ above baseline; packet loss $> 2.0\%$.
   - Classification: `"NETWORK_BUFFERBLOAT_DETECTED"`
3. **Layer 3: Socket Buffer Backpressure**:
   - Condition: Winsock receive buffer is saturated ($> 90\%$ capacity).
   - Classification: `"WINSOCK_STACK_BACKPRESSURE"`
4. **Layer 4: CPU Cryptographic Verification**:
   - Condition: Hashing worker pool utilization is $\ge 95\%$; hash verification backlog grows.
   - Classification: `"CPU_HASH_VERIFICATION_BOUND"`
5. **Layer 5: Disk Write Pipeline**:
   - Condition: Memory write cache dirty page ratio $> 85\%$; disk write latency $> 20\text{ms}$.
   - Classification: `"DISK_STORAGE_BOTTLENECK"`
6. **Optimal State**:
   - Condition: Throughput $\ge 22.0\text{ MB/s}$ with balanced queue depths.
   - Classification: `"V200_LINE_SATURATED_OPTIMAL"`

---

## 3. V-FORCE & Thermal Guardian

### A. Resource Allocation Profiles
| Parameter | BALANCED | TURBO | V-FORCE MAX |
| :--- | :--- | :--- | :--- |
| **Max Disk Cache** | 128 MiB | 512 MiB | 1536 MiB (1.5 GiB) |
| **Max Global Connections** | 120 | 250 | 400 |
| **Max Connections / Torrent** | 40 | 80 | 120 |
| **Hashing Worker Cores** | 2 | 4 | Up to $\text{Hardware Concurrency} - 1$ |
| **Socket Receive Buffer** | 512 KiB | 1024 KiB | 2048 KiB |
| **Disk Write Coalescing** | 4 MiB sequential | 16 MiB sequential | 32 MiB sequential |

### B. Thermal Guardian Safety Controller (User-Controlled Policy)
- **Direct Piece Coalescing Cache**:
  - Incoming 16 KiB blocks are staged in RAM, assembled sequentially into contiguous 4 MiB–16 MiB chunks, and committed via zero-copy sequential disk writes.
  - Reduces SSD write amplification factor (WAF) by up to 90%, drastically lowering NAND flash wear (TBW), reducing fan noise, and preventing disk latency spikes.
- **Polling frequency**: 2 Hz via WMI (`MSAcpi_ThermalZoneTemperature`) and Windows Performance Counters.
- **Threshold Actions & User-First Policy**:
  - $T < 80^\circ\text{C}$: State `NORMAL`. All performance profiles (including V-FORCE MAX) operate unrestricted.
  - $80^\circ\text{C} \le T < 95^\circ\text{C}$: State `ELEVATED_WARNING`. **The application does NOT automatically downgrade the profile to BALANCED**. Fast downloading continues at full speed. A prominent Amber UI banner and status badge alert the user of elevated temperatures, giving the user manual control to step down if desired.
  - $T \ge 95^\circ\text{C}$: State `CRITICAL_PEAK_DANGER`. Emergency hardware protection warning is triggered. A high-priority Red alert warns the user that silicon/hardware peak safety limits are reached, with an audible prompt and recommended one-click action to protect the machine from thermal shutdown.
- **Hardware Safety Rule**: Software monitoring only; strictly zero manipulation of CPU voltages, clocks, or overriding of firmware-level thermal trip points.

---

## 4. V-SHIELD Security Architecture

### A. Path Sanitization Rules
1. Reject any path containing directory traversal tokens (`..`, `/..`, `\..`).
2. Strip absolute drive letters (`C:`, `D:`) and root slashes.
3. Reject NTFS Alternate Data Streams (paths containing `:`).
4. Replace illegal Win32 filesystem characters (`< > : " / \ | ? *`) with `_`.
5. Rename reserved Win32 device names (`CON`, `PRN`, `AUX`, `NUL`, `COM1-9`, `LPT1-9`) by prefixing `_`.
6. Enforce that canonical target path starts strictly with the designated download root directory.

### B. Microsoft Defender & Antivirus Hook
- Invoked upon 100% download completion and piece hash verification.
- Executes `MpCmdRun.exe -Scan -ScanType 3 -File "<path>"`.
- If threat reported: file is moved to quarantine directory with `.velocity_quarantine` extension.
- UI state displays: Scan Passed, Scan Unavailable, or Threat Detected.
