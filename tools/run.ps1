param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Args
)

$ErrorActionPreference = "Stop"

$mode = if ($Args.Count -gt 0) { $Args[0].ToLowerInvariant() } else { "dev" }

function Invoke-Script([string]$Path) {
    & powershell -ExecutionPolicy Bypass -File $Path
    if ($LASTEXITCODE -ne 0) {
        exit $LASTEXITCODE
    }
}

switch ($mode) {
    "dev" {
        Invoke-Script "tools/dev.ps1"
    }
    "build" {
        Invoke-Script "tools/build.ps1"
    }
    "release" {
        Invoke-Script "tools/release.ps1"
    }
    "start" {
        $port = 8080
        if ($Args.Count -gt 1) {
            [void][int]::TryParse($Args[1], [ref]$port)
        }

        & powershell -ExecutionPolicy Bypass -File tools/run-dev.ps1 -Port $port
        if ($LASTEXITCODE -ne 0) {
            exit $LASTEXITCODE
        }
    }
    "serve" {
        $port = 8080
        if ($Args.Count -gt 1) {
            [void][int]::TryParse($Args[1], [ref]$port)
        }

        & powershell -ExecutionPolicy Bypass -File tools/serve.ps1 -Port $port
        if ($LASTEXITCODE -ne 0) {
            exit $LASTEXITCODE
        }
    }
    default {
        Write-Host "Usage: run.cmd [dev|build|release|start|serve]"
        exit 1
    }
}
