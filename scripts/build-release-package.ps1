param(
    [string] $Version = '0.1.6'
)

$ErrorActionPreference = 'Stop'
$source = $PSScriptRoot | Split-Path -Parent
$output = Join-Path $source 'dist'
$zipPath = Join-Path $output ("m360-external-featured-media-wordpress-v{0}.zip" -f $Version)

if (-not (Test-Path -LiteralPath (Join-Path $source 'm360-external-featured-media.php'))) {
    throw 'Arquivo principal do plugin não encontrado.'
}

New-Item -ItemType Directory -Force -Path $output | Out-Null
if (Test-Path -LiteralPath $zipPath) { Remove-Item -LiteralPath $zipPath -Force }

Add-Type -AssemblyName System.IO.Compression.FileSystem
$stream = [IO.File]::Open($zipPath, [IO.FileMode]::CreateNew)
try {
    $archive = [IO.Compression.ZipArchive]::new($stream, [IO.Compression.ZipArchiveMode]::Create, $false)
    try {
        [void] $archive.CreateEntry('m360-external-featured-media/')
        Get-ChildItem -LiteralPath $source -File -Include '*.php','README.md','BASELINE.md' | Sort-Object Name | ForEach-Object {
            $entry = $archive.CreateEntry(('m360-external-featured-media/' + $_.Name), [IO.Compression.CompressionLevel]::Optimal)
            $input = [IO.File]::OpenRead($_.FullName)
            $target = $entry.Open()
            try { $input.CopyTo($target) } finally { $target.Dispose(); $input.Dispose() }
        }
    } finally { $archive.Dispose() }
} finally { $stream.Dispose() }

$hash = Get-FileHash -Algorithm SHA256 -LiteralPath $zipPath
[PSCustomObject]@{ Version = $Version; Package = $zipPath; SHA256 = $hash.Hash }
