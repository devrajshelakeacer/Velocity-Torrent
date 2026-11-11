# VELOCITY — Comprehensive Test Plan

## 1. Test Architecture

The VELOCITY test framework is organized into three distinct tiers:
1. **Unit Tests (`tests/unit/`)**: Fast, isolated C++20 tests linking against GoogleTest (`gtest_main`).
2. **Integration Tests (`tests/integration/`)**: Offline loopback tests using `MockSwarm` fixtures to simulate BitTorrent peers.
3. **Security Fuzzing (`tests/security/`)**: libFuzzer and sanitization suites testing edge-case inputs and malicious payloads.

---

## 2. Test Suite Matrix

### A. Unit Tests (`tests/unit/`)
| Test File | Target Module | Scope & Invariants |
| :--- | :--- | :--- |
| `Test_VShieldSanitizer.cpp` | `VShieldSanitizer` | Path traversal (`..`), ADS colons (`:`), reserved names (`CON`, `NUL`), boundary containment |
| `Test_PeerScorer.cpp` | `PeerScorer` | PUS score calculations, RTT damping, availability weights, bad piece penalty |
| `Test_V200Pipeline.cpp` | `V200Pipeline`, `BottleneckAttributor` | Window size calculation, rate estimation, 5-layer bottleneck classification |
| `Test_VForceController.cpp` | `VForceController`, `ThermalGuardian` | Profile switching, memory cache caps, user-controlled thermal warning states |
| `Test_BencodeGuard.cpp` | `BencodeGuard` | Nesting depth limit (64), file size limit, malformed dictionary handling |

### B. Integration Tests (`tests/integration/`)
| Test File | Description | Execution Environment |
| :--- | :--- | :--- |
| `Test_DownloadPipeline.cpp` | Complete download of test payload from mock seeder; verifies bitfield completion | Local loopback mock peer |
| `Test_PiecePicker.cpp` | Rarest-first vs sequential file priority verification | Simulated multi-peer swarm |
| `Test_NetworkLock.cpp` | Simulates adapter disconnect; verifies socket freeze and zero byte leakage | Virtual adapter state mock |

### C. Security & Stress Tests (`tests/security/`, `tests/stress/`)
| Test File | Purpose | Success Criteria |
| :--- | :--- | :--- |
| `FuzzBencode.cpp` | Mutates `.torrent` binaries using libFuzzer | Zero memory corruption or crashes over 100k cycles |
| `StressHarness.cpp` | 50 concurrent downloads over 2 hours | Flat RSS memory curve, zero handle leak |

---

## 3. Automated Verification Execution
To run the automated test suite via CMake and CTest:
```bash
cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Debug -DBUILD_TESTING=ON
cmake --build build
ctest --test-dir build --output-on-failure
```
