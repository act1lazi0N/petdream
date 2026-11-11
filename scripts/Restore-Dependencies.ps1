$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$webRoot = Join-Path $projectRoot 'src\PetDream.Web'
$packageRoot = Join-Path $projectRoot '.artifacts\packages'
$manifestPath = Join-Path $webRoot 'packages.config'
[xml]$manifest = Get-Content -LiteralPath $manifestPath -Raw

# Web Site khong co csproj: restore package va copy cac runtime asset can thiet.
$assetMap = @{
    'BCrypt.Net-Next' = @('lib\net48\BCrypt-Net-Next.dll')
    'System.Buffers' = @('lib\net462\System.Buffers.dll')
    'System.Memory' = @('lib\net462\System.Memory.dll')
    'System.Numerics.Vectors' = @('lib\net462\System.Numerics.Vectors.dll')
    'System.Runtime.CompilerServices.Unsafe' = @('lib\net462\System.Runtime.CompilerServices.Unsafe.dll')
    'jQuery' = @('Content\Scripts\jquery-3.7.1.js', 'Content\Scripts\jquery-3.7.1.min.js', 'Content\Scripts\jquery-3.7.1.min.map')
}

$requiresRestore = $false
foreach ($package in $manifest.packages.package) {
    if (-not $assetMap.ContainsKey($package.id)) {
        throw "No Web Site asset mapping for package $($package.id)."
    }
    $packageDirectory = Join-Path $packageRoot ($package.id + '.' + $package.version)
    foreach ($asset in $assetMap[$package.id]) {
        if (-not (Test-Path -LiteralPath (Join-Path $packageDirectory $asset))) {
            $requiresRestore = $true
        }
    }
}

if ($requiresRestore) {
    $toolDirectory = Join-Path $projectRoot '.artifacts\tools'
    $nugetPath = Join-Path $toolDirectory 'nuget-6.14.0.exe'
    $expectedHash = '92DBED160DDEE0F64B901E907439E021211B428E57C089ECC12FC38DCC4BD9A5'
    New-Item -ItemType Directory -Path $toolDirectory -Force | Out-Null

    if (-not (Test-Path -LiteralPath $nugetPath)) {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $downloadPath = $nugetPath + '.download'
        Invoke-WebRequest -Uri 'https://dist.nuget.org/win-x86-commandline/v6.14.0/nuget.exe' -OutFile $downloadPath -UseBasicParsing
        if ((Get-FileHash -LiteralPath $downloadPath -Algorithm SHA256).Hash -ne $expectedHash) {
            throw 'Downloaded NuGet CLI checksum does not match the pinned version.'
        }
        Move-Item -LiteralPath $downloadPath -Destination $nugetPath
    }

    if ((Get-FileHash -LiteralPath $nugetPath -Algorithm SHA256).Hash -ne $expectedHash) {
        throw 'NuGet CLI checksum does not match the pinned version.'
    }
    & $nugetPath restore $manifestPath -PackagesDirectory $packageRoot -ConfigFile (Join-Path $projectRoot 'NuGet.Config') -NonInteractive
    if ($LASTEXITCODE -ne 0) {
        throw "NuGet restore failed with exit code $LASTEXITCODE."
    }
}

foreach ($package in $manifest.packages.package) {
    $packageDirectory = Join-Path $packageRoot ($package.id + '.' + $package.version)
    $destinationDirectory = Join-Path $webRoot 'Bin'
    if ($package.id -eq 'jQuery') {
        $destinationDirectory = Join-Path $webRoot 'Scripts\vendor'
    }
    New-Item -ItemType Directory -Path $destinationDirectory -Force | Out-Null

    foreach ($asset in $assetMap[$package.id]) {
        $sourcePath = Join-Path $packageDirectory $asset
        if (-not (Test-Path -LiteralPath $sourcePath)) {
            throw "Missing restored asset: $sourcePath"
        }
        $destinationPath = Join-Path $destinationDirectory (Split-Path -Leaf $asset)
        if (-not (Test-Path -LiteralPath $destinationPath) -or
            (Get-FileHash -LiteralPath $sourcePath).Hash -ne (Get-FileHash -LiteralPath $destinationPath).Hash) {
            Copy-Item -LiteralPath $sourcePath -Destination $destinationPath
        }
    }
}
Write-Host 'Web Site dependencies restored (BCrypt.Net-Next and jQuery).'
