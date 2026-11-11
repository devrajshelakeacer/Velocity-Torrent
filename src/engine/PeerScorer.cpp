// SPDX-License-Identifier: GPL-3.0-or-later
#include "PeerScorer.hpp"
#include <cmath>

namespace velocity::engine {

int PeerScorer::calculatePus(int64_t downloadRateBps,
                             int rttMs,
                             double pieceAvailability,
                             double chokeVolatility,
                             int badPiecesCount,
                             int64_t targetRateBps) const {
    if (badPiecesCount > 2) {
        return 0; // Immediate disqualification for corrupted seeders
    }

    // Factor 1: Normalized Download Rate (0.0 to 1.0)
    double targetRate = targetRateBps > 0 ? static_cast<double>(targetRateBps) : 25000000.0;
    double rateScore = std::clamp(static_cast<double>(downloadRateBps) / targetRate, 0.0, 1.0);

    // Factor 2: Latency / RTT Score (0.0 to 1.0)
    int clampedRtt = std::clamp(rttMs, 0, 500);
    double rttScore = 1.0 - (static_cast<double>(clampedRtt) / 500.0);

    // Factor 3: Piece Availability (0.0 to 1.0)
    double availScore = std::clamp(pieceAvailability, 0.0, 1.0);

    // Factor 4: Choke Volatility Penalty (0.0 to 1.0)
    double chokePenalty = std::clamp(chokeVolatility, 0.0, 1.0);

    // Factor 5: Bad Piece Penalty
    double badPiecePenalty = static_cast<double>(badPiecesCount) * 0.40;

    // Weighted synthesis
    double rawScore = (0.40 * rateScore) +
                      (0.25 * rttScore) +
                      (0.20 * availScore) -
                      (0.15 * chokePenalty) -
                      badPiecePenalty;

    int finalScore = static_cast<int>(std::round(std::clamp(rawScore, 0.0, 1.0) * 100.0));
    return finalScore;
}

int PeerScorer::calculateQueueDepth(int64_t downloadRateBps,
                                   int rttMs,
                                   int blockSize) const {
    if (blockSize <= 0) blockSize = 16384;
    
    // BDP = (Throughput in bytes/sec) * (RTT in seconds)
    double rttSeconds = static_cast<double>(std::clamp(rttMs, 10, 2000)) / 1000.0;
    double bdpBytes = static_cast<double>(std::max<int64_t>(downloadRateBps, 65536)) * rttSeconds;

    int computedQueue = static_cast<int>(std::round(bdpBytes / static_cast<double>(blockSize)));

    // Clamp between 4 (minimum responsive pipeline) and 128 (maximum safe pipeline depth)
    return std::clamp(computedQueue, 4, 128);
}

void PeerScorer::rankPeers(std::vector<core::PeerSnapshot>& peers) const {
    std::sort(peers.begin(), peers.end(), [](const core::PeerSnapshot& a, const core::PeerSnapshot& b) {
        return a.pusScore > b.pusScore;
    });
}

std::vector<core::PeerSnapshot> PeerScorer::selectEndgamePeers(const std::vector<core::PeerSnapshot>& peers,
                                                              int minPusThreshold) const {
    std::vector<core::PeerSnapshot> candidates;
    for (const auto& peer : peers) {
        if (peer.pusScore >= minPusThreshold && !peer.isChoked) {
            candidates.push_back(peer);
        }
    }
    return candidates;
}

} // namespace velocity::engine
