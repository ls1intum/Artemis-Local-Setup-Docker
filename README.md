# Dockerfiles for the local development setup of Artemis
Hosts the Dockerfiles that are used for the local setups for Artemis.
The main reason for the existance of this repository is that the official Docker images of the tools in this repository only offer x64 images. As arm64 CPUs become more common (especially in the Artemis develper team) it is beneficial to have native images for these processors.

Currently this repository contains Dockerfiles for the following tools:

- Bitbucket (adapted from https://bitbucket.org/atlassian-docker/docker-atlassian-bitbucket-server)
- Bamboo (adapted from https://bitbucket.org/atlassian-docker/docker-bamboo-server)
- Bamboo Build Agent (adapted from https://bitbucket.org/atlassian-docker/docker-bamboo-agent-base)
- Jira (adapted from https://bitbucket.org/atlassian-docker/docker-atlassian-jira)


## Update Atlassian Version 

All Dockerfiles have an `ARG VERSION` parameter. The github worklow sets the version in a matrix build. 

To update the published packages, update the versions in `.github/workflows/build.yml`.

