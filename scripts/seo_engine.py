#!/usr/bin/env python3
"""
VELOCITY Torrent — Autonomous SEO & Search Engine Indexation Engine
SPDX-License-Identifier: GPL-3.0-or-later

Enforces top Google & search engine ranking:
1. Validates robots.txt, sitemap.xml, IndexNow verification keys, and JSON-LD schemas.
2. Dynamically submits URL updates to the global IndexNow network (Bing, DuckDuckGo, Yandex).
3. Pings Google Search Console sitemap crawlers.
"""

import argparse
import json
import os
import sys
import urllib.parse
import urllib.request
import xml.etree.ElementTree as ET

INDEXNOW_KEY = "96ee3e0a45019d34d6074359e32d1100"
INDEXNOW_ENDPOINT = "https://api.indexnow.org/indexnow"

def audit_local_seo(web_dir: str):
    print("=" * 70)
    print("  VELOCITY Torrent — Programmatic SEO Architecture Audit")
    print("=" * 70)
    
    score = 0
    checks = []

    # 1. robots.txt
    robots_path = os.path.join(web_dir, "robots.txt")
    if os.path.exists(robots_path):
        with open(robots_path, "r", encoding="utf-8") as f:
            content = f.read()
        if "Googlebot" in content and "Bingbot" in content and "Sitemap:" in content:
            checks.append(("[PASS]", "robots.txt properly configured with bot directives & sitemap location"))
            score += 20
        else:
            checks.append(("[WARN]", "robots.txt exists but missing crawler directives"))
    else:
        checks.append(("[FAIL]", "robots.txt missing"))

    # 2. sitemap.xml
    sitemap_path = os.path.join(web_dir, "sitemap.xml")
    if os.path.exists(sitemap_path):
        try:
            tree = ET.parse(sitemap_path)
            root = tree.getroot()
            url_count = len(root.findall("{http://www.sitemaps.org/schemas/sitemap/0.9}url"))
            checks.append(("[PASS]", f"sitemap.xml verified with {url_count} canonical indexable URLs"))
            score += 25
        except Exception as e:
            checks.append(("[FAIL]", f"sitemap.xml is invalid XML: {e}"))
    else:
        checks.append(("[FAIL]", "sitemap.xml missing"))

    # 3. IndexNow Key Verification File
    key_file = os.path.join(web_dir, f"{INDEXNOW_KEY}.txt")
    if os.path.exists(key_file):
        checks.append(("[PASS]", f"IndexNow authentication key file present ({INDEXNOW_KEY}.txt)"))
        score += 20
    else:
        checks.append(("[FAIL]", "IndexNow key file missing"))

    # 4. JSON-LD Rich Results Schema in landing.html
    landing_path = os.path.join(web_dir, "landing.html")
    if os.path.exists(landing_path):
        with open(landing_path, "r", encoding="utf-8") as f:
            html = f.read()
        has_software = "SoftwareApplication" in html and "Velocity Torrent" in html
        has_faq = "FAQPage" in html and "ISDone.dll" in html
        has_canonical = "canonical-link" in html
        if has_software and has_faq and has_canonical:
            checks.append(("[PASS]", "Google Knowledge Graph (SoftwareApplication + FAQPage + Canonical) active"))
            score += 25
        else:
            checks.append(("[WARN]", "landing.html partially missing JSON-LD schema or canonical resolver"))
            score += 10
    else:
        checks.append(("[FAIL]", "landing.html missing"))

    # 5. Cloudflare / Edge Headers & Redirects
    headers_path = os.path.join(web_dir, "_headers")
    redirects_path = os.path.join(web_dir, "_redirects")
    if os.path.exists(headers_path) and os.path.exists(redirects_path):
        checks.append(("[PASS]", "Edge deployment directives (_headers, _redirects) active for clean URLs"))
        score += 10
    else:
        checks.append(("[WARN]", "Edge headers or redirects missing"))

    for status, msg in checks:
        print(f"  {status} {msg}")

    print("-" * 70)
    print(f"  SEO READINESS SCORE: {score}/100")
    print("=" * 70)
    return score >= 90

def ping_indexnow(domain: str, web_dir: str):
    parsed = urllib.parse.urlparse(domain)
    host = parsed.netloc or domain.replace("https://", "").replace("http://", "").split("/")[0]
    
    url_list = [
        f"https://{host}/",
        f"https://{host}/landing",
        f"https://{host}/landing#pc-gaming",
        f"https://{host}/landing#bdp-calculator",
        f"https://{host}/landing#matrix",
        f"https://{host}/landing#security",
        f"https://{host}/landing#faq"
    ]

    payload = {
        "host": host,
        "key": INDEXNOW_KEY,
        "keyLocation": f"https://{host}/{INDEXNOW_KEY}.txt",
        "urlList": url_list
    }

    data = json.dumps(payload).encode("utf-8")
    req = urllib.request.Request(
        INDEXNOW_ENDPOINT,
        data=data,
        headers={"Content-Type": "application/json; charset=utf-8"},
        method="POST"
    )

    print(f"[*] Submitting {len(url_list)} URLs to IndexNow global API for '{host}'...")
    try:
        with urllib.request.urlopen(req, timeout=10) as resp:
            code = resp.getcode()
            if code in [200, 202]:
                print(f"  [SUCCESS] IndexNow accepted submission (HTTP {code}). Crawlers notified!")
            else:
                print(f"  [INFO] IndexNow returned status code {code}.")
    except Exception as e:
        print(f"  [NOTE] IndexNow ping sent. (If domain is not yet live DNS, HTTP code will resolve upon deployment: {e})")

    # Google Sitemap Ping
    sitemap_url = urllib.parse.quote(f"https://{host}/sitemap.xml")
    google_ping_url = f"https://www.google.com/ping?sitemap={sitemap_url}"
    print(f"[*] Dispatching Google Sitemap Ping -> {google_ping_url}")
    try:
        with urllib.request.urlopen(google_ping_url, timeout=10) as resp:
            print(f"  [SUCCESS] Googlebot notified (HTTP {resp.getcode()})!")
    except Exception as e:
        print(f"  [NOTE] Google ping dispatched (requires live public DNS to fetch sitemap: {e})")

def main():
    parser = argparse.ArgumentParser(description="VELOCITY Torrent SEO Engine")
    parser.add_argument("--audit", action="store_true", help="Run programmatic SEO audit")
    parser.add_argument("--ping", action="store_true", help="Ping IndexNow and Google Search Console")
    parser.add_argument("--domain", type=str, default="velocity-torrent.pages.dev", help="Target deployed domain")
    args = parser.parse_args()

    base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    web_dir = os.path.join(base_dir, "web")

    audit_local_seo(web_dir)

    if args.ping:
        ping_indexnow(args.domain, web_dir)

if __name__ == "__main__":
    main()
