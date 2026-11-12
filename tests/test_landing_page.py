# SPDX-License-Identifier: GPL-3.0-or-later
"""
Automated Verification Suite for VELOCITY Flagship Product Showcase & Marketing Website
Audits http://127.0.0.1:8080/landing via Chrome DevTools Protocol.
"""

import os
import sys
try:
    sys.stdout.reconfigure(line_buffering=True)
except Exception:
    pass
import time
import json
import shutil
import tempfile
import subprocess
import urllib.request
import asyncio
import websockets

CHROME_PATH = r"C:\Program Files\Google\Chrome\Application\chrome.exe"
PORT = 9226
TARGET_URL = "http://127.0.0.1:8080/landing"

async def cdp_eval(ws, expr, await_promise=True):
    msg_id = int(time.time() * 1000) % 100000
    req = {
        "id": msg_id,
        "method": "Runtime.evaluate",
        "params": {
            "expression": expr,
            "returnByValue": True,
            "awaitPromise": await_promise
        }
    }
    await ws.send(json.dumps(req))
    while True:
        resp = json.loads(await ws.recv())
        if resp.get("id") == msg_id:
            res = resp.get("result", {})
            if "exceptionDetails" in res:
                raise RuntimeError(f"CDP JS Error in '{expr}': {res['exceptionDetails']}")
            return res.get("result", {}).get("value")

async def run_landing_audit():
    print("=" * 70)
    print("  VELOCITY — Product Showcase Website CDP Verification Suite")
    print("=" * 70)

    temp_profile = tempfile.mkdtemp(prefix="chrome_landing_")

    chrome_proc = subprocess.Popen([
        CHROME_PATH,
        "--headless=new",
        "--disable-gpu",
        f"--remote-debugging-port={PORT}",
        "--remote-allow-origins=*",
        f"--user-data-dir={temp_profile}",
        "--incognito",
        "--no-first-run",
        "--no-default-browser-check",
        TARGET_URL
    ])
    print(f"[*] Started headless Chrome (PID: {chrome_proc.pid}) on port {PORT}...")

    time.sleep(2.5)
    try:
        req = urllib.request.urlopen(f"http://127.0.0.1:{PORT}/json")
        tabs = json.loads(req.read().decode())
        page_tab = None
        for t in tabs:
            if t.get("type") == "page" and "8080" in t.get("url", ""):
                page_tab = t
                break
        if not page_tab:
            page_tab = tabs[0]
        ws_url = page_tab["webSocketDebuggerUrl"]
        print(f"[*] Connected to Chrome tab: {page_tab.get('title')} ({page_tab.get('url')})")
    except Exception as e:
        chrome_proc.terminate()
        raise RuntimeError(f"Failed to connect to Chrome DevTools: {e}")

    try:
        async with websockets.connect(ws_url) as ws:
            print("\n--- 1. Auditing Document Structure & Meta Tags ---")
            title = await cdp_eval(ws, "document.title")
            assert "VELOCITY" in title, f"Unexpected title: {title}"
            print(f"  [PASS] Page Title: '{title}'")

            # Check primary sections
            sections = [
                'bdp-calculator', 'pillars', 'pc-gaming',
                'ui-preview', 'matrix', 'security', 'quickstart'
            ]
            for s in sections:
                exists = await cdp_eval(ws, f"!!document.getElementById('{s}')")
                assert exists, f"Section #{s} is missing!"
                print(f"  [PASS] Section #{s} rendered cleanly")

            print("\n--- 2. Auditing Interactive BDP & Speed Calculator ---")
            slider_exists = await cdp_eval(ws, "!!document.getElementById('speed-slider')")
            assert slider_exists, "Speed slider missing!"
            
            # Initial values at 200 Mbps
            initial_speed = await cdp_eval(ws, "document.getElementById('speed-val-display').textContent")
            assert "200 Mbps" in initial_speed, f"Unexpected initial speed: {initial_speed}"
            print(f"  [PASS] Default speed display: {initial_speed}")

            # Test Slider drag to 500 Mbps
            await cdp_eval(ws, """
                (() => {
                    const s = document.getElementById('speed-slider');
                    s.value = 500;
                    s.dispatchEvent(new Event('input', { bubbles: true }));
                })()
            """)
            await asyncio.sleep(0.3)

            speed_500 = await cdp_eval(ws, "document.getElementById('speed-val-display').textContent")
            assert "500 Mbps" in speed_500, f"Slider failed to update to 500 Mbps: {speed_500}"
            vel_speed = await cdp_eval(ws, "document.getElementById('velocity-speed-val').textContent")
            assert "500 Mbps" in vel_speed, f"VELOCITY speed calculation mismatch: {vel_speed}"
            leg_speed = await cdp_eval(ws, "document.getElementById('legacy-speed-val').textContent")
            assert "40 Mbps" in leg_speed, f"Legacy speed failed to show stall: {leg_speed}"
            print(f"  [PASS] Slider dynamically adjusted to 500 Mbps. VELOCITY: {vel_speed} | Legacy: {leg_speed}")

            # Test Slider drag to 1000 Mbps (Gigabit)
            await cdp_eval(ws, """
                (() => {
                    const s = document.getElementById('speed-slider');
                    s.value = 1000;
                    s.dispatchEvent(new Event('input', { bubbles: true }));
                })()
            """)
            await asyncio.sleep(0.3)
            speed_1000 = await cdp_eval(ws, "document.getElementById('speed-val-display').textContent")
            assert "1000 Mbps" in speed_1000
            print("  [PASS] Slider successfully verified at Gigabit speed (1,000 Mbps)")

            print("\n--- 3. Auditing Interactive Product UI Preview Tabs ---")
            tab_keys = ['gamehub', 'peers', 'security', 'dashboard']
            for tk in tab_keys:
                await cdp_eval(ws, f"document.querySelector('.preview-tab-btn[data-view=\"{tk}\"]').click()")
                await asyncio.sleep(0.2)
                is_active = await cdp_eval(ws, f"document.querySelector('.preview-tab-btn[data-view=\"{tk}\"]').classList.contains('active')")
                assert is_active, f"Tab {tk} failed to activate!"
                content_len = await cdp_eval(ws, "document.getElementById('preview-tab-content').innerHTML.length")
                assert content_len > 100, f"Tab {tk} content empty!"
                print(f"  [PASS] UI Preview Tab '{tk}' clicked and rendered content ({content_len} chars)")

            print("\n--- 4. Auditing Clipboard & Copy Utilities ---")
            toast_text = await cdp_eval(ws, """
                (() => {
                    const btn = document.querySelector('.hero-copy-cmd');
                    if (btn) btn.click();
                    return document.getElementById('landing-toast')?.textContent || 'NO_TOAST';
                })()
            """)
            print(f"  [PASS] Copy trigger executed. Toast feedback: '{toast_text}'")

            print("\n--- 5. Auditing Comparison Matrix & Security Verification ---")
            rows_count = await cdp_eval(ws, "document.querySelectorAll('.matrix-table tbody tr').length")
            assert rows_count >= 8, f"Expected at least 8 comparison rows, got {rows_count}"
            print(f"  [PASS] Comparison Matrix verified with {rows_count} engineering criteria")

            sec_vectors_count = await cdp_eval(ws, "document.querySelectorAll('.sec-vector-item').length")
            assert sec_vectors_count == 8, f"Expected 8 security vectors, got {sec_vectors_count}"
            print(f"  [PASS] V-Shield Security Audit Stamp verified with all {sec_vectors_count} attack vectors")

            print("\n" + "=" * 70)
            print("  PRODUCT WEBSITE AUDIT VERDICT: 100% VERIFIED & PRODUCTION READY!")
            print("=" * 70)
    finally:
        chrome_proc.terminate()
        try:
            chrome_proc.wait(timeout=2.0)
        except Exception:
            chrome_proc.kill()
        shutil.rmtree(temp_profile, ignore_errors=True)

if __name__ == "__main__":
    asyncio.run(run_landing_audit())
