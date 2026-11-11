# VELOCITY — Performance Benchmark Specification

## 1. Objective & Line Saturation Baseline
The primary objective of the V200 engine is efficient utilization of a 200 Mbps broadband connection:
- **Nominal Line Speed**: $200\text{ Mbps} = 25,000,000\text{ bytes/sec} \approx 23.84\text{ MiB/s}$.
- **Target Sustained Goodput**: $\mathbf{22.0\text{–}24.0\text{ MB/s}}$ under optimal swarm conditions.
- **Protocol Overhead Allocation**:
  - IP/TCP headers: $\sim 2.5\%$
  - uTP/LEDBAT framing: $\sim 1.0\%$
  - BitTorrent block protocol framing: $\sim 1.5\%$
  - Tracker/DHT traffic: $\sim 0.5\%$
  - Total expected overhead: $5.5\% \rightarrow \text{Net payload max} \approx 23.6\text{ MB/s}$.

---

## 2. Benchmark Testbed Topology

```
+-------------------------------------------------------------+
|                      BENCHMARK TESTBED                      |
|                                                             |
|  [Seeder Node 1]      [Seeder Node 2]      [Seeder Node 3]  |
|   (100 Mbps Cap)       (100 Mbps Cap)       (100 Mbps Cap)  |
|          \                   |                   /          |
|           +------------------+------------------+           |
|                              |                              |
|                      [Gigabit Switch]                       |
|                              |                              |
|                      [VELOCITY Client]                      |
|                 (200 Mbps Simulated Ingress)                |
+-------------------------------------------------------------+
```

### Standard Benchmark Payload
- **Size**: 10.0 GiB (10,737,418,240 bytes)
- **Piece Size**: 4 MiB (2,560 pieces total)
- **Content**: 4 large continuous video files ($2\text{ GiB}$ each) and 2,000 small files ($1\text{ MiB}$ each) to evaluate both sequential and fragmented file write efficiency.

---

## 3. Measured Key Performance Indicators (KPIs)

| KPI Parameter | Unit | Target Threshold | V-FORCE Profile |
| :--- | :--- | :--- | :--- |
| **Sustained Download Rate** | MB/s | $\ge 22.0\text{ MB/s}$ | V-FORCE MAX / TURBO |
| **Time to Saturated Speed** | Seconds | $< 8\text{ seconds}$ from start | VSE-X BDP Scheduler |
| **Average CPU Utilization** | Percent | $< 15\%$ on modern 6-core CPU | Vectorized AVX2 hashing |
| **RAM Footprint (RSS)** | Megabytes | $< 350\text{ MB}$ (Balanced), $< 850\text{ MB}$ (Turbo) | Bounded memory cache |
| **Disk Write Amplification**| Ratio | $< 1.10$ | Direct Piece Coalescing Cache |
| **GUI Scene Graph Rate** | FPS | Steady $60.0\text{ FPS}$ | Decoupled UI worker thread |
| **Thermal Delta** | °C | Elevated warning (80°C-94°C) with zero speed drop | User-Controlled Guardian |
