
$rootCfg="akoessler-root-ca.cfg"
$rootCrt="cert/akoessler-root-ca.crt"
$rootKey="private/akoessler-root-ca.key"


# header

Write-Host ""
Write-Host "Create root CA" -ForegroundColor Magenta
Write-Host ""


# create key

Write-Host ""
Write-Host "Create key and certificate" -ForegroundColor Cyan
Write-Host "* cfg: $rootCfg" -ForegroundColor DarkYellow
Write-Host "* crt: $rootCrt" -ForegroundColor DarkYellow
Write-Host "* key: $rootKey" -ForegroundColor DarkYellow
$Command = "openssl req -newkey rsa:4096 -nodes -keyout ""$rootKey"" -x509 -days 3650 -out ""$rootCrt"" -config ""$rootCfg"""
Write-Host ""
Write-Host $Command -ForegroundColor DarkGray
Write-Host ""
Invoke-Expression $Command


# end

Write-Host ""
Write-Host "Finished root CA." -ForegroundColor Green
Write-Host ""
