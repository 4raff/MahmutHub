$ErrorActionPreference = "Stop"

darklua process --config .darklua.json --watch src build
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}
