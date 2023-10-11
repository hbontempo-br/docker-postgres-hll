ARG POSTGRES_VERSION

FROM postgres:$POSTGRES_VERSION AS builder

RUN apk --update add --no-cache wget build-base llvm15 clang15

WORKDIR /src

ARG HLL_VERSION
RUN wget https://github.com/citusdata/postgresql-hll/archive/refs/tags/v${HLL_VERSION}.tar.gz -O postgresql-hll.tar.gz && \
    mkdir postgresql-hll && \
    tar xf ./postgresql-hll.tar.gz -C postgresql-hll --strip-components 1
WORKDIR /src/postgresql-hll
RUN make
RUN make install

FROM postgres:$POSTGRES_VERSION 

ENV POSTGRES_PASSWORD postgres

RUN echo "shared_preload_libraries = 'hll'" >> /usr/local/share/postgresql/postgresql.conf.sample
COPY hll_extension.sql /docker-entrypoint-initdb.d/
COPY --from=builder /src/postgresql-hll/*.sql /usr/local/share/postgresql/extension/
COPY --from=builder /src/postgresql-hll/*.control /usr/local/share/postgresql/extension/
COPY --from=builder /src/postgresql-hll/*.so /usr/local/lib/postgresql/
