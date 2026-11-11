$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$webRoot = Join-Path $projectRoot 'src\PetDream.Web'
$compiler = Join-Path $env:WINDIR 'Microsoft.NET\Framework64\v4.0.30319\aspnet_compiler.exe'

if (-not (Test-Path -LiteralPath $compiler)) {
    throw 'ASP.NET Framework compiler not found. Install .NET Framework 4.8 and ASP.NET tooling.'
}

& (Join-Path $PSScriptRoot 'Initialize-Local.ps1')
$buildRoot = Join-Path $projectRoot '.artifacts\build'
New-Item -ItemType Directory -Path $buildRoot -Force | Out-Null
$outputPath = Join-Path $buildRoot ([Guid]::NewGuid().ToString('N'))
& $compiler -v /PetDream -p $webRoot $outputPath
if ($LASTEXITCODE -ne 0) {
    throw "ASP.NET compilation failed with exit code $LASTEXITCODE."
}
Write-Host "Compiled website: $outputPath"
