FROM rust:1.46.0-slim AS build

# Version numbers for all the crates we're going to install
ARG MDBOOK_VERSION="0.4.4"
ARG MDBOOK_LINKCHECK_VERSION="0.7.1"
ARG MDBOOK_MERMAID_VERSION="0.6.1"
ARG MDBOOK_TOC_VERSION="0.5.1"
ARG MDBOOK_PLANTUML_VERSION="0.7.0"
ARG MDBOOK_OPEN_ON_GH_VERSION="1.3.1"

ENV CARGO_INSTALL_ROOT /usr/local/
ENV CARGO_TARGET_DIR /tmp/target/

RUN apt-get update && \
    apt-get install -y libssl-dev pkg-config ca-certificates build-essential make perl gcc libc6-dev

RUN cargo install mdbook --vers ${MDBOOK_VERSION} --verbose
RUN cargo install mdbook-linkcheck --vers ${MDBOOK_LINKCHECK_VERSION} --verbose
RUN cargo install mdbook-mermaid --vers ${MDBOOK_MERMAID_VERSION} --verbose
RUN cargo install mdbook-toc --vers ${MDBOOK_TOC_VERSION} --verbose
RUN cargo install mdbook-plantuml --vers ${MDBOOK_PLANTUML_VERSION} --verbose
RUN cargo install mdbook-open-on-gh --vers ${MDBOOK_OPEN_ON_GH_VERSION} --verbose

# Create the final image
FROM ubuntu:20.04

LABEL maintainer="michaelfbryan@gmail.com"
ENV RUST_LOG info

# used when serving
EXPOSE 3000

COPY --from=build /usr/local/bin/mdbook* /bin/

WORKDIR /data
VOLUME [ "/data" ]

ENTRYPOINT [ "/bin/mdbook" ]
