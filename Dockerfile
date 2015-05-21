############################################################
# Dockerfile to build Nginx Installed Containers
# Based on Ubuntu
############################################################

# Set the base image to Ubuntu
FROM ubuntu

# Install Nginx

# Update the repository
RUN apt-get update

# Install necessary tools
RUN apt-get install -y nano wget dialog net-tools

# Download and Install Nginx
RUN apt-get install -y nginx

# Remove the default Nginx configuration file
RUN rm -v /etc/nginx/nginx.conf

# Copy a configuration file from the current directory
ADD add_self_signed_certs.sh /
ADD nginx.conf.template /
ADD configure_nginx.sh /

# Create the self signed certs
RUN sh /add_self_signed_certs.sh

# Set the default command to execute
# when creating a new container
CMD ["sh", "configure_nginx.sh"]
