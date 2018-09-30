#!/usr/bin/env bash

# we use bash due to the more robust splitting mechanism

SERIALIZED_CREDENTIALS=${1:-""}
DEST_ENV_FILE=${2-/etc/traefik/acme_credentials}

IFS=';' read -a ARRAY <<< "${SERIALIZED_CREDENTIALS}"

touch ${DEST_ENV_FILE}
for item in ${ARRAY[@]}; do
  printf "export ${item}\n" >> $DEST_ENV_FILE
done