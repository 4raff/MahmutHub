param(
    [int]$Port = 8080
)

$ErrorActionPreference = "Stop"

$serveProcess = Start-Process powershell -ArgumentList @(
    "-ExecutionPolicy",
    "Bypass",
    "-File",
    "tools\serve.ps1",
    "-Port",
    $Port
) -PassThru

try {
    function Invoke-Publish {
        powershell -ExecutionPolicy Bypass -File tools/dev-publish.ps1
        if ($LASTEXITCODE -ne 0) {
            throw "dev-publish failed with exit code $LASTEXITCODE"
        }
    }

    $watcher = [System.IO.FileSystemWatcher]::new((Resolve-Path "src").Path, "*.lua")
    $watcher.IncludeSubdirectories = $true
    $watcher.NotifyFilter = [System.IO.NotifyFilters]"FileName, LastWrite, Size"
    $watcher.EnableRaisingEvents = $true

    $eventIds = @(
        (Register-ObjectEvent -InputObject $watcher -EventName Changed).SourceIdentifier,
        (Register-ObjectEvent -InputObject $watcher -EventName Created).SourceIdentifier,
        (Register-ObjectEvent -InputObject $watcher -EventName Deleted).SourceIdentifier,
        (Register-ObjectEvent -InputObject $watcher -EventName Renamed).SourceIdentifier
    )

    Invoke-Publish
    Write-Host "Live dev is running. Use the URL printed by tools/serve.ps1."

    $lastPublish = Get-Date
    while (-not $serveProcess.HasExited) {
        $event = Wait-Event -Timeout 1
        if ($null -eq $event) {
            continue
        }

        if ($event.SourceIdentifier -in $eventIds) {
            Remove-Event -EventIdentifier $event.EventIdentifier -ErrorAction SilentlyContinue

            if (((Get-Date) - $lastPublish).TotalMilliseconds -lt 200) {
                continue
            }

            try {
                $lastPublish = Get-Date
                Invoke-Publish
                Write-Host ("Updated live bundle because {0} changed." -f $event.SourceEventArgs.FullPath)
            }
            catch {
                Write-Host $_.Exception.Message
            }
        }
    }
}
finally {
    Get-EventSubscriber | Unregister-Event -Force -ErrorAction SilentlyContinue
    Get-Event | Remove-Event -ErrorAction SilentlyContinue
    if ($watcher) {
        $watcher.EnableRaisingEvents = $false
        $watcher.Dispose()
    }

    if ($serveProcess -and -not $serveProcess.HasExited) {
        Stop-Process -Id $serveProcess.Id -Force -ErrorAction SilentlyContinue
    }
}
