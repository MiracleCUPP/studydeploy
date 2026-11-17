$ErrorActionPreference = "Stop"

Write-Host "STUDY: local HTTPS certificate for study.localhost" -ForegroundColor Cyan

if (-not (Get-Command mkcert -ErrorAction SilentlyContinue)) {
    Write-Host "mkcert is not installed. Installing with WinGet..." -ForegroundColor Yellow
    winget install FiloSottile.mkcert
    Write-Host "Restart PowerShell and run this script again." -ForegroundColor Yellow
    exit 0
}

Write-Host "Installing local CA (Windows may ask for administrator confirmation)..." -ForegroundColor Yellow
mkcert -install

$certDir = Join-Path $PSScriptRoot "certs"
New-Item -ItemType Directory -Force -Path $certDir | Out-Null

$certFile = Join-Path $certDir "study.localhost.pem"
$keyFile = Join-Path $certDir "study.localhost-key.pem"

mkcert -cert-file $certFile -key-file $keyFile study.localhost

Write-Host "Certificate created:" -ForegroundColor Green
Write-Host $certFile
Write-Host $keyFile
Write-Host "Do NOT commit the certificate private key to GitHub." -ForegroundColor Yellow
