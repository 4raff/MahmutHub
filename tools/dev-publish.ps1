$ErrorActionPreference = "Stop"

powershell -ExecutionPolicy Bypass -File tools/build.ps1
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

powershell -ExecutionPolicy Bypass -File tools/build-release.ps1 -BuildPath build -OutputPath live/src/main.lua
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

Write-Host "Development publish completed: live/src/main.lua"
Write-Host "Run tools/serve.ps1 or run.cmd start to host the live folder."
