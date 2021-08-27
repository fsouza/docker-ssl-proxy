FROM alpine:3.14.2

ENV SSL_PORT=443

RUN apk add --no-cache nginx openssl gettext

ADD add_self_signed_certs.sh /
ADD openssl.cnf.template /
ADD nginx.conf.template /
ADD configure_and_start.sh /

EXPOSE ${SSL_PORT}

ENTRYPOINT ["/configure_and_start.sh"]
