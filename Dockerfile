FROM debian AS build-clever-tools

RUN apt-get update && apt-get install -y \
	libtool \
	curl

RUN curl --output clever-tools_linux.tar.gz https://clever-tools.clever-cloud.com/releases/2.8.0/clever-tools-2.8.0_linux.tar.gz \
	&& mkdir clever-tools_linux \
	&& tar xvzf clever-tools_linux.tar.gz -C clever-tools_linux --strip-components=1 \
	&& cp clever-tools_linux/clever /usr/local/bin

# Only grep the clever-tools binary and his libraries for the release stage
# We use ldd to find the shared object dependencies.
RUN \
	mkdir -p /tmp/fakeroot/lib  && \
	cp $(ldd /usr/local/bin/clever | grep -o '/.\+\.so[^ ]*' | sort | uniq) /tmp/fakeroot/lib && \
	for lib in /tmp/fakeroot/lib/*; do strip --strip-all $lib; done && \
	mkdir -p /tmp/fakeroot/bin/ && \
	cp /usr/local/bin/clever /tmp/fakeroot/bin/


FROM debian AS build-extra-packages

RUN apt-get update && apt-get install -y \
    git \
	libtool \
	curl

RUN \
	mkdir -p /tmp/fakeroot/lib  && \
	cp $(ldd /usr/bin/git | grep -o '/.\+\.so[^ ]*' | sort | uniq) /tmp/fakeroot/lib && \
	for lib in /tmp/fakeroot/lib/*; do strip --strip-all $lib; done && \
	mkdir -p /tmp/fakeroot/bin/ && \
	cp /usr/bin/git /tmp/fakeroot/bin/


FROM busybox:glibc AS release

LABEL version="2.8.0" \
      maintainer="Diodonfrost <diodon.frost@diodonfrost.me>" \
      description="Command Line Interface for Clever Cloud with Git." \
      license="Apache-2.0"

VOLUME ["/actions"]
WORKDIR /actions

COPY --from=build-clever-tools /tmp/fakeroot/ /
COPY --from=build-extra-packages /tmp/fakeroot/ /

## The loader search ld-linux-x86-64.so.2 in /lib64 but the folder does not exist
RUN ln -s lib lib64

ENTRYPOINT ["clever"]
