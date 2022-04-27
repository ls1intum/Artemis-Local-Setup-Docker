ARG VERSION
ARG OWNER
FROM ghcr.io/${OWNER}/artemis-jenkins:${VERSION}

LABEL description="Jenkins with swift libraries pre-installed for Artemis"

USER root

RUN apt update
RUN apt-get install -y --no-install-recommends \
    gnupg2 \
    libcurl4-openssl-dev \
    libxml2-dev \
    libncurses5 \
    && rm -r /var/lib/apt/lists/*

# Install Swift and SwiftLint (adapted from norionomura/swift and norionomura/swiftlint)
ENV SWIFT_BRANCH swift-5.5-release
ENV SWIFT_PLATFORM ubuntu18.04
ENV SWIFT_VERSION 5.5-RELEASE

# Install Swift keys
RUN curl -L https://swift.org/keys/all-keys.asc | gpg2 --import -

# Install Swift toolchain
# -> https://swift.org/builds/swift-5.3.1-release/ubuntu1804/swift-5.3.1-RELEASE/swift-5.3.1-RELEASE-ubuntu18.04.tar.gz
RUN SWIFT_ARCHIVE_NAME=swift-$SWIFT_VERSION-$SWIFT_PLATFORM && \
    SWIFT_URL=https://swift.org/builds/$SWIFT_BRANCH/$(echo "$SWIFT_PLATFORM" | tr -d .)/swift-$SWIFT_VERSION/$SWIFT_ARCHIVE_NAME.tar.gz && \
    curl -LO $SWIFT_URL && \
    curl -LO $SWIFT_URL.sig && \
    gpg2 --verify $SWIFT_ARCHIVE_NAME.tar.gz.sig && \
    tar -xvzf $SWIFT_ARCHIVE_NAME.tar.gz --directory / --strip-components=1 && \
    rm -rf $SWIFT_ARCHIVE_NAME* /tmp/* /var/tmp/* && \
    chmod -R o+r /usr/lib/swift
# Install SwiftLint
RUN git clone --branch master https://github.com/realm/SwiftLint.git
RUN cd SwiftLint && swift build --configuration release -Xswiftc -static-stdlib
RUN cd SwiftLint && mv $(swift build --configuration release -Xswiftc -static-stdlib --show-bin-path)/swiftlint /usr/bin
RUN rm -rf SwiftLint

# Install docker client (if you want a local build agent)
# (Uncomment this line if you want to use a local docker build agent e.g for development purposes)
#RUN curl https://download.docker.com/linux/static/stable/x86_64/docker-19.03.8.tgz | tar xvz --directory /tmp && mv -v /tmp/docker/docker /usr/local/bin/docker && chmod +x /usr/local/bin/docker && rm -rf /tmp/docker

USER jenkins
