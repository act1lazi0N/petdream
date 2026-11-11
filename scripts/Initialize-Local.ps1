$ErrorActionPreference = 'Stop'
& (Join-Path $PSScriptRoot 'Restore-Dependencies.ps1')
$projectRoot = Split-Path -Parent $PSScriptRoot
$webRoot = Join-Path $projectRoot 'src\PetDream.Web'
$localConfig = Join-Path $webRoot 'ConnectionStrings.config'

if (-not (Test-Path -LiteralPath $localConfig)) {
    Copy-Item -LiteralPath (Join-Path $webRoot 'ConnectionStrings.example.config') -Destination $localConfig
    Write-Host 'Created local connection configuration. No database was created.'
} else {
    Write-Host 'Existing local configuration preserved.'
}
