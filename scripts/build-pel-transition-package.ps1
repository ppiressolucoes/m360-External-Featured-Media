param(
    [string] $Version = '0.1.6'
)

$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot | Split-Path -Parent
$release = Join-Path $root ("releases\pel-transition-v{0}" -f $Version)
$plugin = Join-Path $root ("dist\m360-external-featured-media-wordpress-v{0}.zip" -f $Version)
$output = Join-Path $root 'dist'
$bundle = Join-Path $output ("m360-external-featured-media-pel-transition-v{0}.zip" -f $Version)

if (-not (Test-Path -LiteralPath $plugin)) { throw 'Pacote instalável do plugin não encontrado.' }
if (-not (Test-Path -LiteralPath (Join-Path $release 'INSTALLATION.md'))) { throw 'Instrução de transição não encontrada.' }
if (Test-Path -LiteralPath $bundle) { Remove-Item -LiteralPath $bundle -Force }

$checksum = (Get-FileHash -Algorithm SHA256 -LiteralPath $plugin).Hash
$checksums = Join-Path $env:TEMP ("m360-external-featured-media-pel-{0}-checksums.txt" -f $Version)
Set-Content -LiteralPath $checksums -NoNewline -Encoding ascii -Value ("SHA256  m360-external-featured-media-wordpress-v{0}.zip  {1}" -f $Version, $checksum)

Add-Type -AssemblyName System.IO.Compression.FileSystem
$stream = [IO.File]::Open($bundle, [IO.FileMode]::CreateNew)
try {
    $archive = [IO.Compression.ZipArchive]::new($stream, [IO.Compression.ZipArchiveMode]::Create, $false)
    try {
        $prefix = "m360-external-featured-media-pel-transition-v{0}/" -f $Version
        foreach ($item in @(
            @{ Source = (Join-Path $release 'INSTALLATION.md'); Entry = 'INSTALLATION.md' },
            @{ Source = $checksums; Entry = 'CHECKSUMS.txt' },
            @{ Source = $plugin; Entry = ('plugin/m360-external-featured-media-wordpress-v{0}.zip' -f $Version) }
        )) {
            $entry = $archive.CreateEntry(($prefix + $item.Entry), [IO.Compression.CompressionLevel]::Optimal)
            $input = [IO.File]::OpenRead($item.Source)
            $target = $entry.Open()
            try { $input.CopyTo($target) } finally { $target.Dispose(); $input.Dispose() }
        }
    } finally { $archive.Dispose() }
} finally { $stream.Dispose(); Remove-Item -LiteralPath $checksums -Force -ErrorAction SilentlyContinue }

$hash = Get-FileHash -Algorithm SHA256 -LiteralPath $bundle
[PSCustomObject]@{ Version = $Version; Package = $bundle; SHA256 = $hash.Hash; PluginSHA256 = $checksum }
