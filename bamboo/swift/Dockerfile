ARG VERSION
FROM ghcr.io/ls1intum/artemis-bamboo:${VERSION}

LABEL description="Bamboo pre-configured for Artemis, pre-installed with Swift"

USER root
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev \
    libxml2-dev

# Install Swift by copying relevant files
COPY --from=swift:latest /usr /usr

# Install SwiftLint
RUN git clone --branch master https://github.com/realm/SwiftLint.git && \
    cd SwiftLint && \
    swift build --configuration release -Xswiftc -static-stdlib && \
    mv $(swift build --configuration release -Xswiftc -static-stdlib --show-bin-path)/swiftlint /usr/bin && \
    cd .. && \
    rm -rf SwiftLint

USER ${BAMBOO_USER}
