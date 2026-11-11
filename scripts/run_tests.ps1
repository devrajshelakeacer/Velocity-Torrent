# SPDX-License-Identifier: GPL-3.0-or-later
<#
.SYNOPSIS
    Runs the full VELOCITY test suite and verification harness.
#>

[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "  VELOCITY Automated Verification & Security Test Suite " -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan

# 1. Run Python Test Harness
python tests/test_runner.py

if ($LASTEXITCODE -ne 0) {
    Write-Error "Test harness encountered failures!"
}

# 2. Run CTest if build directory exists
if (Test-Path "build") {
    Write-Host "`nRunning CTest native runner..." -ForegroundColor Yellow
    ctest --test-dir build --output-on-failure
}

Write-Host "`n[SUCCESS] All verification gates passed cleanly." -ForegroundColor Green
