param(
    [int]$Port = 8080
)

$ErrorActionPreference = "Stop"

$root = (Resolve-Path "live").Path

function Start-Listener([int]$StartPort) {
    for ($candidate = $StartPort; $candidate -le ($StartPort + 20); $candidate++) {
        $listener = [System.Net.HttpListener]::new()
        $prefix = "http://localhost:$candidate/"
        $listener.Prefixes.Add($prefix)

        try {
            $listener.Start()
            return @($listener, $prefix, $candidate)
        }
        catch {
            $listener.Close()
        }
    }

    throw "Unable to bind to a free localhost port starting at $StartPort."
}

$startResult = Start-Listener -StartPort $Port
$listener = $startResult[0]
$prefix = $startResult[1]
$actualPort = $startResult[2]

Write-Host "Serving $root at $prefix"
Write-Host "Use: loadstring(game:HttpGet(""http://localhost:$actualPort/src/main.lua""))()"
Write-Host "Press Ctrl+C to stop."

try {
    while ($listener.IsListening) {
        $context = $listener.GetContext()
        $requestPath = $context.Request.Url.AbsolutePath.TrimStart('/')
        if ([string]::IsNullOrWhiteSpace($requestPath)) {
            $requestPath = "src/main.lua"
        }

        $targetPath = Join-Path $root ($requestPath -replace '/', '\\')
        if (Test-Path $targetPath -PathType Leaf) {
            $bytes = [System.IO.File]::ReadAllBytes($targetPath)
            $context.Response.StatusCode = 200
            $context.Response.ContentType = if ($targetPath.EndsWith(".lua")) { "text/plain; charset=utf-8" } else { "application/octet-stream" }
            $context.Response.OutputStream.Write($bytes, 0, $bytes.Length)
        }
        else {
            $context.Response.StatusCode = 404
            $message = [System.Text.Encoding]::UTF8.GetBytes("Not Found")
            $context.Response.OutputStream.Write($message, 0, $message.Length)
        }

        $context.Response.OutputStream.Close()
    }
}
finally {
    $listener.Stop()
    $listener.Close()
}
