# docker-ssl-proxy

Builds a basic nginx server that proxies incoming SSL calls to a target host
(usually another Docker container).

## Environment variables

The following environment variables configure nginx and openssl:

- ``DOMAIN``: domain in the SSL certificate (default value: ``www.example.com``)
- ``ALT_NAMES``: optional comma-separated list of alternative domain names (e.g: ``example.net,example.tv``)
- ``TARGET_PORT``: target port for the reverse proxy (default value: ``80``)
- ``TARGET_HOST``: target host for the reverse proxy (default value: ``proxyapp``)
- ``TARGET_HOST_HEADER``: value to be used as the Host header when sending
  requests to the target host (defaults to the value of ``$TARGET_HOST``)
- ``CLIENT_MAX_BODY_SIZE``: maximum size of client uploads (default value: ``20M``)
- ``SSL_PORT``: port ngnix SSL proxy listens on

## Certificates and CA location

The SSL certificate is generated using a own-ROOT-ca that is available in the
directory ``/etc/nginx/ca``, you may use Docker volumes to share the CAs with
other containers, so they can trust the installed certificate.

You can also install the shared CA cert on your workstation to automatically
trust all of your docker-ssl-proxy services in your browser, without having
to override security warnings each time you visit or restart the services.

It may be wise if using a shared CA volume with multiple docker-ssl-proxys
to let one finish initializing before the others; to avoid a conceivable race
condition where they write over each others' CA keys. Pick any proxy instance
and make the others ``depends_on`` it.

## Using own Certificate

You can use existing SSL certificates for your ``DOMAIN``
by connecting an volume onto ``/etc/nginx/certs`` with following files inside:

- ``key.pem``: private key file
- ``cert.pem``: certificate file

The certificate generator will check on existing ``key.pem`` and abort.

## Docker Hub Image

You can get the publicly available docker image at
[fsouza/docker-ssl-proxy](https://registry.hub.docker.com/r/fsouza/docker-ssl-proxy/).
