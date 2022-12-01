ARG POSTGRES_VERSION

FROM postgres:$POSTGRES_VERSION

ENV POSTGRES_PASSWORD postgres

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y && apt-get install -y postgresql-server-dev-${PG_MAJOR} make gcc g++ git wget

WORKDIR /src

ARG HLL_VERSION
ARG SRC=postgresql-hll
RUN wget https://github.com/citusdata/postgresql-hll/archive/refs/tags/v${HLL_VERSION}.tar.gz -O ${SRC}.tar.gz && \
    mkdir ${SRC} && \
    tar xf ./${SRC}.tar.gz -C ${SRC} --strip-components 1
WORKDIR /src/${SRC}
RUN PG_CONFIG=/usr/bin/pg_config make
RUN PG_CONFIG=/usr/bin/pg_config make install
RUN echo "shared_preload_libraries = 'hll'" >> /usr/share/postgresql/postgresql.conf.sample
COPY hll_extension.sql /docker-entrypoint-initdb.d/