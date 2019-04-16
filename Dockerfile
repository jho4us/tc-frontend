############################
# Multi stage build:
# 1. build app
############################
#FROM node:10 AS builder
FROM node@sha256:dbe1830d4a8b5ec8226b1cb4a760f9e53696130f76bd4c2e5785e13eba19993b AS builder

WORKDIR /usr/src/app

COPY src/package*.json ./
RUN npm install npm@latest -g
RUN npm install

COPY src .
RUN npm run build

############################
# 2. build small image
############################
#FROM debian:stretch-slim
FROM debian@sha256:bade11bf1835c9f09b011b5b1cf9f7428328416410b238d2f937966ea820be74

RUN apt-get update && apt-get install -y \
    nginx \
    && rm -rf /var/lib/apt/lists/*

COPY site.conf /etc/nginx/sites-available
RUN ln -s /etc/nginx/sites-available/site.conf /etc/nginx/sites-enabled

COPY startup.sh /home/
RUN chmod 777 /home/startup.sh
COPY --from=builder /usr/src/app/dist /home/html/

CMD ["bash","/home/startup.sh"]
EXPOSE 3000

