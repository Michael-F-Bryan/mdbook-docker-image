FROM rust:1.43.0-slim

ARG MDBOOK_VERSION="0.3.7"
ARG MDBOOK_LINKCHECK_VERSION="0.5.1"
LABEL maintainer="michaelfbryan@gmail.com" \
    version=$MDBOOK_VERSION

ENV CARGO_INSTALL_ROOT /bin
ENV RUST_LOG info

RUN cargo install mdbook --vers ${MDBOOK_VERSION} && \
    cargo install mdbook-linkcheck --vers ${MDBOOK_LINKCHECK_VERSION}

WORKDIR /data
VOLUME [ "/data" ]

ENTRYPOINT [ "/bin/mdbook" ]
