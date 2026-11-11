# VELOCITY — Task Status Tracker

## Phase 1: Foundation (COMPLETED)
- [x] Environment inspection and toolchain discovery.
- [x] 75-Question Engineering Examination completed (`docs/ENGINEERING_QA.md`).
- [x] 28-Risk Register completed (`docs/RISK_REGISTER.md`).
- [x] Visual research and Vercel Geist design tokens completed (`docs/design/*`).
- [x] System architecture, interfaces, and ADRs completed (`docs/*`).
- [x] Open-source governance files generated (`LICENSE`, `README.md`, `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `SECURITY.md`, `PRIVACY.md`, `CHANGELOG.md`, `CODEOWNERS`, `SECURITY_ADVISORIES.md`).
- [x] CMake build configuration (`CMakeLists.txt`) & folder tree initialized.

## Phase 2: Engine Implementation (COMPLETED)
- [x] Implemented `Types.hpp` & thread-safe `Dispatcher.hpp`.
- [x] Implemented `PeerScorer.hpp` & `.cpp` (VSE-X Swarm Intelligence & BDP queues).
- [x] Implemented `V200Pipeline.hpp` & `.cpp` (200 Mbps Pipeline & 5-Layer Bottleneck Triage).
- [x] Implemented `ThermalGuardian.hpp` & `.cpp` (User-controlled thermal policy & Direct Piece Coalescing Cache).
- [x] Implemented `VForceController.hpp` & `.cpp` (Balanced, Turbo, V-FORCE MAX profiles).
- [x] Implemented `VShieldSanitizer.hpp` & `.cpp` (Path traversal guard, ADS stripper, reserved device names).
- [x] Implemented `NetworkInterfaceManager.hpp` & `.cpp` (Adapter discovery & Network Lock).
- [x] Implemented `VSEEngine.hpp` & `.cpp` (Primary orchestration engine).

## Phase 3: Product UI (Qt 6 / QML) (COMPLETED)
- [x] Implemented `GeistTheme.qml` (Reactive Dark/Light token system).
- [x] Implemented Geist reusable components (`GeistButton`, `GeistCard`, `GeistBadge`, `GeistProgressBar`, `GeistChart`, `GeistEmptyState`).
- [x] Implemented `Sidebar.qml` & master `MainWindow.qml`.
- [x] Implemented all 12 production views:
  1. `ui/views/DashboardView.qml`
  2. `ui/views/AllDownloadsView.qml`
  3. `ui/views/TorrentDetailsView.qml`
  4. `ui/views/PeerExplorerView.qml`
  5. `ui/views/NetworkMonitorView.qml`
  6. `ui/views/V200PerformanceView.qml`
  7. `ui/views/VForceCenterView.qml`
  8. `ui/views/VShieldSecurityView.qml`
  9. `ui/views/DownloadIntelligenceView.qml`
  10. `ui/views/SettingsView.qml`
  11. `ui/views/DownloadHistoryView.qml`
  12. `ui/views/AboutLicensesView.qml`
- [x] Implemented C++ ViewModels (`TorrentListModel`, `DashboardViewModel`).

## Phase 4: Final Testing, Verification & Release (COMPLETED)
- [x] Built test suites: `Test_VShieldSanitizer.cpp`, `Test_PeerScorer.cpp`, `Test_V200Pipeline.cpp`, `Test_VForceController.cpp`, `Test_Main.cpp`.
- [x] Executed automated verification runner `tests/test_runner.py`: 100% of test suites passed.
- [x] Verified user directive: Thermal Guardian preserves fast download velocity without auto-downgrade to Balanced at 85°C.
- [x] Generated machine-readable SPDX 2.3 SBOM at `docs/SBOM.json` via `scripts/generate_sbom.py`.
- [x] Generated Windows build and test scripts (`scripts/build_release.ps1`, `scripts/run_tests.ps1`).

## Phase 5: Local WebApp Architecture Migration (COMPLETED)
- [x] Converted desktop application to clone-and-run local webapp (`git clone && .\Launch-Velocity.bat`).
- [x] Vetted through 6-Engineer Council (Lead Architect, Network Engineer, Hardware Engineer, Cybersecurity Engineer, Daemon Architect, Vercel/Stripe Frontend Principal).
- [x] Purged all mock torrents and fake peers: 100% genuine libtorrent 2.1.1 engine metrics.
- [x] Created `backend/sanitizer.py` implementing `VShieldSanitizer` (NTFS ADS stripping, path canonicalization, Win32 device name defense).
- [x] Created `backend/telemetry.py` implementing `HardwareTelemetry` (WMI CPU temp, 5-layer bottleneck triage, line saturation).
- [x] Created `backend/engine.py` orchestrating real `libtorrent 2.1.1` session, 8 MiB socket buffers, VSE-X PUS scoring, and V-FORCE cache.
- [x] Created `backend/app.py` FastAPI asynchronous daemon with REST endpoints, 100ms WebSocket stream, and static hosting.
- [x] Created `web/css/geist.css` with Vercel Geist design tokens, Inter font, strict 12px minimum font size, and dark obsidian palette.
- [x] Created `web/js/components/charts.js` (60 FPS High-DPI Catmull-Rom cubic spline throughput visualizer).
- [x] Created `web/js/components/piece_map.js` (interactive piece heatmap for up to 20,000 blocks with hover inspection).
- [x] Created `web/js/app.js` master application state controller with WebSocket streaming and global drag-and-drop / Ctrl+V magnet detection.
- [x] Created `web/index.html` single-page application shell with all functional views (Dashboard, Swarms, Pieces, Pipeline, Security, Settings).
- [x] Automated clone-and-run launchers (`Launch-Velocity.bat`, `launch.sh`).
- [x] Passed all integration tests (`tests/test_webapp_integration.py` and `tests/test_real_torrent_engine.py`).

