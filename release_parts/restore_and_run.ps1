$ErrorActionPreference = "Stop"

Set-Location -Path $PSScriptRoot

$zipName = "DMS_Test_Studio_Windows_1.0.0.zip"
$parts = @(
    "DMS_Test_Studio_Windows_1.0.0.zip.part01",
    "DMS_Test_Studio_Windows_1.0.0.zip.part02",
    "DMS_Test_Studio_Windows_1.0.0.zip.part03",
    "DMS_Test_Studio_Windows_1.0.0.zip.part04"
)

foreach ($part in $parts) {
    if (-not (Test-Path $part)) {
        throw "Missing file: $part"
    }
}

Write-Host "[1/3] Merging split package..."
$partPaths = $parts | ForEach-Object { Join-Path $PSScriptRoot $_ }
$outZip = Join-Path (Split-Path $PSScriptRoot -Parent) $zipName

$out = [System.IO.File]::Open($outZip, [System.IO.FileMode]::Create, [System.IO.FileAccess]::Write)
try {
    foreach ($p in $partPaths) {
        $bytes = [System.IO.File]::ReadAllBytes($p)
        $out.Write($bytes, 0, $bytes.Length)
    }
}
finally {
    $out.Dispose()
}

Write-Host "[2/3] Extracting package..."
$dest = Split-Path $PSScriptRoot -Parent
Expand-Archive -Path $outZip -DestinationPath $dest -Force

Write-Host "[3/3] Launching app..."
$exe = Join-Path $dest "DMS Test Studio\\DMS Test Studio.exe"
Start-Process -FilePath $exe

Write-Host "Done."
