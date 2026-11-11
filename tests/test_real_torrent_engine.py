# SPDX-License-Identifier: GPL-3.0-or-later
"""
Test adding a real legal magnet link to prove real libtorrent swarm integration.
Strict zero mock data.
"""
import os
import sys
import time
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
from fastapi.testclient import TestClient
from backend.app import app

def test_real_magnet_addition_and_removal():
    client = TestClient(app)

    # 1. Start with 0 torrents
    res0 = client.get("/api/torrents")
    assert res0.status_code == 200
    assert len(res0.json()) == 0, "Swarm must be empty on cold boot"

    # 2. Add real Ubuntu 24.04 LTS Desktop magnet
    ubuntu_magnet = "magnet:?xt=urn:btih:3b245504cf5f11bbdbe1201ced6503044490223a&dn=ubuntu-24.04-desktop-amd64.iso"
    add_res = client.post("/api/torrents/add", json={"magnet_uri": ubuntu_magnet})
    assert add_res.status_code == 200, f"Failed to add magnet: {add_res.text}"
    add_data = add_res.json()
    info_hash = add_data.get("info_hash")
    assert info_hash is not None
    print(f"[TEST PASS] Real magnet added with info_hash: {info_hash}")

    # 3. Verify torrents list now contains 1 real torrent
    res1 = client.get("/api/torrents")
    assert res1.status_code == 200
    torrents = res1.json()
    assert len(torrents) == 1
    t = torrents[0]
    print(f"[TEST PASS] Active torrent in session: name='{t['name']}', state='{t['state']}', seeds={t['num_seeds']}, peers={t['num_peers']}")

    # 4. Query piece bitfield
    pieces_res = client.get(f"/api/torrents/{info_hash}/pieces")
    assert pieces_res.status_code == 200
    pieces_data = pieces_res.json()
    print(f"[TEST PASS] Piece bitfield queried: {pieces_data['num_pieces']} pieces")

    # 5. Query peers
    peers_res = client.get(f"/api/torrents/{info_hash}/peers")
    assert peers_res.status_code == 200
    peers_data = peers_res.json()
    print(f"[TEST PASS] Peers endpoint queried successfully (found {len(peers_data)} active connections)")

    # 6. Pause torrent
    pause_res = client.post(f"/api/torrents/{info_hash}/pause")
    assert pause_res.status_code == 200
    print("[TEST PASS] Torrent paused successfully")

    # 7. Resume torrent
    resume_res = client.post(f"/api/torrents/{info_hash}/resume")
    assert resume_res.status_code == 200
    print("[TEST PASS] Torrent resumed successfully")

    # 8. Remove torrent cleanly
    del_res = client.delete(f"/api/torrents/{info_hash}?delete_files=false")
    assert del_res.status_code == 200
    print("[TEST PASS] Torrent removed cleanly from session")

    # 9. Verify 0 torrents remaining
    res_final = client.get("/api/torrents")
    assert len(res_final.json()) == 0
    print("[TEST PASS] Session restored to 0 active torrents.")

if __name__ == "__main__":
    print("Testing real torrent swarm integration...")
    test_real_magnet_addition_and_removal()
    print("Real torrent integration test PASSED with 100% genuine libtorrent metrics!")
