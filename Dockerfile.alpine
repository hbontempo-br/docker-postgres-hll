ARG POSTGRES_VERSION

FROM postgres:$POSTGRES_VERSION

ENV POSTGRES_PASSWORD postgres

RUN apk --update add --no-cache wget make gcc g++ wget postgresql-dev

WORKDIR /src

ARG HLL_VERSION
ARG SRC=postgresql-hll
RUN wget https://github.com/citusdata/postgresql-hll/archive/refs/tags/v${HLL_VERSION}.tar.gz -O ${SRC}.tar.gz && \
    mkdir ${SRC} && \
    tar xf ./${SRC}.tar.gz -C ${SRC} --strip-components 1
WORKDIR /src/${SRC}
RUN make
RUN make install
RUN echo "shared_preload_libraries = 'hll'" >> /usr/local/share/postgresql/postgresql.conf.sample
COPY hll_extension.sql /docker-entrypoint-initdb.d/