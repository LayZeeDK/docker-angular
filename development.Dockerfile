FROM node:lts-alpine AS node

FROM node
ENV NODE_ENV development
# VOLUME /tmp/app
WORKDIR /tmp/app
COPY . .
RUN yarn install
VOLUME /tmp/app/node_modules
# --poll is a fix for Windows hosts
# see https://stackoverflow.com/a/44196594/1071200
ENTRYPOINT yarn start --host 0.0.0.0 --poll
# development server
EXPOSE 4200
# EXPOSE 32797
# live reload
EXPOSE 49153
