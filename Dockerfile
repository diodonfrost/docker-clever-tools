FROM debian:10

LABEL version="2.8.0" \
      maintainer="Diodonfrost <diodon.frost@diodonfrost.me>" \
      description="Command Line Interface for Clever Cloud with Git." \
      license="Apache-2.0"

ARG VERSION=${VERSION}

RUN apt-get update && apt-get install -y \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN curl --output clever-tools_linux.tar.gz https://clever-tools.clever-cloud.com/releases/${VERSION}/clever-tools-${VERSION}_linux.tar.gz \
    && mkdir clever-tools_linux \
    && tar xvzf clever-tools_linux.tar.gz -C clever-tools_linux --strip-components=1 \
    && cp clever-tools_linux/clever /usr/local/bin \
    && rm -rf clever-tools_linux*

VOLUME ["/actions"]
WORKDIR /actions

ENTRYPOINT ["clever"]
