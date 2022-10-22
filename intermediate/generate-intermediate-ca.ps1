
$intermediateCfg="akoessler-intermediate.cfg"
$intermediateKey="private/akoessler-intermediate.key"
$intermediateCsr="generated/akoessler-intermediate.csr"
$intermediateCrt="cert/akoessler-intermediate.crt"
$intermediateP12="cert/akoessler-intermediate.p12"
$intermediateBundle="cert/akoessler-intermediate.ca-bundle.crt"

$rootCrt="../root/cert/akoessler-root-ca.crt"
$rootKey="../root/private/akoessler-root-ca.key"


# header

Write-Host ""
Write-Host "Create intermediate CA" -ForegroundColor Magenta
Write-Host ""


# create key

Write-Host ""
Write-Host "Create key and cert request" -ForegroundColor Cyan
Write-Host "* cfg: $intermediateCfg" -ForegroundColor DarkYellow
Write-Host "* csr: $intermediateCsr" -ForegroundColor DarkYellow
Write-Host "* key: $intermediateKey" -ForegroundColor DarkYellow
$Command = "openssl req -newkey rsa:4096 -nodes -keyout ""$intermediateKey"" -out ""$intermediateCsr"" -config ""$intermediateCfg"""
Write-Host ""
Write-Host $Command -ForegroundColor DarkGray
Write-Host ""
Invoke-Expression $Command


# create cert

Write-Host ""
Write-Host "Create certificate" -ForegroundColor Cyan
Write-Host "* csr: $intermediateCsr" -ForegroundColor DarkYellow
$Command = "openssl x509 -req -in ""$intermediateCsr"" -CA ""$rootCrt"" -CAkey ""$rootKey"" -CAcreateserial -out ""$intermediateCrt"" -days 3000 -sha256 -extensions extensions -extfile ""$intermediateCfg"""
Write-Host ""
Write-Host $Command -ForegroundColor DarkGray
Write-Host ""
Invoke-Expression $Command


# create p12

Write-Host ""
Write-Host "Create p12 bundle" -ForegroundColor Cyan
Write-Host "* p12: $intermediateP12" -ForegroundColor DarkYellow
$Command = "openssl pkcs12 -inkey ""$intermediateKey"" -in ""$intermediateCrt"" -export -out ""$intermediateP12"""
Write-Host ""
Write-Host $Command -ForegroundColor DarkGray
Write-Host ""
Invoke-Expression $Command


# create bundle

Write-Host ""
Write-Host "Create cert bundle" -ForegroundColor Cyan
Write-Host "* bundle: $intermediateBundle" -ForegroundColor DarkYellow
$Command = "Get-ChildItem ""$intermediateCrt"", ""$rootCrt"" | Get-Content | Out-File ""$intermediateBundle"""
Write-Host ""
Write-Host $Command -ForegroundColor DarkGray
Write-Host ""
Invoke-Expression $Command


# end

Write-Host ""
Write-Host "Finished intermediate CA." -ForegroundColor Green
Write-Host ""
