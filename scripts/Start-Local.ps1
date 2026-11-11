param(
    [ValidateRange(1024, 65535)]
    [int]$Port = 8088
)

$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$webRoot = Join-Path $projectRoot 'src\PetDream.Web'
$iisExpress = Join-Path ${env:ProgramFiles(x86)} 'IIS Express\iisexpress.exe'

if (-not (Test-Path -LiteralPath $iisExpress)) {
    throw 'IIS Express not found. Install IIS Express before starting the website.'
}

& (Join-Path $PSScriptRoot 'Initialize-Local.ps1')
Write-Host "PetDream: http://localhost:$Port/ (Ctrl+C to stop)"
& $iisExpress "/path:$webRoot" "/port:$Port" /systray:false
if ($LASTEXITCODE -ne 0) {
    throw "IIS Express exited with code $LASTEXITCODE."
}
