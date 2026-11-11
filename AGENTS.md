# AGENTS.md — Velocity Engineering Operating Model

## Team Roles & Ownership Matrix
When operating on the VELOCITY codebase, tasks are divided among specialized engineering roles:

| Role | Primary Domain | Core File Ownership |
| :--- | :--- | :--- |
| **Lead Architect** | Overall architecture, API contracts, cross-module synchronization | `docs/*`, `CMakeLists.txt`, `src/core/Types.hpp` |
| **Torrent Engine Engineer** | libtorrent orchestration, BEP protocol adherence, session state | `src/engine/VSEEngine.*`, `src/engine/TorrentHandle.*` |
| **Network Engineer** | VSE-X scoring, request scheduling, socket binding, multi-interface | `src/network/*`, `src/engine/PeerScorer.*` |
| **Performance Engineer** | V200 pipeline, V-FORCE profiles, cache coalescing, Thermal Guardian | `src/engine/V200Pipeline.*`, `src/hardware/*` |
| **Security Engineer** | V-SHIELD, path sanitization, AMSI/Defender integration, network lock | `src/security/*`, `docs/SECURITY_MODEL.md` |
| **UI/UX Engineer** | QML scene graph, Geist design tokens, ViewModels, accessibility | `ui/*`, `src/ui/*`, `src/models/*`, `docs/design/*` |
| **QA Engineer** | Unit tests, mock swarms, security fuzzing, stress test harness | `tests/*`, `docs/TEST_PLAN.md` |
| **Release & DevOps Engineer**| CMake packaging, SBOM generation, license compliance, scripts | `scripts/*`, `LICENSE`, `README.md` |

## Strict AI Quality Rules
1. **Inspect before editing**: Always verify existing code, headers, and types before writing.
2. **Never invent APIs**: Use verified C++20 and libtorrent-rasterbar (v1.2/v2.0) API contracts.
3. **No destructive changes**: Never delete tests or skip assertions to mask defects.
4. **No fake or dummy UI controls**: Every button, slider, and metric in the UI connects to real data or real engine actions.
5. **Memory & Thread Safety**: All inter-thread communication between the engine thread and the Qt main/GUI thread must cross via thread-safe lock-free ring buffers or Qt queued signal-slot connections. Never manipulate libtorrent session handles directly from QML.
6. **Path Traversal Zero-Tolerance**: Any file path received from untrusted torrent metadata or user input must be sanitized and verified to reside inside the designated download root.

## Persistent Context Files
- Planning & Tasks: `docs/TASK_STATUS.md`
- Decisions Log: `docs/DECISIONS.md`
- Architecture: `docs/ARCHITECTURE.md`
- Handoff & Session State: `docs/HANDOFF.md`
