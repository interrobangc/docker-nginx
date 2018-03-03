#!/usr/bin/env sh

if [ -f /etc/ssl/cert.pem && -f /etc/ssl/key.pem ] || [ "${SKIP_SSL_GENERATE}" ]; then
    echo "Skipping SSL certificate generation"
else
    echo "Generating self-signed certificate"

    mkdir -p /etc/ssl
    cd /etc/ssl

    openssl genrsa -des3 -passout pass:x -out key.pem ${SSL_KEY_LENGTH:-2048}

    cp key.pem key.pem.orig

    openssl rsa -passin pass:x -in key.pem.orig -out key.pem

    openssl req -new -key key.pem -out cert.csr -subj "/C=${SSL_C:-US}/ST=${SSL_ST:-NC}/L=${SSL_L:-Mars Hill}/O=${SSL_O:-Interrobang Consulting}/OU=${SSL_OU:-www}/CN=${SSL_CN:-interrobang.consulting}"

    openssl x509 -req -days ${SSL_DAYS:-3650} -in cert.csr -signkey key.pem -out cert.pem
fi

if [ ! -f /.cloudflare_purged ] && [ -n "$CLOUDFLARE_KEY" ] && [ "$CLOUDFLARE_KEY" != "" ]; then
    if [ -n "$CLOUDFLARE_EMAIL" ] && [ "$CLOUDFLARE_EMAIL" != "" ]; then
        if [ -n "$CLOUDFLARE_PURGE_ALL" ] && [ "$CLOUDFLARE_PURGE_ALL" != "" ]; then
            echo "purging entire cloudflare cache..."
            curl -o - -s -w "%{http_code}\n" -X DELETE \
                "https://api.cloudflare.com/client/v4/zones/${CLOUDFLARE_ZONE}/purge_cache" \
                -H "X-Auth-Email: ${CLOUDFLARE_EMAIL}" \
                -H "X-Auth-Key: ${CLOUDFLARE_KEY}" \
                -H "Content-Type: application/json" \
                --data '{"purge_everything":true}' \

            touch /.cloudflare_purged

        elif [ -n "$CLOUDFLARE_CLEAR_CACHE_URLS" ] && [ "$CLOUDFLARE_CLEAR_CACHE_URLS" != "" ]; then
            echo "purging cloudflare cache for ${CLOUDFLARE_CLEAR_CACHE_URLS}..."
            curl -o - -s -w "%{http_code}\n" -X DELETE \
                "https://api.cloudflare.com/client/v4/zones/${CLOUDFLARE_ZONE}/purge_cache" \
                -H "X-Auth-Email: ${CLOUDFLARE_EMAIL}" \
                -H "X-Auth-Key: ${CLOUDFLARE_KEY}" \
                -H "Content-Type: application/json" \
                --data "{\"files\":${CLOUDFLARE_CLEAR_CACHE_URLS}}"

            touch /.cloudflare_purged

        else
            echo "CLOUDFLARE_PURGE_ALL or CLOUDFLARE_CLEAR_CACHE_URLS must be set to purge cache... skipping."
        fi
    else
        echo "Found CLOUDFLARE_KEY without CLOUDFLARE_EMAIL. Both are required... not attempting cloudflare purge cache"
    fi
else
    echo "Skipping cloudflare cache purge"
fi

exec "$@"