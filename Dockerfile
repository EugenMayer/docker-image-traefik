ARG TRAEFIK_VERSION=2.8
FROM traefik:$TRAEFIK_VERSION
MAINTAINER Eugen Mayer <eugen.mayer@kontextwork.de>
LABEL org.opencontainers.image.source https://github.com/eugenmayer/docker-image-traefik

ADD bin/ /usr/local/bin/
ADD configuration-entrypoint.sh /configuration-entrypoint.sh
RUN mkdir -p /etc/traefik /mnt/acme /mnt/filestorage /mnt/certs /usr/local/bin /etc/tiller \
 && apk --update add bash ruby openssl \
 && chmod +x /usr/local/bin/*.sh /configuration-entrypoint.sh \
 # we use tiller for generating our configuration
 # we use json_pure so we do not need compile tools for the native C extension
 && gem install --no-document specific_install json_pure \
 # use our fork of tiller for ruby 3.x support
 && gem specific_install https://github.com/EugenMayer/tiller

# tiller templates
ADD tiller/ /etc/tiller/

# volume to put your own certificates on and also our generated one (/mnt/certs/ssl.key | /mnt/certs/ssl.crt)
# will also include /mnt/certs/docker.ca.crt | /mnt/certs/docker.crt |/mnt/certs/docker.key if you use remote swarm
VOLUME /mnt/certs
# will hold your custom file-based provider rules under /mnt/filestorage/rules.toml
VOLUME /mnt/filestorage
# will hold /mnt/acme/acme.json which are all your certificates you gathered using ACME
VOLUME /mnt/acme

# we are chaning the default entrypoint to proxy our configuration before we start traefik using the official
# /entrypoint.sh right at the end.
ENTRYPOINT ["/configuration-entrypoint.sh"]
CMD ["traefik"]
