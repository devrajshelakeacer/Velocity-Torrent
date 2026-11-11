# VELOCITY — Interfaces and API Contracts

## 1. Core C++ Interfaces

### `ITorrentEngine` (`src/core/Interfaces.hpp`)
```cpp
#pragma once
#include <string>
#include <vector>
#include <memory>
#include "Types.hpp"

namespace velocity::core {

class ITorrentEngine {
public:
    virtual ~ITorrentEngine() = default;
    
    // Lifecycle
    virtual bool initialize(const EngineConfig& config) = 0;
    virtual void shutdown() = 0;
    virtual bool isRunning() const = 0;
    
    // Torrent Management
    virtual TorrentId addMagnet(const std::string& magnetUri, const std::string& savePath) = 0;
    virtual TorrentId addTorrentFile(const std::string& torrentFilePath, const std::string& savePath) = 0;
    virtual bool pauseTorrent(const TorrentId& id) = 0;
    virtual bool resumeTorrent(const TorrentId& id) = 0;
    virtual bool removeTorrent(const TorrentId& id, bool deleteFiles) = 0;
    virtual bool setTorrentPriority(const TorrentId& id, int fileIndex, FilePriority priority) = 0;
    
    // Telemetry & State
    virtual std::vector<TorrentSnapshot> getTorrentSnapshots() const = 0;
    virtual std::vector<PeerSnapshot> getPeerSnapshots(const TorrentId& id) const = 0;
    virtual SessionMetrics getSessionMetrics() const = 0;
    virtual V200Diagnostics getV200Diagnostics() const = 0;
    
    // V-FORCE & Performance
    virtual void setPerformanceProfile(PerformanceProfile profile) = 0;
    virtual PerformanceProfile getPerformanceProfile() const = 0;
    
    // Security & Network Lock
    virtual void setNetworkLockInterface(const std::string& adapterGuid) = 0;
    virtual bool isNetworkLockEngaged() const = 0;
};

} // namespace velocity::core
```

### `ISecuritySanitizer` (`src/security/ISecuritySanitizer.hpp`)
```cpp
#pragma once
#include <string>
#include <filesystem>

namespace velocity::security {

enum class SanitizeResult {
    Safe,
    Sanitized,
    RejectedPathTraversal,
    RejectedReservedName,
    RejectedAlternateDataStream
};

struct SanitizedPathResult {
    SanitizeResult status;
    std::filesystem::path safePath;
    std::string originalPath;
    std::string reason;
};

class ISecuritySanitizer {
public:
    virtual ~ISecuritySanitizer() = default;
    virtual SanitizedPathResult sanitizePath(const std::filesystem::path& downloadRoot, 
                                             const std::string& rawRelativePath) const = 0;
    virtual bool isSafeFilename(const std::string& filename) const = 0;
};

} // namespace velocity::security
```

### `IThermalProvider` (`src/hardware/IThermalProvider.hpp`)
```cpp
#pragma once

namespace velocity::hardware {

struct ThermalSample {
    float temperatureCelsius;
    bool isThrottling;
    bool isSensorAvailable;
    std::string sensorName;
};

class IThermalProvider {
public:
    virtual ~IThermalProvider() = default;
    virtual ThermalSample queryThermalState() = 0;
};

} // namespace velocity::hardware
```

---

## 2. Qt / QML ViewModels & Property Bindings

### `TorrentListModel` (`src/models/TorrentListModel.hpp`)
Exposes a `QAbstractListModel` with roles:
- `IdRole`: `QString`
- `NameRole`: `QString`
- `ProgressRole`: `qreal` (0.0 to 1.0)
- `DownloadRateRole`: `qint64` (bytes/sec)
- `UploadRateRole`: `qint64` (bytes/sec)
- `TotalBytesRole`: `qint64`
- `DownloadedBytesRole`: `qint64`
- `EtaSecondsRole`: `qint64`
- `SeedsRole`: `int`
- `PeersRole`: `int`
- `StatusRole`: `QString` ("Downloading", "Seeding", "Paused", "Checking", "Error")
- `PusScoreRole`: `int` (Average peer utility score)

### `DashboardViewModel` (`src/models/DashboardViewModel.hpp`)
Exposes `Q_PROPERTY` attributes:
- `downloadSpeedMBs`: `qreal`
- `uploadSpeedMBs`: `qreal`
- `lineEfficiencyPct`: `qreal` (e.g. 93.6%)
- `swarmHealthPct`: `qreal`
- `activeTorrentCount`: `int`
- `connectedPeerCount`: `int`
- `cpuTemperature`: `qreal`
- `thermalStatus`: `QString` ("Normal", "Elevated", "Throttled")
- `activeProfile`: `QString` ("Balanced", "Turbo", "V-Force Max")
- `primaryBottleneck`: `QString` ("None", "Swarm Capacity", "Network RTT", "Disk Write", "CPU Hash")
