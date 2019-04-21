# TODO: add serve stage/Dockerfile with live-reload
# TODO: use volume for ng serve

FROM node:lts-alpine AS node
FROM nginx:stable-alpine AS nginx

# it would be better to use the same base image for build and test to make sure
# we have the same Node version, but I want to keep this simple by having Chrome
# installed by the base image
FROM zenika/alpine-chrome:with-node AS test
WORKDIR /tmp/test
COPY . .
RUN yarn install
RUN yarn test
RUN yarn e2e

FROM node AS build
WORKDIR /tmp/build
COPY --from=test /tmp/test/ .
RUN yarn build

FROM nginx AS production
COPY --from=build /tmp/build/dist/docker-angular/ /usr/share/nginx/html/
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 443
