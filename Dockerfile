FROM rust:1.43.0-slim AS build

# Version numbers for all the crates we're going to install
ARG MDBOOK_VERSION="0.3.7"
ARG MDBOOK_LINKCHECK_VERSION="0.6.0"
ARG MDBOOK_MERMAID_VERSION="0.4.1"
ARG MDBOOK_TOC_VERSION="0.4.1"
ARG MDBOOK_PLANTUML_VERSION="0.5.0"
ARG MDBOOK_OPEN_ON_GH_VERSION="1.1.1"

ENV CARGO_INSTALL_ROOT /usr/local/

RUN cargo install mdbook --vers ${MDBOOK_VERSION} --verbose
RUN cargo install mdbook-linkcheck --vers ${MDBOOK_LINKCHECK_VERSION} --verbose
RUN cargo install mdbook-mermaid --vers ${MDBOOK_MERMAID_VERSION} --verbose
RUN cargo install mdbook-toc --vers ${MDBOOK_TOC_VERSION} --verbose
RUN apt-get update && \
    apt-get install -y libssl-dev pkg-config && \
    cargo install mdbook-plantuml --vers ${MDBOOK_PLANTUML_VERSION} --verbose
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
