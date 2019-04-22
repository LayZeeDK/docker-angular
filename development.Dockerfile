FROM node:10-alpine
ENV NODE_ENV development
VOLUME /tmp/app
VOLUME /tmp/app/node_modules
WORKDIR /tmp/app
# --poll is a fix for Windows hosts
# see https://stackoverflow.com/a/44196594/1071200
ENTRYPOINT yarn start --host 0.0.0.0 --poll 500
# development server
EXPOSE 4200
# live reload
EXPOSE 49153
