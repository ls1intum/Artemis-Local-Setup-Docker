# Dockerfiles for the local development setup of Artemis

Hosts the Dockerfiles that are used for the local setups for Artemis.
The main reason for the existance of this repository is that the official Docker images of the tools in this repository only offer x64 images. As arm64 CPUs become more common (especially in the Artemis develper team) it is beneficial to have native images for these processors.

Currently this repository contains Dockerfiles for the following tools:

- __Bitbucket__ (adapted from <https://bitbucket.org/atlassian-docker/docker-atlassian-bitbucket-server/src/master/>)
- __Bamboo__ (adapted from <https://bitbucket.org/atlassian-docker/docker-bamboo-server/src/7.2.5/>)
- __Jira__ (adapted from <https://bitbucket.org/atlassian-docker/docker-atlassian-jira/src/master/>)

## Building the images

Each push to main (or merge into), will trigger a re-build of the images.

> :warning: __Please note:__ Only those images that have changes in either their `Dockerfile` or `RELEASE`-file will be rebuilt!

Please check out the step `check-matrix` for runs of the workflow.
Here one can verify the generated matrix more easily.

To prevent an image from being built at all, simply change the `BUILD=yes` line to `BUILD=no` in the corresponding `RELEASE`-file.

### Change versions built

To change the version of the images being built, edit their version in the corresponding `RELEASE`-file.
All Dockerfiles have an `ARG VERSION` parameter. The GitHub workflow sets the version in a matrix build according to the specified version within the `RELEASE`-file.

## Restrictions regarding caching

Please note that there are some downsides on GitHub Actions regarding build of the images:

> GitHub will remove any cache entries that have not been accessed in over 7 days.
> There is no limit on the number of caches you can store, but the total size of all caches in a repository is limited to 10 GB.
> If you exceed this limit, GitHub will save your cache but will begin evicting caches until the total size is less than 10 GB.
> [See documentation here.](https://docs.github.com/en/actions/using-workflows/caching-dependencies-to-speed-up-workflows)
