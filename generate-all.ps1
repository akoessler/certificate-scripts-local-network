
Write-Host ""
Write-Host "Warning! This will overwrite all previous generated certificates!" -ForegroundColor Red
Write-Host ""


$title    = 'Confirm overwrite'
$question = 'Re-generate ROOT certificates? They need to be re-installed on all machines to trust the certificates!'
$choices  = '&Yes', '&No'

$decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
if ($decision -eq 0) {
    Write-Host ""
    Write-Host 'Your choice is Yes.'
    Write-Host 'Re-generaring and overwriting root certificates.' -ForegroundColor Red
    Write-Host ""
    Write-Host "Waiting 10 seconds as a last chance to abort (CTRL+C) overwriting the root certificates ..."

    $seconds = 10
    while ($seconds -gt 0) {
        Write-Host $seconds
        Start-Sleep -Seconds 1
        $seconds--
    }


    # generate root CA

    $directory="./root"
    $command = "./generate-root-ca.ps1"
    $generateScriptPath="$directory/$command"

    Set-Location $directory
    Write-Host ""
    Write-Host "$generateScriptPath"
    Write-Host ""
    Invoke-Expression $generateScriptPath
    Set-Location $PSScriptRoot


    # generate intermediate CA

    $directory="./intermediate"
    $command = "./generate-intermediate-ca.ps1"
    $generateScriptPath="$directory/$command"

    Set-Location $directory
    Write-Host ""
    Write-Host "$generateScriptPath"
    Write-Host ""
    Invoke-Expression $generateScriptPath
    Set-Location $PSScriptRoot
}


# generate all server certificates

$command = "generate-cert.ps1"

Get-ChildItem "$PSScriptRoot/server" -Directory | ForEach-Object {
    $directory=$_.FullName
    $generateScriptPath="$directory/$command"
    if (Test-Path -Path "$generateScriptPath" -PathType Leaf) {

        Set-Location $_.FullName
        Write-Host ""
        Write-Host "$generateScriptPath"
        Write-Host ""
        Invoke-Expression $generateScriptPath
        Set-Location $PSScriptRoot

    }
}
