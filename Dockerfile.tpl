# This file is not used in the default configuration and can safely be deleted.
# It is provided in case you want to modify the build environment. 

FROM node:10.16.0-alpine
USER node

RUN mkdir -p /home/node
VOLUME /home/node

WORKDIR /home/node

# Uncomment this next line to install imagemagick into your container
# RUN apk add imagemagick
