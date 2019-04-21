# TODO: add serve stage/Dockerfile with live-reload
# TODO: use volume for ng serve

FROM node:lts-alpine AS node
FROM nginx:stable-alpine AS nginx
FROM zenika/alpine-chrome:with-node AS node-chrome

FROM node AS source-with-dependencies
ENV NODE_ENV development
VOLUME /tmp/app/node_modules
WORKDIR /tmp/app
COPY . .
RUN yarn install

FROM source-with-dependencies AS development
VOLUME /tmp/app
WORKDIR /tmp/app
# --poll is a fix for Windows hosts
# see https://stackoverflow.com/a/44196594/1071200
ENTRYPOINT npx ng serve --host 0.0.0.0 --poll
# development server
EXPOSE 4200
# live reload
EXPOSE 49153

# it would be better to use the same base image for build and test to make sure
# we have the same Node version, but I want to keep this simple by having Chrome
# installed by the base image
FROM node-chrome AS test
WORKDIR /tmp/app
RUN yarn test
RUN yarn e2e
# remote Chrome debugging
EXPOSE 9222

FROM source-with-dependencies AS build
ENV NODE_ENV production
WORKDIR /tmp/app
RUN yarn build

FROM nginx AS production
COPY --from=build /tmp/app/dist/docker-angular /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
# HTTPS (not included)
EXPOSE 443
