
# Install certificate to pi hole

https://discourse.pi-hole.net/t/enabling-https-for-your-pi-hole-web-interface/5771

## Create combined.pem:

e.g. in: /usr/cert
cat akoessler-pihole.key akoessler-pihole.crt tee combined.pem

## Create fullchain.pem:

e.g. in: /usr/cert
copy akoessler-pihole-bundle.ca-bundle.crt fullchain.pem

## Configure lighttpd

/etc/lighttpd/external.conf

```
# enable https
$HTTP["host"] == "pi.hole" {
  # Ensure the Pi-hole Block Page knows that this is not a blocked domain
  setenv.add-environment = ("fqdn" => "true")

  # Enable the SSL engine with a LE cert, only for this specific host
  $SERVER["socket"] == ":443" {
    ssl.engine = "enable"
    ssl.pemfile = "/usr/cert/combined.pem"
    ssl.ca-file =  "/usr/cert/fullchain.pem"
    ssl.honor-cipher-order = "enable"
    ssl.cipher-list = "EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH"
    ssl.use-sslv2 = "disable"
    ssl.use-sslv3 = "disable"
  }

  # Redirect HTTP to HTTPS
  $HTTP["scheme"] == "http" {
    $HTTP["host"] =~ ".*" {
      url.redirect = (".*" => "https://%0$0")
    }
  }
}

# enable https
$HTTP["host"] == "pihole.akoessler.local" {
  # Ensure the Pi-hole Block Page knows that this is not a blocked domain
  setenv.add-environment = ("fqdn" => "true")

  # Enable the SSL engine with a LE cert, only for this specific host
  $SERVER["socket"] == ":443" {
    ssl.engine = "enable"
    ssl.pemfile = "/usr/cert/combined.pem"
    ssl.ca-file =  "/usr/cert/fullchain.pem"
    ssl.honor-cipher-order = "enable"
    ssl.cipher-list = "EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH"
    ssl.use-sslv2 = "disable"
    ssl.use-sslv3 = "disable"
  }

  # Redirect HTTP to HTTPS
  $HTTP["scheme"] == "http" {
    $HTTP["host"] =~ ".*" {
      url.redirect = (".*" => "https://%0$0")
    }
  }
}
```

## Restart:

sudo service lighttpd restart
