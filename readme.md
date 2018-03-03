# interrobangc/nginx

This is an nginx docker image that adds some features to [nginx:alpine](https://store.docker.com/images/nginx).


## SSL

A self signed ssl certificate will be generate on startup unless the environmental variable `SKIP_SSL_GENERATE` is set or any of the following files exist:

* `/etc/ssl/cert.pem`
* `/etc/ssl/key.pem`


### SSL ENV Variables

* **SSL_KEY_LENGTH** (Default: `2048`) - Length of SSL key.

* **SSL_C** (Default: `US`) - Country

* **SSL_ST** (Default: `NC`) - State

* **SSL_L** (Default: `Mars Hill`) - Locality

* **SSL_O** (Default: `Interrobang Consulting`) - Organization Name

* **SSL_OU** (Default: `www`) - Organizational Unit Name

* **SSL_CN** (Default: `interrobang.consulting`) - Common Name

* **SSL_DAYS** (Default: `3650`) - Days until generated certificate expires


## Clear Cloudflare Cache

When the proper environmental variables are set, this image will handle purging cloudflare cache. It will only purge on initial startup, not on every restart of the container.


### Cloudflare Cache ENV Variables

* **CLOUDFLARE_KEY** (Required) - User's cloudflare API key

* **CLOUDFLARE_EMAIL** (Required) - User's cloudflare email

* **CLOUDFLARE_ZONE** (Required) - Cloudflare zone to act on

* **CLOUDFLARE_PURGE_ALL** - Purge all cache

* **CLOUDFLARE_CLEAR_CACHE_URLS** - list of urls to clear. This should be a json representation as defined in [the cloudflare documentation](https://api.cloudflare.com/#zone-purge-individual-files-by-url).
