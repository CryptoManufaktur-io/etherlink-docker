ARG ROLLUP_NODE_TAG=octez-v22.0

FROM tezos/tezos:${ROLLUP_NODE_TAG} AS source

USER root
RUN apk update && apk add --no-cache aria2 ca-certificates tzdata bash

COPY ./docker-entrypoint.sh /usr/local/bin/
RUN chmod -R 755 /usr/local/bin/docker-entrypoint.sh

WORKDIR /data
RUN chown tezos:tezos /data
USER tezos

ENTRYPOINT ["docker-entrypoint.sh"]
