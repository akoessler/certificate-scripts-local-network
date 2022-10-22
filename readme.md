
# Certificate scripts

Scripts to create certificates for my local network.

The scripts include:
* root CA
* intermediate CA
* Certificates for servers/devices:
  * cloudkey (unifi)
  * pihole
  * nas (synology)

# How to use

## Configure
Configure the cfg files for all levels.

Add a folder for each server/device/application a certificate shall be created for, and adjust the cfg file.

## Generate certificates

Run the generate scripts.
* root and intermediate folder each have a script to generate the CA certificates
* each server folder has its own `generate-cert.ps1` script
* on root level there is a `generate-all.ps1` script which runs all of them (with a choice whether to overwrite root/intermediate)

The scripts will generate:
* a key file in subfolder `private`
* a csr signing request in subfolder `generated`
* the certificate in subfolder `cert`
  * including a p12 bundle with private key
  * including a full-chain bundle

**Attention!**

Run the generation for root and intermediate only once! Do not overwrite them, unless you really want a new CA certificate!

## Note

The certificate files are PEM-encoded - if the *.crt file cannot be used with an application, the extension can simply be changed to *.pem
