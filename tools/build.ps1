$ErrorActionPreference = "Stop"

darklua process --config .darklua.json src build
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

Write-Host "Build completed: src -> build"
