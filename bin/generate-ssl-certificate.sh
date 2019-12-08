#!/usr/bin/env bash

### by system-configuration

set -e

if [ -z "$1" ]; then
    echo "please pass the ip or hostname as the first parameter"
    exit 1
fi


if [ -z "$2" ]; then
    echo "please pass the destination folder as secon parameter"
    exit 1
fi

ip=$1
# Specify where we will install
# the xip.io certificate
SSL_DIR=$2

# A blank passphrase
PASSPHRASE=""

# Set our CSR variables
SUBJ="
C=DE
ST=Niedersachsen
O=Traefik
localityName=Hannover
commonName=$ip
organizationalUnitName=Traefik
emailAddress=info@traefikrancher.local
"

# Create our SSL directory
# in case it doesn't exist
mkdir -p "$SSL_DIR"

# Generate our Private Key, CSR and Certificate
openssl genrsa -out "$SSL_DIR/ssl.key" 2048
openssl req -new -subj "$(echo -n "$SUBJ" | tr "\n" "/")" -key "$SSL_DIR/ssl.key" -out "$SSL_DIR/ssl.csr" -passin pass:$PASSPHRASE
openssl x509 -req -days 1825 -in "$SSL_DIR/ssl.csr" -signkey "$SSL_DIR/ssl.key" -out "$SSL_DIR/ssl.crt"

chown root:root $SSL_DIR/ssl.key
chmod 400 $SSL_DIR/ssl.key
chown root:root $SSL_DIR/ssl.crt