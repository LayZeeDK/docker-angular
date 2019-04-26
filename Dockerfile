FROM node:10-alpine AS node-base
ENV NODE_ENV development

FROM node-base AS app
WORKDIR /tmp/app
COPY package.json yarn.lock ./
RUN yarn install
COPY ./ ./

FROM node-base AS test-base
# https://pkgs.alpinelinux.org/package/edge/community/x86_64/chromium
ARG CHROMIUM=73.0.3683.103-r0
RUN sed -i -e 's/v3.9/edge/g' /etc/apk/repositories \
  && apk add --no-cache \
  python \
  build-base \
  git \
  bash \
  openjdk8-jre-base \
  # chromium dependencies
  nss \
  chromium-chromedriver \
  chromium=${CHROMIUM} \
  && apk upgrade --no-cache --available
ENV CHROME_BIN /usr/bin/chromium
WORKDIR /tmp/app
COPY --from=app /tmp/app/ ./

FROM test-base AS test
RUN yarn test

FROM test-base AS e2e
RUN yarn e2e

FROM app AS build
ENV NODE_ENV production
WORKDIR /tmp/app
RUN yarn build

FROM nginx:stable-alpine AS production
COPY --from=build /tmp/app/dist/docker-angular/ /usr/share/nginx/html/
COPY nginx.conf /etc/nginx/conf.d/default.conf
# HTTPS (certificate not included)
EXPOSE 443
