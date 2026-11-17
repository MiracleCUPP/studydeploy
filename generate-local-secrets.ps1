$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$template = Join-Path $root ".env.example"
$target = Join-Path $root ".env"

if (-not (Test-Path $template)) {
    throw ".env.example not found: $template"
}

function New-SecureToken([int]$Bytes = 32) {
    $buffer = New-Object byte[] $Bytes
    [System.Security.Cryptography.RandomNumberGenerator]::Fill($buffer)
    return [Convert]::ToBase64String($buffer).Replace("+", "A").Replace("/", "B").TrimEnd("=")
}

if (Test-Path $target) {
    $answer = Read-Host ".env already exists. Replace it? (y/N)"
    if ($answer -notin @("y", "Y", "yes", "YES")) {
        Write-Host "Cancelled. Existing .env was not changed."
        exit 0
    }
}

$dbPassword = New-SecureToken 24
$appSecret = New-SecureToken 48

$content = Get-Content $template -Raw
$content = $content.Replace("CHANGE_ME_STRONG_DB_PASSWORD", $dbPassword)
$content = $content.Replace("CHANGE_ME_LONG_RANDOM_SECRET", $appSecret)
Set-Content -Path $target -Value $content -Encoding UTF8

Write-Host "Created local .env with random secrets."
Write-Host "The .env file is ignored by Git and must not be committed."
