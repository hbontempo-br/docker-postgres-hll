# Docker images with PostgreSQL with HLL extension

Collection of PostgreSQL docker images with the [HLL plugin](https://github.com/citusdata/postgresql-hll) already installed.

:warning: This images meant for development use :warning:

> **_Images repository_**: https://hub.docker.com/repository/docker/hbontempo/postgres-hll

> **_Source code:_** https://github.com/hbontempo/docker-postgres-hll



## Tag convention

Pretty simple: `{POSTGRES_IMAGE_VERSION}-v{HLL_VERSION}`, so, for example, if you need a image based postgres:13.8 with HLL version 2.16 installed you should use the `hbontempo/postgres-hll:13.8-v2.16` image.
To use the lastest Postgres and HLL version use the `latest` version.

## How to use this image

Since the image is based on the [official PostgreSQL image](https://hub.docker.com/_/postgres) you can use the exactly same configuration you would you in it. In it's [documentation](https://hub.docker.com/_/postgres) you will find many ways to configure it accordinly to your necesities.

Here is the basic configuration:

### Directly using the `docker` CLI

```shell
$ docker run --name your_name -e POSTGRES_PASSWORD=mysecretpassword -d hbontempo/postgres-hll
```

### Using `docker-compose` or `docker stack deploy`


File `stack.yml`:

```yaml
version: '3.1'

services:

  db:
    image: postgres
    restart: always
    environment:
      POSTGRES_PASSWORD: mysecretpassword

```

Command:

```shell
$ docker stack deploy -c stack.yml postgres
# OR
$ docker-compose -f stack.yml up
```


## Contributing

Want to contribute? Awesome! You can find information about contributing to this project in the [CONTRIBUTING.md](https://github.com/hbontempo-br/docker-postgres-hll/blob/main/CONTRIBUTING.md)

## Needs help

Just open an [issue](https://github.com/hbontempo-br/docker-postgres-hll/issues) :)