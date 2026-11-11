// SPDX-License-Identifier: GPL-3.0-or-later
#include "engine/PeerScorer.hpp"
#include <cassert>
#include <iostream>

void runPeerScorerTests() {
    std::cout << "[TEST] Running VSE-X PeerScorer Test Suite...\n";
    velocity::engine::PeerScorer scorer;

    // Test 1: Ideal High-Speed Peer
    {
        // 25 MB/s, 20ms RTT, 100% piece availability, 0 choke volatility, 0 bad pieces
        int pus = scorer.calculatePus(25000000LL, 20, 1.0, 0.0, 0);
        assert(pus >= 84 && pus <= 100);
        std::cout << "  ✓ Test 1 Passed: Ideal high-speed peer scored high PUS (" << pus << "/100).\n";
    }

    // Test 2: Low-Latency High-Bandwidth BDP Queue Sizing
    {
        // 20 MB/s, 40ms RTT
        int q = scorer.calculateQueueDepth(20000000LL, 40, 16384);
        assert(q >= 45 && q <= 55);
        std::cout << "  ✓ Test 2 Passed: BDP queue depth dynamically sized to " << q << " blocks.\n";
    }

    // Test 3: Lagging Slow Peer BDP Queue Clamped
    {
        // 100 KB/s, 300ms RTT
        int q = scorer.calculateQueueDepth(100000LL, 300, 16384);
        assert(q == 4); // Clamped to minimum safe boundary 4
        std::cout << "  ✓ Test 3 Passed: Slow peer clamped to minimum queue depth (4).\n";
    }

    // Test 4: Corrupted Peer Disqualification
    {
        // 3 bad pieces -> instant disqualification to 0 PUS
        int pus = scorer.calculatePus(25000000LL, 20, 1.0, 0.0, 3);
        assert(pus == 0);
        std::cout << "  ✓ Test 4 Passed: Malicious / bad piece peer disqualified (PUS = 0).\n";
    }

    std::cout << "[PASS] All VSE-X PeerScorer Tests Passed Cleanly.\n\n";
}
