#!/bin/sh -e

DOMAIN=${DOMAIN:-www.example.com}
OUTPUT_DIR=/etc/nginx/certs
CA_DIR=/etc/nginx/ca

mkdir -p $OUTPUT_DIR $CA_DIR

# Generate the root CA if it doesn't exist
if [ ! -f ${CA_DIR}/rootCA.crt ]; then
    echo "CA Certificate not found. Generating self-signed CA certficiate..."

    openssl genrsa -out ${CA_DIR}/rootCA.key 2048
    openssl req -x509 -new -nodes \
            -key ${CA_DIR}/rootCA.key \
            -sha256 \
            -days 1024 \
            -subj "/C=US/ST=Denial/L=Springfield/O=DisRoot/CN=CompanyRoot" \
            -extensions v3_ca \
            -out ${CA_DIR}/rootCA.crt
fi

if [ ! -f ${OUTPUT_DIR}/key.pem ]; then

  echo "SSL Certificate not found. Generating self-CA-signed certficiate..."

  REPLACEABLE='$DOMAIN'
  envsubst $REPLACEABLE < /openssl.cnf.template > /openssl.cnf

  # Generate Subject Alternative Names if specified
  if [ ! -z "$ALT_NAMES" ]; then

    # The base domain is already #1 so $I starts at #2
    I=2
    for ALT_NAME in ${ALT_NAMES//,/ }; do
      echo "DNS.$(( I++ ))   = ${ALT_NAME}" >> /openssl.cnf
    done

  fi

  # Generate the certificate signing request
  openssl req -nodes \
    -newkey rsa:2048 \
    -keyout ${OUTPUT_DIR}/key.pem \
    -out ${OUTPUT_DIR}/csr.pem \
    -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=${DOMAIN}"

  # Sign the CSR with the CA key, creating the certificate
  openssl x509 -req \
    -in ${OUTPUT_DIR}/csr.pem \
    -CA ${CA_DIR}/rootCA.crt \
    -CAkey ${CA_DIR}/rootCA.key \
    -CAcreateserial \
    -days 825 \
    -extfile /openssl.cnf \
    -extensions v3_req \
    -out ${OUTPUT_DIR}/cert.pem

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
