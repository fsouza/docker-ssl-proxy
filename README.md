# docker-ssl-proxy

Builds a basic nginx server that proxies incoming SSL calls to a target host
(usually another Docker container).

## Environment variables

The following environment variables configure nginx:

- ``DOMAIN``: domain in the SSL certificate (default value: ``www.example.com``)
- ``PORT``: port to bind nginx (default value: ``443``)
- ``TARGET_PORT``: target port for the reverse proxy (default value: ``80``)
- ``TARGET_HOST``: target host for the reverse proxy (default value: ``proxyapp``)

## Certificates location

A self-signed certificate is generated at ``/etc/nginx/certs``, you may use
Docker volumes to share the certificate with other containers.

## Docker Hub Image

You can get the publicly available docker image at the following location:
[Docker Hub -
SSL-Proxy](https://registry.hub.docker.com/u/fsouza/docker-ssl-proxy/).
