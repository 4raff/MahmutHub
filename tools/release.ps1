$ErrorActionPreference = "Stop"

powershell -ExecutionPolicy Bypass -File tools/build.ps1
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

powershell -ExecutionPolicy Bypass -File tools/build-release.ps1
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

Write-Host "Release completed: release/mahmut-hub.lua"
