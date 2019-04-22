# `LayZeeDK/docker-angular`

Docker containers for developing, testing, building and deploying Angular apps.

You need to install a container runtime. [Get one from Docker.com](https://www.docker.com/get-started).

Run NPM scripts located in `package.json`, for example `npm run docker:test` or `yarn docker:test`.

To build and run a production web server using Nginx, run the `docker:build` NPM script followed by `docker:deploy`.
