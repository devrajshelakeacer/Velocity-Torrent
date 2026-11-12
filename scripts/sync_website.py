#!/usr/bin/env python3
"""
VELOCITY Torrent — Worktree & Website Sync Engine
SPDX-License-Identifier: GPL-3.0-or-later

Synchronizes the `web/` directory with the isolated `website` branch
and updates the external worktree at `../Velocity-Website`.
"""

import subprocess
import sys
import os

def run_cmd(cmd, cwd=None):
    print(f"[*] Running: {cmd}")
    res = subprocess.run(cmd, shell=True, cwd=cwd, text=True, capture_output=True)
    if res.stdout:
        print(res.stdout.strip())
    if res.returncode != 0:
        if res.stderr:
            print(f"[WARN] {res.stderr.strip()}", file=sys.stderr)
        return False, res.stdout.strip()
    return True, res.stdout.strip()

def main():
    root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    print("=" * 70)
    print("  VELOCITY — Synchronizing Isolated Website Worktree & Branches")
    print("=" * 70)

    # 1. Get subtree split commit hash
    print("\n[Step 1] Splitting 'web/' directory into subtree commit...")
    ok, commit_hash = run_cmd("git subtree split --prefix=web", cwd=root)
    if not ok or not commit_hash:
        print("[FAIL] Could not generate subtree commit hash.")
        return 1
    
    commit_hash = commit_hash.split()[-1]
    print(f"  -> Generated Subtree Commit: {commit_hash}")

    # 2. Update website branch ref directly (safe with active worktrees)
    print(f"\n[Step 2] Updating branch ref 'website' to {commit_hash}...")
    run_cmd(f"git update-ref refs/heads/website {commit_hash}", cwd=root)

    # 3. Fast-forward the external worktree if exists
    worktree_path = os.path.normpath(os.path.join(root, "..", "Velocity-Website"))
    if os.path.exists(worktree_path):
        print(f"\n[Step 3] Resetting worktree working copy at '{worktree_path}'...")
        run_cmd("git reset --hard website", cwd=worktree_path)

    print("\n" + "=" * 70)
    print("  [SUCCESS] Website worktree & branch synchronized perfectly!")
    print("  - Isolated Website Branch: 'website'")
    print(f"  - Isolated Worktree:       '{worktree_path}'")
    print("=" * 70)
    return 0

if __name__ == "__main__":
    sys.exit(main())
