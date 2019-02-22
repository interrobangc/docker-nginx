#!/usr/bin/env sh

if [ -s /etc/ssl/ssl.crt ] || [ -s /etc/ssl/key.pem ] || [ -n "${SKIP_SSL_GENERATE}" ]; then
    echo "Skipping SSL certificate generation"
else
    echo "Generating self-signed certificate"

    mkdir -p /etc/ssl
    cd /etc/ssl

    openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out key.pem

    cp key.pem key.pem.orig

    openssl rsa -passin pass:x -in key.pem.orig -out key.pem

    openssl req -new -key key.pem -out cert.csr -subj "/C=US/ST=NC/L=Mars Hill/O=Interrobang Consulting/OU=www/CN=interrobang.consulting"

    openssl x509 -req -days 3650 -in cert.csr -signkey key.pem -out cert.pem
fi