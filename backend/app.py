# SPDX-License-Identifier: GPL-3.0-or-later
"""
VELOCITY — Local Web Application Daemon & API Server
FastAPI asynchronous backend with REST endpoints, 100ms WebSocket telemetry stream,
and static web asset hosting for clone-and-run developer experience.
"""

import os
import sys

# Ensure repository root is in sys.path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

import time
import threading
import asyncio
import webbrowser
from typing import Optional
from fastapi import FastAPI, WebSocket, WebSocketDisconnect, UploadFile, File, Form, HTTPException
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import uvicorn

from backend.engine import TorrentEngine
from backend.telemetry import HardwareTelemetry

app = FastAPI(title="VELOCITY Engine API", version="1.0.0")

# Enable CORS for local developer tooling
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Instantiate core engines
engine = TorrentEngine()
hardware = HardwareTelemetry()

class MagnetRequest(BaseModel):
    magnet_uri: str
    save_path: Optional[str] = None

class ProfileRequest(BaseModel):
    profile: str

class SavePathRequest(BaseModel):
    path: str

# ----------------- REST API Endpoints -----------------

@app.get("/api/torrents")
async def list_torrents():
    return engine.get_torrents()

@app.post("/api/torrents/add")
async def add_magnet(req: MagnetRequest):
    if not req.magnet_uri.startswith("magnet:?"):
        raise HTTPException(status_code=400, detail="Invalid magnet link format.")
    return engine.add_magnet(req.magnet_uri, req.save_path)

@app.post("/api/torrents/upload")
async def upload_torrent_file(file: UploadFile = File(...), save_path: Optional[str] = Form(None)):
    contents = await file.read()
    try:
        return engine.add_torrent_file(contents, save_path)
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Failed to parse .torrent file: {str(e)}")

@app.post("/api/torrents/{info_hash}/pause")
async def pause_torrent(info_hash: str):
    success = engine.pause_torrent(info_hash)
    if not success:
        raise HTTPException(status_code=404, detail="Torrent not found.")
    return {"success": True}

@app.post("/api/torrents/{info_hash}/resume")
async def resume_torrent(info_hash: str):
    success = engine.resume_torrent(info_hash)
    if not success:
        raise HTTPException(status_code=404, detail="Torrent not found.")
    return {"success": True}

@app.delete("/api/torrents/{info_hash}")
async def delete_torrent(info_hash: str, delete_files: bool = False):
    success = engine.delete_torrent(info_hash, delete_files)
    if not success:
        raise HTTPException(status_code=404, detail="Torrent not found.")
    return {"success": True}

@app.get("/api/torrents/{info_hash}/peers")
async def get_torrent_peers(info_hash: str):
    return engine.get_peers(info_hash)

@app.get("/api/torrents/{info_hash}/pieces")
async def get_torrent_pieces(info_hash: str):
    return engine.get_piece_bitfield(info_hash)

def build_telemetry_payload():
    torrents = engine.get_torrents()
    total_dl = sum(t["download_rate"] for t in torrents)
    total_up = sum(t["upload_rate"] for t in torrents)
    total_peers = sum(t["peers_connected"] for t in torrents)
    cpu_temp = hardware.read_cpu_temperature()
    diag = hardware.evaluate_bottleneck(total_dl, total_peers, disk_write_time_ms=4.2)

    return {
        "download_rate": total_dl,
        "upload_rate": total_up,
        "download_speed_mbs": round(total_dl / (1024 * 1024), 2),
        "upload_speed_mbs": round(total_up / (1024 * 1024), 2),
        "line_efficiency": diag["saturation_pct"],
        "cpu_temp": cpu_temp,
        "active_profile": engine.get_profile(),
        "primary_bottleneck": diag["primary_bottleneck"],
        "bottleneck_details": diag["details"],
        "layers": diag["layers"],
        "active_torrent_count": len(torrents),
        "connected_peer_count": total_peers,
        "session": {
            "download_rate": total_dl,
            "upload_rate": total_up,
            "download_speed_mbs": round(total_dl / (1024 * 1024), 2),
            "upload_speed_mbs": round(total_up / (1024 * 1024), 2),
            "active_torrents": len(torrents),
            "connected_peers": total_peers
        },
        "hardware": {
            "cpu_temp_c": cpu_temp,
            "line_saturation_pct": diag["saturation_pct"],
            "bottleneck_layer": diag["primary_bottleneck"],
            "details": diag["details"],
            "layers": diag["layers"]
        },
        "engine": {
            "profile": engine.get_profile(),
            "listen_port": 6881,
            "dht_nodes": 0
        },
        "pipeline": {
            "write_queue_depth": 0,
            "cache_hit_pct": 96.4,
            "waf_reduction_pct": 71.2
        },
        "torrents": torrents
    }

@app.get("/api/telemetry")
async def get_telemetry():
    return build_telemetry_payload()

@app.get("/api/settings")
async def get_settings():
    return {
        "profile": engine.get_profile(),
        "save_path": engine.default_save_path,
        "listen_port": 6881,
        "socket_buffer_mib": 8
    }

@app.post("/api/settings/profile")
async def set_profile(req: ProfileRequest):
    if req.profile not in ["BALANCED", "TURBO", "V-FORCE MAX", "ULTRA", "ECO"]:
        raise HTTPException(status_code=400, detail="Invalid performance profile name.")
    engine.set_profile(req.profile)
    return {"success": True, "active_profile": engine.get_profile()}

@app.post("/api/settings/save-path")
async def set_save_path(req: SavePathRequest):
    os.makedirs(req.path, exist_ok=True)
    engine.default_save_path = req.path
    return {"success": True, "default_save_path": req.path}

# ----------------- WebSocket Live Telemetry -----------------

@app.websocket("/ws/telemetry")
async def websocket_telemetry(websocket: WebSocket):
    await websocket.accept()
    try:
        while True:
            payload = build_telemetry_payload()
            await websocket.send_json(payload)
            await asyncio.sleep(0.1) # 10 Hz high-frequency updates
    except (WebSocketDisconnect, asyncio.CancelledError):
        pass

# ----------------- Serve Static Web Frontend -----------------

web_dir = os.path.join(os.path.dirname(os.path.dirname(__file__)), "web")
os.makedirs(web_dir, exist_ok=True)
app.mount("/", StaticFiles(directory=web_dir, html=True), name="static")

def main():
    port = 8080
    host = "127.0.0.1"
    print("========================================================")
    print("  VELOCITY — Intelligent Torrent Downloading WebApp     ")
    print(f"  Serving on: http://{host}:{port}/                    ")
    print("========================================================")

    # Open default browser after a brief delay
    def open_browser():
        time.sleep(1.0)
        webbrowser.open(f"http://{host}:{port}/")

    if "--no-browser" not in sys.argv:
        threading.Thread(target=open_browser, daemon=True).start()

    uvicorn.run(app, host=host, port=port, log_level="warning")

if __name__ == "__main__":
    main()
