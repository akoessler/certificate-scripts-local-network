
param ($certname, $hostnameToVerify)

if ([String]::IsNullOrEmpty($certname)) {
    Write-Host "certname not set! Aborting."
    exit 1
}

if ([String]::IsNullOrEmpty($hostnameToVerify)) {
    Write-Host "hostnameToVerify not set! Aborting."
    exit 1
}

$serverCfg="$certname.cfg"
$serverKey="private/$certname.key"
$serverCsr="generated/$certname.csr"
$serverCrt="cert/$certname.crt"
$serverP12="cert/$certname.p12"
$serverP8="cert/$certname.p8"
$serverBundle="cert/$certname-bundle.ca-bundle.crt"

$intermediateKey="../../intermediate/private/akoessler-intermediate.key"
$intermediateCrt="../../intermediate/cert/akoessler-intermediate.crt"
$intermediateBundle="../../intermediate/cert/akoessler-intermediate.ca-bundle.crt"

$rootCrt="../../root/cert/akoessler-root-ca.crt"


# header

Write-Host ""
Write-Host "Create certificate for: $certname" -ForegroundColor Magenta
Write-Host ""


# create key

Write-Host ""
Write-Host "Create key and cert request" -ForegroundColor Cyan
Write-Host "* cfg: $serverCfg" -ForegroundColor DarkYellow
Write-Host "* csr: $serverCsr" -ForegroundColor DarkYellow
Write-Host "* key: $serverKey" -ForegroundColor DarkYellow
Write-Host ""
$Command="openssl req -newkey rsa:4096 -nodes -keyout ""$serverKey"" -out ""$serverCsr"" -config ""$serverCfg"""
Write-Host ""
Write-Host $Command -ForegroundColor DarkGray
Write-Host ""
Invoke-Expression $Command


# create cert

Write-Host ""
Write-Host "Create certificate" -ForegroundColor Cyan
Write-Host "* crt: $serverCrt" -ForegroundColor DarkYellow
Write-Host ""
$Command="openssl x509 -req -in ""$serverCsr"" -CA ""$intermediateCrt"" -CAkey ""$intermediateKey"" -CAcreateserial -out ""$serverCrt"" -days 365 -sha256 -extensions extensions -extfile ""$serverCfg"""
Write-Host ""
Write-Host $Command -ForegroundColor DarkGray
Write-Host ""
Invoke-Expression $Command


# create p8

Write-Host ""
Write-Host "Create p8 bundle" -ForegroundColor Cyan
Write-Host "* p12: $serverP12" -ForegroundColor DarkYellow
Write-Host ""
$Command="openssl pkcs8 -inkey ""$serverKey"" -in ""$serverCrt"" -export -out ""$serverP8"" -CAfile ""$intermediateCrt"" -name ""$certname"" -caname ""intermediate"""
Write-Host ""
Write-Host $Command -ForegroundColor DarkGray
Write-Host ""
Invoke-Expression $Command


# create p12

Write-Host ""
Write-Host "Create p12 bundle" -ForegroundColor Cyan
Write-Host "* p12: $serverP12" -ForegroundColor DarkYellow
Write-Host ""
$Command="openssl pkcs12 -inkey ""$serverKey"" -in ""$serverCrt"" -export -out ""$serverP12"" -CAfile ""$intermediateCrt"" -name ""$certname"" -caname ""intermediate"""
Write-Host ""
Write-Host $Command -ForegroundColor DarkGray
Write-Host ""
Invoke-Expression $Command


# create bundle

Write-Host ""
Write-Host "Create crt bundle" -ForegroundColor Cyan
Write-Host "* bundle: $serverBundle" -ForegroundColor DarkYellow
Write-Host ""
$Command="Get-ChildItem ""$serverCrt"", ""$intermediateCrt"", ""$rootCrt"" | Get-Content | Out-File ""$serverBundle"""
Write-Host ""
Write-Host $Command -ForegroundColor DarkGray
Write-Host ""
Invoke-Expression $Command


# verify

Write-Host ""
Write-Host "Verify certificate for: $hostnameToVerify" -ForegroundColor Cyan
Write-Host ""
$Command="openssl verify -CAfile ""$intermediateBundle"" -verify_hostname ""$hostnameToVerify"" ""$serverCrt"""
Write-Host ""
Write-Host $Command -ForegroundColor DarkGray
Write-Host ""
Invoke-Expression $Command


# end

Write-Host ""
Write-Host "Finished $certname." -ForegroundColor Green
Write-Host ""
