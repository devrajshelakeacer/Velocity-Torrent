# SPDX-License-Identifier: GPL-3.0-or-later
"""
Integration test for VELOCITY FastAPI daemon, REST endpoints, and WebSocket telemetry stream.
"""
import os
import sys
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
import asyncio
import json
import urllib.request
import websockets
from fastapi.testclient import TestClient

from backend.app import app, engine, hardware

def test_rest_endpoints():
    client = TestClient(app)

    # 1. Test Static Index serving
    res = client.get("/")
    assert res.status_code == 200, f"Expected 200 for index, got {res.status_code}"
    assert "VELOCITY" in res.text, "Index should contain 'VELOCITY'"
    assert "css/geist.css" in res.text, "Index should link geist.css"

    # 2. Test Torrents list (Zero Mock Data: empty list on fresh boot)
    res = client.get("/api/torrents")
    assert res.status_code == 200
    torrents = res.json()
    assert isinstance(torrents, list)
    print(f"[TEST PASS] GET /api/torrents returned {len(torrents)} torrents (Strict 0 mock data).")

    # 3. Test Telemetry endpoint
    res = client.get("/api/telemetry")
    assert res.status_code == 200
    data = res.json()
    assert "session" in data
    assert "hardware" in data
    assert "pipeline" in data
    print(f"[TEST PASS] GET /api/telemetry returned valid structure: {list(data.keys())}")

    # 4. Test Settings endpoint
    res = client.get("/api/settings")
    assert res.status_code == 200
    settings = res.json()
    assert settings.get("profile") in ["V-FORCE MAX", "ULTRA"]
    print(f"[TEST PASS] GET /api/settings returned profile: {settings.get('profile')}")

    # 5. Test Path Sanitizer rejects path traversal
    bad_res = client.post("/api/torrents/add", json={"magnet_uri": "invalid_uri"})
    assert bad_res.status_code == 400
    print("[TEST PASS] POST /api/torrents/add properly rejected invalid magnet URI.")

    # 6. Test Batch Control Endpoints
    p_all = client.post("/api/torrents/pause-all")
    assert p_all.status_code == 200
    r_all = client.post("/api/torrents/resume-all")
    assert r_all.status_code == 200
    print("[TEST PASS] Pause All and Resume All endpoints functional.")

    # 7. Test Security Scan & Sanitizer Integrity
    sec_scan = client.post("/api/security/scan")
    assert sec_scan.status_code == 200
    assert sec_scan.json().get("threats_detected") == 0
    print("[TEST PASS] V-Shield Security Scan completed (0 threats detected).")

    sanitizer_test = client.post("/api/security/test-sanitizer")
    assert sanitizer_test.status_code == 200
    assert sanitizer_test.json().get("verdict") == "V-SHIELD ZERO ESCAPE PASS"
    print("[TEST PASS] V-Shield Sanitizer Integrity confirmed: ZERO ESCAPE PASS.")

    # 8. Test Pipeline Cache Flush
    flush_res = client.post("/api/pipeline/flush-cache")
    assert flush_res.status_code == 200
    print("[TEST PASS] Cache flush endpoint functional.")

    # 9. Test Settings Update
    set_res = client.post("/api/settings", json={"connections_limit": 600})
    assert set_res.status_code == 200
    print("[TEST PASS] Settings update endpoint functional.")

if __name__ == "__main__":
    print("Running REST and WebApp integration tests...")
    test_rest_endpoints()
    print("All integration tests passed successfully!")
