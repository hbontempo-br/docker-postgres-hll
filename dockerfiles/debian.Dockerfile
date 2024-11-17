# check=skip=SecretsUsedInArgOrEnv

ARG POSTGRES_VERSION=latest

FROM postgres:$POSTGRES_VERSION AS builder

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y && apt-get install -y postgresql-server-dev-${PG_MAJOR} make gcc g++ wget clang

WORKDIR /src

ARG HLL_VERSION
RUN wget https://github.com/citusdata/postgresql-hll/archive/refs/tags/v${HLL_VERSION}.tar.gz -O postgresql-hll.tar.gz && \
    mkdir postgresql-hll && \
    tar xf ./postgresql-hll.tar.gz -C postgresql-hll --strip-components 1
WORKDIR /src/postgresql-hll
RUN make && make install

FROM postgres:$POSTGRES_VERSION 

ENV POSTGRES_PASSWORD=postgres

RUN echo "shared_preload_libraries = 'hll'" >> /usr/share/postgresql/postgresql.conf.sample
COPY hll_extension.sql /docker-entrypoint-initdb.d/
COPY --from=builder /src/postgresql-hll/*.sql /usr/share/postgresql/${PG_MAJOR}/extension/
COPY --from=builder /src/postgresql-hll/*.control /usr/share/postgresql/${PG_MAJOR}/extension/
COPY --from=builder /src/postgresql-hll/*.so /usr/lib/postgresql/${PG_MAJOR}/lib
