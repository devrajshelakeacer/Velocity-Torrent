// SPDX-License-Identifier: GPL-3.0-or-later
#pragma once

#include "core/Types.hpp"
#include <vector>
#include <algorithm>

namespace velocity::engine {

class PeerScorer {
public:
    PeerScorer() = default;

    // Calculates Peer Utility Score (0 to 100)
    int calculatePus(int64_t downloadRateBps,
                     int rttMs,
                     double pieceAvailability,
                     double chokeVolatility,
                     int badPiecesCount,
                     int64_t targetRateBps = 25000000) const;

    // Calculates Bandwidth-Delay Product (BDP) queue depth (4 to 128)
    int calculateQueueDepth(int64_t downloadRateBps,
                            int rttMs,
                            int blockSize = 16384) const;

    // Ranks peers by PUS score descending
    void rankPeers(std::vector<core::PeerSnapshot>& peers) const;

    // Filters top PUS peers eligible for targeted endgame requests
    std::vector<core::PeerSnapshot> selectEndgamePeers(const std::vector<core::PeerSnapshot>& peers,
                                                      int minPusThreshold = 75) const;
};

} // namespace velocity::engine
