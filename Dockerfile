FROM rust:1.54.0-slim AS build

# Version numbers for all the crates we're going to install
ARG MDBOOK_VERSION="0.4.11"
ARG MDBOOK_LINKCHECK_VERSION="0.7.4"
ARG MDBOOK_MERMAID_VERSION="0.8.3"
ARG MDBOOK_TOC_VERSION="0.7.0"
ARG MDBOOK_PLANTUML_VERSION="0.7.0"
ARG MDBOOK_OPEN_ON_GH_VERSION="2.0.1"
ARG MDBOOK_GRAPHVIZ_VERSION="0.0.2"
ARG MDBOOK_KATEX_VERSION="0.2.10"

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
RUN cargo install mdbook-graphviz --vers ${MDBOOK_GRAPHVIZ_VERSION} --verbose
RUN cargo install mdbook-katex --vers ${MDBOOK_KATEX_VERSION} --verbose

# Create the final image
FROM ubuntu:20.04

LABEL maintainer="michaelfbryan@gmail.com"
ENV RUST_LOG info

# used when serving
EXPOSE 3000

COPY --from=build /usr/local/bin/mdbook* /bin/

# Make sure we have certs
RUN apt-get update && apt-get install  --no-install-recommends -y ca-certificates graphviz && rm -rf /var/cache/apt/lists

WORKDIR /data
VOLUME [ "/data" ]

ENTRYPOINT [ "/bin/mdbook" ]
