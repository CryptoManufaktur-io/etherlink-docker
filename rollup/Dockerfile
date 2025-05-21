ARG ROLLUP_TAG=octez-v22.0

# Stage 1: Get the binary from the Tezos image
FROM tezos/tezos:${ROLLUP_TAG}} AS source

# Stage 2: Create a slim final image with just the binary
FROM alpine:latest

# Install required system dependencies (optional, depending on binary requirements)
RUN apk update && apk add --no-cache aria2 ca-certificates tzdata bash wget

# Copy needed files
COPY --from=source /usr/local/bin/octez-smart-rollup-node /usr/local/bin/octez-smart-rollup-node
COPY ./docker-entrypoint.sh /usr/local/bin/

# Belt and suspenders
RUN chmod -R 755 /usr/local/bin/*

# Set the binary as the entrypoint
ENTRYPOINT ["octez-smart-rollup-node"]
