FROM alpine

RUN apk update && apk add nginx openssl gettext

ADD add_self_signed_certs.sh /
ADD nginx.conf.template /
ADD configure_nginx.sh /

ENTRYPOINT ["/configure_nginx.sh"]
