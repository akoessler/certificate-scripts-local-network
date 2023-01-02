
# Install certificate to Unifi Cloud Key

## This guide worked for me

https://community.spiceworks.com/how_to/128281-use-lets-encrypt-ssl-certs-with-unifi-cloud-key

## Other guides (did not fully work)

https://www.ssldragon.com/blog/install-ssl-certificate-on-unifi-cloud-key/

https://www.c0ffee.net/blog/unifi-cloud-key-ssl-certificate/

https://scotthelme.co.uk/setting-up-https-on-the-unifi-cloudkey/

## Folders

/usr/lib/unifi/data
/usr/lib/ssl/private

## Steps

### Stop services

service nginx stop
service unifi stop

### Upload cert and key

Upload files to /usr/lib/ssl/private
* akoessler-cloudkey.key
* akoessler-cloudkey.crt
* akoessler-cloudkey.jks
* akoessler-cloudkey.p12
* akoessler-cloudkey-bundle.ca-bundle.crt

### Import to keystore

sudo openssl pkcs12 -export -inkey akoessler-cloudkey.key -in akoessler-cloudkey-bundle.ca-bundle.crt -out cert.p12 -name ubnt -password pass:temppass

sudo keytool -importkeystore -deststorepass aircontrolenterprise -destkeypass aircontrolenterprise -destkeystore /usr/lib/unifi/data/keystore -srckeystore cert.p12 -srcstoretype PKCS12 -srcstorepass temppass -alias ubnt -noprompt

### Start services

service unifi start
service nginx start
