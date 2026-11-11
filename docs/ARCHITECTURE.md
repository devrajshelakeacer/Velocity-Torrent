# VELOCITY — System Architecture & Threading Model

## 1. High-Level Architectural Layers

VELOCITY is architected into four decoupled layers adhering to Clean Architecture principles:

```
+-------------------------------------------------------------------------+
|                        Presentation Layer (QML)                         |
|   12 Production Views  |  Geist Design System  |  Hardware Accelerated  |
+-------------------------------------------------------------------------+
                                    |  Qt Property Bindings & Signals
+-------------------------------------------------------------------------+
|                       Application Layer (Qt C++)                        |
|   ViewModels (TorrentListModel, PeerModel)  |  ConfigManager  |  A11y   |
+-------------------------------------------------------------------------+
                                    |  Thread-Safe Dispatcher (Lock-Free)
+-------------------------------------------------------------------------+
|                       Domain Intelligence Layer                         |
|   VSE-X Engine  |  V200 Pipeline  |  V-FORCE  |  V-SHIELD  |  Guardian  |
+-------------------------------------------------------------------------+
                                    |  Abstract Interfaces (ITorrentEngine)
+-------------------------------------------------------------------------+
|                    Infrastructure & Engine Layer                        |
|   libtorrent-rasterbar  |  Winsock2  |  SQLite3  |  Win32 Security/WMI  |
+-------------------------------------------------------------------------+
```

---

## 2. Threading Model & Synchronization Guarantees

VELOCITY enforces strict thread isolation to ensure a persistent 60 FPS GUI:

1. **Main GUI Thread (Qt Event Loop)**:
   - Owns all QML components, scene graph rendering, user input handling, and ViewModels.
   - **Zero blocking operations**: never touches disk I/O, network sockets, cryptographic hashing, or database transactions.
2. **Engine Alert Thread (libtorrent Worker)**:
   - Manages asynchronous network sockets, packet parsing, DHT/tracker queries, and peer handshakes.
   - Drains alerts via `lt::session::pop_alerts()` into a high-capacity lockless ring buffer.
3. **Dispatcher & Aggregation Thread**:
   - Batches high-frequency telemetry alerts into 100ms ticks.
   - Emits immutable snapshot structures (`TorrentSnapshot`, `PeerSnapshot`) across the thread boundary to Qt models via `QMetaObject::invokeMethod(..., Qt::QueuedConnection)`.
4. **Asynchronous Disk & Hash Worker Pool**:
   - Executes multi-core SHA-1 / SHA-256 piece integrity validation.
   - Coalesces memory write blocks into contiguous disk commits.
   - Thread pool concurrency is bounded dynamically according to the active V-FORCE profile.

---

## 3. Data Flow & Memory Lifecycle

- **Immutability across boundaries**: When transferring telemetry from the engine to the UI, data is copied into flat, lightweight POD structs (`TorrentStateDTO`). The GUI never holds raw pointers into `libtorrent` internal objects.
- **Bounded Buffering**: Telemetry ring buffers are pre-allocated with fixed capacity (e.g. 1024 entries), discarding transient dropped alerts if saturated rather than allocating unbounded heap memory.
- **SQLite Transactions**: Database writes for fast-resume data and download receipts are executed inside worker-thread transactions using SQLite WAL mode, preventing database file locks from freezing application operations.
