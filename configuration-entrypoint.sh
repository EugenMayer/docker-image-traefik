#!/usr/bin/env bash

set -e

function log {
        echo `date` $ME - $@
}

if [ ! -f /mnt/certs/ssl.key ];  then
    log "[ Generating certificates ]"
    generate-ssl-certificate.sh 127.0.0.1 /mnt/certs
fi

if [ -n "{TRAEFIK_ADMIN_AUTH_USERS}" ];  then
    log "[ Popuplating basic auth users ]"
    echo ${TRAEFIK_ADMIN_AUTH_USERS} > "/etc/traefik/.htpasswd"
fi

if [ -n "${TRAEFIK_ACME_CHALLENGE_DNS_CREDENTIALS}" ]; then
    log "[ Popuplating acme credentials ]"
    export_acme_credentials_to_env_file.sh ${TRAEFIK_ACME_CHALLENGE_DNS_CREDENTIALS} /etc/traefik/acme_credentials
    . /etc/traefik/acme_credentials
    echo $CLOUDFLARE_EMAIL
fi

log "[ Generating Traefik configuration to /etc/traefik/traefik.toml ... ]"
tiller -e production

log "[ Redirecting Traefik logs to docker logs ]"
rm -f ${TRAEFIK_LOG_FILE} ${TRAEFIK_ACCESS_FILE}
ln -sf /proc/1/fd/1 ${TRAEFIK_LOG_FILE}
ln -sf /proc/1/fd/1 ${TRAEFIK_ACCESS_FILE}

log "[ Starting Traefik... ]"
echo ${CLOUDFLARE_EMAIL}
echo ${CLOUDFLARE_API_KEY}
# forwarding to the base entrypoint
exec ./entrypoint.sh "$@"
