# Adapted from https://bitbucket.org/atlassian-docker/docker-atlassian-bitbucket-server/src/master/Dockerfile

ARG BASE_IMAGE=eclipse-temurin:11
FROM $BASE_IMAGE

LABEL maintainer="artemis.in@tum.de"
LABEL securitytxt="https://www.atlassian.com/.well-known/security.txt"

ARG VERSION=8.8.2
ARG BITBUCKET_VERSION=${VERSION}

ENV APP_NAME                                        bitbucket
ENV RUN_USER                                        bitbucket
ENV RUN_GROUP                                       bitbucket
ENV RUN_UID                                         2003
ENV RUN_GID                                         2003

# https://confluence.atlassian.com/display/BitbucketServer/Bitbucket+Server+home+directory
ENV BITBUCKET_HOME                                  /var/atlassian/application-data/bitbucket
ENV BITBUCKET_INSTALL_DIR                           /opt/atlassian/bitbucket
ENV ELASTICSEARCH_DIR                               ${BITBUCKET_INSTALL_DIR}/elasticsearch
ENV ELASTICSEARCH_ENABLED                           true
ENV APPLICATION_MODE                                default
ENV JRE_HOME                                        /opt/java/openjdk
ENV JAVA_BINARY                                     ${JRE_HOME}/bin/java

WORKDIR $BITBUCKET_HOME

# Expose HTTP and SSH ports
EXPOSE 7990
EXPOSE 7999

CMD ["/entrypoint.py", "--log=INFO"]
ENTRYPOINT ["/usr/bin/tini", "--"]

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends fontconfig openssh-client perl python3 python3-jinja2 tini git \
    && apt-get clean autoclean && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

ARG DOWNLOAD_URL=https://product-downloads.atlassian.com/software/stash/downloads/atlassian-bitbucket-${BITBUCKET_VERSION}.tar.gz

RUN groupadd --gid ${RUN_GID} ${RUN_GROUP} \
    && useradd --uid ${RUN_UID} --gid ${RUN_GID} --home-dir ${BITBUCKET_HOME} --shell /bin/bash ${RUN_USER} \
    && echo PATH=$PATH > /etc/environment \
    \
    && mkdir -p                                     ${BITBUCKET_INSTALL_DIR} \
    && curl -L --silent                             ${DOWNLOAD_URL} | tar -xz --strip-components=1 -C "${BITBUCKET_INSTALL_DIR}" \
    && chmod -R "u=rwX,g=rX,o=rX"                   ${BITBUCKET_INSTALL_DIR}/ \
    && chown -R root.                               ${BITBUCKET_INSTALL_DIR}/ \
    && chown -R ${RUN_USER}:${RUN_GROUP}            ${BITBUCKET_INSTALL_DIR}/*search/logs \
    && chown -R ${RUN_USER}:${RUN_GROUP}            ${BITBUCKET_HOME}

RUN git clone https://bitbucket.org/atlassian-docker/docker-atlassian-bitbucket-server/src/master/ ./git-repo
RUN git clone https://bitbucket.org/atlassian-docker/docker-shared-components.git ./shared-components

VOLUME ["${BITBUCKET_HOME}"]

RUN cp ./git-repo/exec-bitbucket-node.sh ${BITBUCKET_INSTALL_DIR}/bin/
RUN cp ./git-repo/_exec-webapp.sh ${BITBUCKET_INSTALL_DIR}/bin/

RUN cp ./git-repo/bin/make-git.sh /
RUN chmod 700 /make-git.sh
RUN /make-git.sh
RUN cp ./git-repo/bin/log4shell-vulnerability-fix.sh /
RUN chmod 700 /log4shell-vulnerability-fix.sh
RUN /log4shell-vulnerability-fix.sh

RUN cp ./git-repo/entrypoint.py /
RUN cp ./shared-components/image/entrypoint_helpers.py /
RUN cp -r ./shared-components/support /opt/atlassian/support
RUN cp ./git-repo/shutdown-wait.sh /

RUN rm -rf ./git-repo
RUN rm -rf ./shared-components
