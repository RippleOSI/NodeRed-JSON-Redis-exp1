# set the base image to Debian
# https://hub.docker.com/_/debian/
FROM ubuntu:latest

# update and install all required packages (no sudo required as root)
# https://gist.github.com/isaacs/579814#file-only-git-all-the-way-sh
RUN apt-get update -yq && apt-get upgrade -yq && \
 apt-get install -yq curl git nano

# install from nodesource using apt-get
# https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-an-ubuntu-14-04-server
RUN curl -sL https://deb.nodesource.com/setup
RUN apt-get install -yq nodejs build-essential
RUN apt-get install npm -y

# confirm installation
RUN node -v
RUN npm -v

RUN npm install -g node-red
RUN npm install -g node-red-contrib-redis
RUN apt-get install redis-server -y
RUN mkdir -p /usr/local/etc/redis
COPY redis.conf /usr/local/etc/redis/redis.conf
COPY start.sh /usr/local/bin/start.sh
CMD /usr/local/bin/start.sh