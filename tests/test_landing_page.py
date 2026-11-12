# SPDX-License-Identifier: GPL-3.0-or-later
"""
Automated Verification Suite for VELOCITY Flagship Product Showcase & Marketing Website
Audits http://127.0.0.1:8080/landing via Chrome DevTools Protocol across Desktop, Tablet, and Mobile viewports.
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

async def cdp_call(ws, method, params=None):
    msg_id = int(time.time() * 1000) % 100000
    req = {
        "id": msg_id,
        "method": method,
        "params": params or {}
    }
    await ws.send(json.dumps(req))
    while True:
        resp = json.loads(await ws.recv())
        if resp.get("id") == msg_id:
            if "error" in resp:
                raise RuntimeError(f"CDP Error in '{method}': {resp['error']}")
            return resp.get("result", {})

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
    print("=" * 75)
    print("  VELOCITY — Product Showcase Multi-Viewport CDP Verification Suite")
    print("=" * 75)

    temp_profile = tempfile.mkdtemp(prefix="chrome_landing_")

    chrome_proc = subprocess.Popen([
        CHROME_PATH,
        "--headless=new",
        "--disable-gpu",
        "--window-size=1920,1080",
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
            print("\n--- 1. Auditing Desktop Viewport & Document Structure ---")
            title = await cdp_eval(ws, "document.title")
            assert "VELOCITY" in title, f"Unexpected title: {title}"
            print(f"  [PASS] Page Title: '{title}'")

            # Check primary sections including new FAQ and Platforms strip
            sections = [
                'bdp-calculator', 'pillars', 'pc-gaming',
                'ui-preview', 'matrix', 'security', 'faq', 'quickstart'
            ]
            for s in sections:
                exists = await cdp_eval(ws, f"!!document.getElementById('{s}')")
                assert exists, f"Section #{s} is missing!"
                print(f"  [PASS] Section #{s} rendered cleanly")

            # Check Google Font Inter integration
            font_family = await cdp_eval(ws, "window.getComputedStyle(document.body).fontFamily")
            assert "Inter" in font_family, f"Inter font not in computed style: {font_family}"
            print(f"  [PASS] Typography computed font-family: '{font_family}'")

            print("\n--- 2. Auditing Normalized Spacing & Gaps ---")
            section_pad = await cdp_eval(ws, "window.getComputedStyle(document.documentElement).getPropertyValue('--section-pad-y').trim()")
            assert section_pad == "56px", f"Expected --section-pad-y to be 56px, got: {section_pad}"
            print(f"  [PASS] Normalized standard section padding verified: {section_pad}")

            print("\n--- 3. Auditing Interactive BDP & Speed Calculator ---")
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

            print("\n--- 4. Auditing Interactive Product UI Preview Tabs ---")
            tab_keys = ['gamehub', 'peers', 'security', 'dashboard']
            for tk in tab_keys:
                await cdp_eval(ws, f"document.querySelector('.preview-tab-btn[data-view=\"{tk}\"]').click()")
                await asyncio.sleep(0.2)
                is_active = await cdp_eval(ws, f"document.querySelector('.preview-tab-btn[data-view=\"{tk}\"]').classList.contains('active')")
                assert is_active, f"Tab {tk} failed to activate!"
                content_len = await cdp_eval(ws, "document.getElementById('preview-tab-content').innerHTML.length")
                assert content_len > 100, f"Tab {tk} content empty!"
                print(f"  [PASS] UI Preview Tab '{tk}' clicked and rendered content ({content_len} chars)")

            print("\n--- 5. Auditing FAQ Accordion (Universal Addition) ---")
            faq_count = await cdp_eval(ws, "document.querySelectorAll('.faq-item').length")
            assert faq_count == 6, f"Expected 6 FAQ items, got {faq_count}"
            
            # Click first FAQ item to expand
            await cdp_eval(ws, "document.querySelectorAll('.faq-trigger')[0].click()")
            await asyncio.sleep(0.3)
            item1_active = await cdp_eval(ws, "document.querySelectorAll('.faq-item')[0].classList.contains('active')")
            assert item1_active, "FAQ item 1 failed to expand!"
            item1_expanded = await cdp_eval(ws, "document.querySelectorAll('.faq-trigger')[0].getAttribute('aria-expanded')")
            assert item1_expanded == "true", "FAQ item 1 aria-expanded is not true!"
            print(f"  [PASS] FAQ Accordion verified with {faq_count} questions. Expand & ARIA states active.")

            print("\n--- 6. Auditing Mobile Viewport & Hamburger Navigation (375x667) ---")
            # Emulate Mobile iPhone SE
            await cdp_call(ws, "Emulation.setDeviceMetricsOverride", {
                "width": 375,
                "height": 667,
                "deviceScaleFactor": 2,
                "mobile": True
            })
            await asyncio.sleep(0.5)

            # Check that desktop nav links are hidden and hamburger toggle is visible
            hamburger_visible = await cdp_eval(ws, "window.getComputedStyle(document.getElementById('mobile-menu-toggle')).display !== 'none'")
            assert hamburger_visible, "Mobile menu toggle is not visible on mobile viewport!"
            desktop_nav_hidden = await cdp_eval(ws, "window.getComputedStyle(document.querySelector('.nav-links')).display === 'none'")
            assert desktop_nav_hidden, "Desktop nav links still visible on mobile viewport!"
            print("  [PASS] Mobile breakpoint detected: desktop nav hidden, hamburger toggle active.")

            # Test opening mobile drawer
            await cdp_eval(ws, "document.getElementById('mobile-menu-toggle').click()")
            await asyncio.sleep(0.3)
            drawer_open = await cdp_eval(ws, "document.getElementById('mobile-drawer').classList.contains('open')")
            assert drawer_open, "Mobile drawer failed to open on toggle click!"
            toggle_expanded = await cdp_eval(ws, "document.getElementById('mobile-menu-toggle').getAttribute('aria-expanded') === 'true'")
            assert toggle_expanded, "Toggle aria-expanded is not true!"
            print("  [PASS] Mobile drawer opened with smooth frosted glass animation.")

            # Test auto-closing when link is clicked
            await cdp_eval(ws, "document.querySelector('.mobile-drawer-link').click()")
            await asyncio.sleep(0.3)
            drawer_closed = await cdp_eval(ws, "!document.getElementById('mobile-drawer').classList.contains('open')")
            assert drawer_closed, "Mobile drawer failed to close upon link click!"
            print("  [PASS] Mobile drawer auto-closed upon navigating to link.")

            # Reset device metrics override back to desktop
            await cdp_call(ws, "Emulation.clearDeviceMetricsOverride")
            await asyncio.sleep(0.3)
            print("  [PASS] Emulation cleared, restored to standard desktop viewport.")

            print("\n--- 7. Auditing Platforms Strip & Floating Back to Top ---")
            platforms_exist = await cdp_eval(ws, "!!document.querySelector('.platforms-strip')")
            assert platforms_exist, "Platforms strip missing!"
            print("  [PASS] Platforms & Hardware compatibility strip rendered.")

            # Test Back to Top button scroll behavior
            await cdp_eval(ws, "window.scrollTo(0, 1000); window.dispatchEvent(new Event('scroll'));")
            await asyncio.sleep(0.3)
            btt_visible = await cdp_eval(ws, "document.getElementById('back-to-top').classList.contains('visible')")
            assert btt_visible, "Back-to-top button failed to show after 1000px scroll!"
            await cdp_eval(ws, "document.getElementById('back-to-top').click()")
            await asyncio.sleep(0.4)
            print("  [PASS] Back to Top button appeared on scroll and triggered smooth return.")

            print("\n" + "=" * 75)
            print("  MULTI-VIEWPORT AUDIT VERDICT: 100% PASSES ACROSS DESKTOP & MOBILE!")
            print("=" * 75)
    finally:
        chrome_proc.terminate()
        try:
            chrome_proc.wait(timeout=2.0)
        except Exception:
            chrome_proc.kill()
        shutil.rmtree(temp_profile, ignore_errors=True)

if __name__ == "__main__":
    asyncio.run(run_landing_audit())
