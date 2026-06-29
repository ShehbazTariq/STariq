param(
    [string]$Source = "cv\CV_Shehbaz.tex",
    [string]$Output = "files\cv.pdf"
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$sourcePath = Join-Path $repoRoot $Source
$outputPath = Join-Path $repoRoot $Output
$sourceDir = Split-Path -Parent $sourcePath
$sourceFile = Split-Path -Leaf $sourcePath
$pdfName = [IO.Path]::ChangeExtension($sourceFile, ".pdf")
$builtPdf = Join-Path $sourceDir $pdfName

if (-not (Test-Path -LiteralPath $sourcePath)) {
    throw "CV source not found: $sourcePath"
}

Push-Location -LiteralPath $sourceDir
try {
    pdflatex -interaction=nonstopmode -halt-on-error $sourceFile
    pdflatex -interaction=nonstopmode -halt-on-error $sourceFile
}
finally {
    Pop-Location
}

New-Item -ItemType Directory -Force -Path (Split-Path -Parent $outputPath) | Out-Null
Copy-Item -LiteralPath $builtPdf -Destination $outputPath -Force
Write-Host "Updated $Output from $Source"
