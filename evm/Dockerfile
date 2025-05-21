ARG EVM_NODE_TAG=octez-evm-node-v0.26

FROM tezos/tezos:${EVM_NODE_TAG} AS source

USER root
RUN apk update && apk add --no-cache aria2 ca-certificates tzdata bash jq

COPY ./docker-entrypoint.sh /usr/local/bin/
RUN chmod -R 755 /usr/local/bin/docker-entrypoint.sh

WORKDIR /data
RUN chown tezos:tezos /data
USER tezos

ENTRYPOINT ["docker-entrypoint.sh"]
