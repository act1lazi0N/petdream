$ErrorActionPreference = 'Stop'
if ($PSVersionTable.PSEdition -ne 'Desktop') {
    throw 'Run with Windows PowerShell (powershell.exe) to verify .NET Framework dependencies.'
}
& (Join-Path $PSScriptRoot 'Restore-Dependencies.ps1')
$projectRoot = Split-Path -Parent $PSScriptRoot
$binRoot = Join-Path $projectRoot 'src\PetDream.Web\Bin'
foreach ($assemblyName in @('System.Runtime.CompilerServices.Unsafe.dll', 'System.Buffers.dll', 'System.Numerics.Vectors.dll', 'System.Memory.dll', 'BCrypt-Net-Next.dll')) {
    [Reflection.Assembly]::LoadFrom((Join-Path $binRoot $assemblyName)) | Out-Null
}

# Du lieu kiem thu, khong phai tai khoan hoac mat khau ung dung.
$samplePassword = 'PetDream dependency smoke check'
$hash = [BCrypt.Net.BCrypt]::EnhancedHashPassword($samplePassword)
if (-not [BCrypt.Net.BCrypt]::EnhancedVerify($samplePassword, $hash)) {
    throw 'BCrypt did not verify the correct password.'
}
if ([BCrypt.Net.BCrypt]::EnhancedVerify('different sample', $hash)) {
    throw 'BCrypt accepted an incorrect password.'
}
if ($hash -eq [BCrypt.Net.BCrypt]::EnhancedHashPassword($samplePassword)) {
    throw 'BCrypt did not generate an independent salt.'
}
Write-Host 'BCrypt hash/verify, wrong-password and salt checks passed on .NET Framework.'
