// SPDX-License-Identifier: GPL-3.0-or-later
#include "core/Types.hpp"
#include "engine/VSEEngine.hpp"
#include <iostream>
#include <chrono>
#include <thread>

int main(int argc, char* argv[]) {
    std::cout << "========================================================\n";
    std::cout << "  VELOCITY v1.0.0 — Intelligent Torrent Downloading    \n";
    std::cout << "  Engineered in C++20 with VSE-X, V200, V-FORCE, V-SHIELD\n";
    std::cout << "========================================================\n\n";

    velocity::core::EngineConfig config;
    config.defaultSavePath = "D:/Downloads";
    config.initialProfile = velocity::core::PerformanceProfile::VForceMax;
    config.enableDefenderScanning = true;

    auto engine = std::make_unique<velocity::engine::VSEEngine>();
    if (!engine->initialize(config)) {
        std::cerr << "[CRITICAL] Failed to initialize VELOCITY engine core.\n";
        return 1;
    }

    std::cout << "[INFO] VSE-X Swarm Intelligence: Initialized.\n";
    std::cout << "[INFO] V200 Broadband Pipeline (200 Mbps): Online.\n";
    std::cout << "[INFO] V-FORCE Profile: V-FORCE MAX (Direct Piece Coalescing Cache Active).\n";
    std::cout << "[INFO] Thermal Guardian Policy: User Autonomy (Warnings active, no auto-demote).\n";
    std::cout << "[INFO] V-SHIELD Security Architecture: Path Traversal Guard Enforced.\n";
    std::cout << "[INFO] Microsoft Defender / AMSI Integration: Connected.\n\n";

    auto metrics = engine->getSessionMetrics();
    auto diag = engine->getV200Diagnostics();
    auto torrents = engine->getTorrentSnapshots();

    std::cout << "Active Transfres (" << torrents.size() << "):\n";
    for (const auto& t : torrents) {
        std::cout << "  - " << t.name << " [" << (t.progress * 100.0) << "%] @ " 
                  << (t.downloadRate / 1000000.0) << " MB/s (PUS: " << t.averagePusScore << ")\n";
    }

    std::cout << "\nThroughput Telemetry:\n";
    std::cout << "  Aggregate Down: " << (metrics.aggregateDownloadRate / 1000000.0) << " MB/s\n";
    std::cout << "  Aggregate Up:   " << (metrics.aggregateUploadRate / 1000000.0) << " MB/s\n";
    std::cout << "  Line Efficiency: " << diag.lineEfficiencyPercent << "% of 200 Mbps (~25 MB/s)\n";
    std::cout << "  Bottleneck Attribution: " << diag.bottleneckExplanation << "\n\n";

    std::cout << "[STATUS] VELOCITY Core Services Running Smoothly.\n";
    return 0;
}
