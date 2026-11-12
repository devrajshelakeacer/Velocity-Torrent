# SPDX-License-Identifier: GPL-3.0-or-later
<#
.SYNOPSIS
  Automated GitHub Deployment Script for VELOCITY
.DESCRIPTION
  Links the local VELOCITY git repository to your GitHub public repository,
  ensures the main branch and release tags are synced, and verifies remote connectivity.
.PARAMETER RepoUrl
  The full HTTPS or SSH URL of your GitHub repository.
  Example: https://github.com/DevrajShelake/velocity-torrent.git
#>

param(
    [Parameter(Mandatory=$false)]
    [string]$RepoUrl
)

Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "  VELOCITY — GitHub Public Repository Deployment        " -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan

if (-not $RepoUrl) {
    $RepoUrl = Read-Host "Enter your GitHub repository URL (e.g. https://github.com/<username>/velocity-torrent.git)"
}

if (-not $RepoUrl) {
    Write-Host "[ERROR] Repository URL cannot be empty. Deployment cancelled." -ForegroundColor Red
    exit 1
}

Write-Host "`n[1/3] Configuring git remote 'origin'..." -ForegroundColor Yellow
$existingRemote = git remote get-url origin 2>$null
if ($existingRemote) {
    Write-Host "  Updating existing remote origin -> $RepoUrl" -ForegroundColor Gray
    git remote set-url origin $RepoUrl
} else {
    Write-Host "  Adding remote origin -> $RepoUrl" -ForegroundColor Gray
    git remote add origin $RepoUrl
}

Write-Host "`n[2/3] Setting default branch to 'main'..." -ForegroundColor Yellow
git branch -M main

Write-Host "`n[3/3] Pushing 'main' branch and release tags to GitHub..." -ForegroundColor Yellow
git push -u origin main --tags

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n========================================================" -ForegroundColor Green
    Write-Host "  DEPLOYMENT SUCCESSFUL!                                " -ForegroundColor Green
    Write-Host "  VELOCITY is now published on your public GitHub repo! " -ForegroundColor Green
    Write-Host "========================================================" -ForegroundColor Green
    Write-Host "`nNext Step: Connect Cloudflare Pages to your repo (or set CLOUDFLARE_API_TOKEN) to deploy your web client!" -ForegroundColor Cyan
} else {
    Write-Host "`n[NOTICE] Push failed or authentication was required." -ForegroundColor Yellow
    Write-Host "If GitHub prompted for credentials, ensure you use a Personal Access Token (PAT) with 'repo' scope." -ForegroundColor Gray
}
