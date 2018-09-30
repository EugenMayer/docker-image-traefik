FROM traefik:1.7-alpine
MAINTAINER Eugen Mayer <eugen.mayer@kontextwork.de>

ADD bin/ /usr/local/bin/
ADD configuration-entrypoint.sh /configuration-entrypoint.sh
RUN mkdir -p /etc/traefik /mnt/acme /mnt/filestorage /mnt/certs /usr/local/bin /etc/tiller \
 && apk --update add bash ruby openssl \
 && chmod +x /usr/local/bin/*.sh /configuration-entrypoint.sh \
 # we use json_pure so we do not need compile tools for the native C extension
 && gem install tiller json_pure --no-ri

ADD tiller/ /etc/tiller/

# volume to put your own certificates on and also our generated one (/mnt/certs/ssl.key | /mnt/certs/ssl.crt)
VOLUME /mnt/certs
VOLUME /mnt/filestorage
VOLUME /mnt/acme

ENTRYPOINT ["/configuration-entrypoint.sh"]

