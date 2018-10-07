#!/usr/bin/env bash

set -e
# we need that so our ACME provider variables are passed to the ENv when starting with exec ./entrypoint.sh "$@"
set -o allexport

TRAEFIK_LOG_FILE=${TRAEFIK_LOG_FILE:-"/var/log/traefik.log"}
TRAEFIK_ACCESS_FILE=${TRAEFIK_ACCESS_FILE:-"/var/log/traefik.access.log"}

function log {
        echo `date` $ME - $@
}

if [ ! -f /mnt/certs/ssl.key ]; then
    log "[ Generating certificates ]"
    generate-ssl-certificate.sh 127.0.0.1 /mnt/certs
fi

log "[ Generating Traefik configuration to /etc/traefik/traefik.toml ... ]"
# this also generated /etc/traefik/acme_credentials if credentials are set
tiller -e production

log "[ Redirecting Traefik logs to docker logs ]"
rm -f ${TRAEFIK_LOG_FILE} ${TRAEFIK_ACCESS_FILE}
ln -sf /proc/1/fd/1 ${TRAEFIK_LOG_FILE}
ln -sf /proc/1/fd/1 ${TRAEFIK_ACCESS_FILE}

if [ -n "${TRAEFIK_ACME_CHALLENGE_DNS_CREDENTIALS}" ]; then
    log "[ Popuplating acme credentials ]"
    source /etc/traefik/acme_credentials
fi

log "[ Starting Traefik... ]"

# forwarding to the base entrypoint
exec ./entrypoint.sh "$@"
