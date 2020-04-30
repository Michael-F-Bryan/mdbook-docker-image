FROM rust:1.43.0-slim AS build

# Version numbers for all the crates we're going to install
ARG MDBOOK_VERSION="0.3.7"
ARG MDBOOK_LINKCHECK_VERSION="0.5.1"
ARG MDBOOK_MERMAID_VERSION="0.4.0"

ENV CARGO_INSTALL_ROOT /usr/local/

RUN cargo install mdbook --vers ${MDBOOK_VERSION} --verbose
RUN cargo install mdbook-linkcheck --vers ${MDBOOK_LINKCHECK_VERSION} --verbose
RUN cargo install mdbook-mermaid --vers ${MDBOOK_MERMAID_VERSION} --verbose

# Create the final image
FROM ubuntu:20.04

LABEL maintainer="michaelfbryan@gmail.com" \
    version=$MDBOOK_VERSION
ENV RUST_LOG info

# used when serving
EXPOSE 3000

COPY --from=build /usr/local/bin/mdbook* /bin/

WORKDIR /data
VOLUME [ "/data" ]

ENTRYPOINT [ "/bin/mdbook" ]
