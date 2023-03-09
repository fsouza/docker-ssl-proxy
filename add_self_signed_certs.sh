#!/bin/sh -e

DOMAIN=${DOMAIN:-www.example.com}
OUTPUT_DIR=/etc/nginx/certs

mkdir -p $OUTPUT_DIR

REPLACEABLE='$DOMAIN'

envsubst $REPLACEABLE < /openssl.cnf.template > /openssl.cnf

if [ ! -f ${OUTPUT_DIR}/key.pem ]; then
  echo "SSL Certificate not found. Generating self-signed certficiate..."

  # Generate subject alternative names if specified
  if [ ! -z "$ALT_NAMES" ]; then

    # Remove errant spaces
    ALT_NAMES="${ALT_NAMES// /}"

    # The base domain is already #1 so $I starts at #2
    I=2
    for ALT_NAME in ${ALT_NAMES//,/ }; do
      echo "DNS.$(( I++ ))   = ${ALT_NAME}" >> /openssl.cnf
    done

  fi

    # Generate the certificate
    openssl req -x509 -nodes \
      -newkey rsa:2048 \
      -keyout ${OUTPUT_DIR}/key.pem \
      -out ${OUTPUT_DIR}/cert.pem \
      -days 825 \
      -config /openssl.cnf \
      -extensions v3_req \
      -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=${DOMAIN}"
fi
