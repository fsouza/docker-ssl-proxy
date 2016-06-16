############################################################
# Dockerfile to build Nginx Installed Containers
# Based on Ubuntu
############################################################
# Set the base image to Ubuntu
FROM alpine

# Install Nginx

# Update the repository
RUN apk update && apk add nginx openssl gettext

# Copy a configuration file from the current directory
ADD add_self_signed_certs.sh /
ADD nginx.conf.template /
ADD configure_nginx.sh /

# Set the default command to execute
# when creating a new container
ENTRYPOINT ["/configure_nginx.sh"]
