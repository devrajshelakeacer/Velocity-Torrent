# SPDX-License-Identifier: GPL-3.0-or-later
<#
.SYNOPSIS
    Builds VELOCITY for Windows 10 & 11 (x64) in Release mode.
.DESCRIPTION
    Configures CMake with Ninja, compiles core engine libraries, generates executable binaries,
    and runs CTest verification gates.
#>

[CmdletBinding()]
param (
    [string]$BuildDir = "build",
    [string]$Config = "Release",
    [switch]$RunTests
)

$ErrorActionPreference = "Stop"

Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "  VELOCITY Windows x64 Release Build Pipeline           " -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan

# 1. Verify build tools
Write-Host "`n[1/4] Checking build tools (CMake, Ninja)..." -ForegroundColor Yellow
if (-not (Get-Command cmake -ErrorAction SilentlyContinue)) {
    Write-Warning "CMake not found in PATH. Install via: winget install Kitware.CMake"
}
if (-not (Get-Command ninja -ErrorAction SilentlyContinue)) {
    Write-Warning "Ninja not found in PATH. Install via: winget install Ninja-build.Ninja"
}

# 2. Configure CMake project
Write-Host "`n[2/4] Configuring CMake project ($Config)..." -ForegroundColor Yellow
cmake -B $BuildDir -G Ninja -DCMAKE_BUILD_TYPE=$Config

# 3. Compile Targets
Write-Host "`n[3/4] Compiling VELOCITY targets..." -ForegroundColor Yellow
cmake --build $BuildDir --config $Config

# 4. Optional Test Gate
if ($RunTests) {
    Write-Host "`n[4/4] Executing automated test suite..." -ForegroundColor Yellow
    ctest --test-dir $BuildDir --output-on-failure
}

Write-Host "`n[SUCCESS] VELOCITY Build Pipeline Finished." -ForegroundColor Green
