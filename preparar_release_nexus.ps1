[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$SourceMod,

    [string]$OutputDirectory = (Join-Path $PSScriptRoot "release\CustomPlayerVoiceBR_v1.0.0"),

    [Int64]$ExpectedSpeechBytes = 1263663568,

    [switch]$CreateArchive
)

$ErrorActionPreference = "Stop"

$sourceModPath = (Resolve-Path -LiteralPath $SourceMod).Path
$sourceSpeech = Join-Path $sourceModPath "content\brpc.w3speech"
if (-not (Test-Path -LiteralPath $sourceSpeech -PathType Leaf)) {
    throw "brpc.w3speech não encontrado em: $sourceSpeech"
}

$sourceItem = Get-Item -LiteralPath $sourceSpeech
if ($sourceItem.Length -ne $ExpectedSpeechBytes) {
    $message = (
        "Tamanho inesperado do pacote: {0} bytes; esperado: {1}. " +
        "Confirme se esta é a versão testada."
    ) -f $sourceItem.Length, $ExpectedSpeechBytes
    throw $message
}

if (Test-Path -LiteralPath $OutputDirectory) {
    throw "A pasta de release já existe: $OutputDirectory"
}

$publicMod = Join-Path $OutputDirectory "modCustomPlayerVoiceBR"
$publicContent = Join-Path $publicMod "content"
New-Item -ItemType Directory -Path $publicContent | Out-Null
Copy-Item -LiteralPath $sourceSpeech -Destination $publicContent

$publicSpeech = Join-Path $publicContent "brpc.w3speech"
$copiedItem = Get-Item -LiteralPath $publicSpeech
if ($copiedItem.Length -ne $sourceItem.Length) {
    throw "A cópia final possui tamanho diferente da origem."
}

$sourceHash = (Get-FileHash -LiteralPath $sourceSpeech -Algorithm SHA256).Hash.ToLowerInvariant()
$publicHash = (Get-FileHash -LiteralPath $publicSpeech -Algorithm SHA256).Hash.ToLowerInvariant()
if ($sourceHash -ne $publicHash) {
    throw "O SHA-256 da cópia final é diferente da origem."
}

$hashFile = Join-Path $OutputDirectory "SHA256SUMS.txt"
Set-Content -LiteralPath $hashFile -Encoding ascii -Value (
    "$publicHash  modCustomPlayerVoiceBR/content/brpc.w3speech"
)

Write-Host "Release preparada e verificada." -ForegroundColor Green
Write-Host "Pasta: $OutputDirectory"
Write-Host "SHA-256: $publicHash"

if ($CreateArchive) {
    $candidates = @(
        "$env:ProgramFiles\7-Zip\7z.exe",
        "${env:ProgramFiles(x86)}\7-Zip\7z.exe"
    )
    $sevenZip = $candidates |
        Where-Object { $_ -and (Test-Path -LiteralPath $_ -PathType Leaf) } |
        Select-Object -First 1
    if (-not $sevenZip) {
        throw "7-Zip não encontrado. A pasta verificada foi preservada; compacte-a depois."
    }

    $archive = "$OutputDirectory.7z"
    if (Test-Path -LiteralPath $archive) {
        throw "O arquivo de release já existe: $archive"
    }
    Push-Location $OutputDirectory
    try {
        & $sevenZip a -t7z -mx=5 $archive ".\modCustomPlayerVoiceBR" ".\SHA256SUMS.txt"
        if ($LASTEXITCODE -ne 0) {
            throw "7-Zip terminou com código $LASTEXITCODE"
        }
    }
    finally {
        Pop-Location
    }
    Write-Host "Arquivo: $archive" -ForegroundColor Green
}
