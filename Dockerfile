# TODO: add serve stage/Dockerfile with live-reload
# TODO: use volume for ng serve

FROM node:10-alpine AS node
FROM nginx:stable-alpine AS nginx
# FROM zenika/alpine-chrome:with-node AS node-chrome

# based on https://github.com/gmathieu/node-browsers
# https://store.docker.com/images/node
FROM node:10-stretch AS node-chrome
# https://tracker.debian.org/pkg/chromium
ARG CHROMIUM=73.0.3683.75-1~deb9u1
# https://tracker.debian.org/pkg/firefox-esr
ARG FIREFOX=60.6.1esr-1~deb9u1
# lock yarn version (note: node:stretch comes with yarn, we install our own version)
ENV YARN_VERSION 1.12.1
RUN curl -fSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
    && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/ \
    && ln -snf /opt/yarn-v$YARN_VERSION/bin/yarn /usr/local/bin/yarn \
    && ln -snf /opt/yarn-v$YARN_VERSION/bin/yarnpkg /usr/local/bin/yarnpkg \
    && rm yarn-v$YARN_VERSION.tar.gz
RUN \
  apt-get update && apt-get install -y --no-install-recommends \
    # browsers
    chromium=${CHROMIUM} firefox-esr=${FIREFOX} \
    # cci deps
    git tar gzip ca-certificates \
    # deployment
    bash curl make \
  && rm -rf  /var/lib/apt/lists/* /tmp/*
ENV \
  # disable puppeteer download as it will not work with this image
  PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
  # browser bin paths
  CHROME_BIN=/usr/bin/chromium \
  FIREFOX_BIN=/usr/bin/firefox
ENV NODE_ENV development

FROM node AS source-with-dependencies
ENV NODE_ENV development
WORKDIR /tmp/app
COPY . .
RUN yarn install

# it would be better to use the same base image for build and test to make sure
# we have the same Node version, but I want to keep this simple by having Chrome
# installed by the base image
FROM node-chrome AS test
USER root
WORKDIR /tmp/app
COPY --from=source-with-dependencies /tmp/app .
RUN yarn test
RUN yarn e2e

FROM source-with-dependencies AS build
ENV NODE_ENV production
WORKDIR /tmp/app
RUN yarn build

FROM nginx AS production
COPY --from=build /tmp/app/dist/docker-angular /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
# HTTPS (certificate not included)
EXPOSE 443
