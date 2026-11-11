# VELOCITY — Architecture Decision Records (ADRs)

## ADR-01: In-Process Multi-Threaded Model vs Multi-Process Daemon
- **Context**: Need high UI responsiveness (60 FPS) while processing 24 MB/s torrent I/O.
- **Decision**: In-process multi-threading using C++20 lock-free ring buffers and Qt queued connections.
- **Status**: Approved.
- **Consequences**: Avoids Windows named-pipe IPC serialization overhead and cuts memory consumption by ~60%; requires robust SEH crash minidump capture.

## ADR-02: libtorrent-rasterbar as Core BitTorrent Engine
- **Context**: Re-implementing BitTorrent v1/v2, DHT, PEX, uTP, and encryption from scratch would take years and risk obscure protocol bugs.
- **Decision**: Adopt battle-tested `libtorrent-rasterbar` and build our innovation layer (VSE-X, V200, V-FORCE, V-SHIELD, Download Intelligence) on top.
- **Status**: Approved.
- **Consequences**: Verified protocol compliance with high-speed performance; isolated behind `ITorrentEngine` interface.

## ADR-03: Vercel Geist Minimalist Design System
- **Context**: Existing BitTorrent desktop apps have cluttered, outdated Windows 7/XP visual aesthetics.
- **Decision**: Create a custom Geist-inspired QML component library featuring stark monochrome surfaces, 1px hairline borders, Geist typography, and micro-accents.
- **Status**: Approved.
- **Consequences**: World-class visual aesthetics and dense information hierarchy; requires custom QML components.

## ADR-04: SQLite 3 with Write-Ahead Logging (WAL) for State Persistence
- **Context**: Torrent resume data and settings require crash-resilient persistence.
- **Decision**: SQLite 3 with `journal_mode=WAL` and `synchronous=NORMAL`, coupled with a rolling `.bak` backup file.
- **Status**: Approved.
- **Consequences**: Total immunity against power loss corruption, instant read/write concurrency.

## ADR-05: Zero Telemetry & Privacy by Default
- **Context**: Global users demand trust and privacy in BitTorrent software.
- **Decision**: Collect zero telemetry, require zero accounts, and bundle zero third-party cloud analytics.
- **Status**: Approved.
- **Consequences**: Total user trust; application functions 100% offline.

## ADR-06: User-Controlled Thermal Policy & Direct Piece Coalescing Cache
- **Context**: 200+ Mbps downloads generate heavy random 16KB disk I/O and CPU hashing. Previously, the system contemplated an automatic downgrade to BALANCED at 85°C.
- **Decision**: 
  1. Implement **Direct Piece Coalescing Cache** (RAM staging assembling 16KB blocks into 4MB–16MB contiguous writes, slashing SSD WAF by up to 90% and preserving SSD TBW).
  2. Implement **User-Controlled Thermal Policy**: Do NOT automatically demote V-FORCE MAX to BALANCED at 85°C. Fast downloads must continue uninterrupted. Provide clear Amber UI warnings between 80°C and 94°C. Only at critical peak danger thresholds (>= 95°C) trigger high-priority emergency alerts, empowering the user to retain full control over performance profiles.
- **Status**: Approved (Explicit User Directive).
- **Consequences**: Maximizes sustained download throughput; empowers power users while providing clear visual safety telemetry.
