ARG VERSION
ARG OWNER
FROM ghcr.io/${OWNER}/artemis-bamboo:${VERSION}

LABEL description="Bamboo pre-configured for Artemis, pre-installed with Swift"

USER root
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev \
    libxml2-dev

# Install Swift by copying relevant files

# TODO: Maybe build Swift image from source?
# https://github.com/apple/swift-docker/blob/main/5.6/ubuntu/20.04/Dockerfile
COPY --from=swift:focal /usr /usr

# Install SwiftLint
RUN git clone --branch master https://github.com/realm/SwiftLint.git
RUN cd SwiftLint && swift build --configuration release -Xswiftc -static-stdlib
RUN cd SwiftLint && mv $(swift build --configuration release -Xswiftc -static-stdlib --show-bin-path)/swiftlint /usr/bin
RUN rm -rf SwiftLint

USER ${BAMBOO_USER}
