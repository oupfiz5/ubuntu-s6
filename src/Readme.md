# Table of Contents

-   [About](#org8d2b8ea)
-   [Installation](#org3588e7d)
    -   [Download from dockerhub](#org9d18812)
    -   [Build from chiselapp (fossil)](#orgc2aa08e)
    -   [Build from github](#org3e5ba83)
-   [Configuration options](#org53a6b68)
    -   [General options](#org2e34774)
    -   [Timezone](#org87954e2)
-   [CI/CD](#org38746d3)
-   [Maintenance](#org86a5c62)
    -   [Log output](#org1e74828)
    -   [Shell access](#org4333113)
-   [Code](#org3bd68ff):code:
    -   [VERSION](#orgb1a41a6):code:
    -   [.github/workflows/on-push.yaml](#orgaeeb384):code:
    -   [.github/workflows/test.yaml](#orgb00cab2):code:
    -   [.github/.trigger\_on\_push](#org9233307):code:
    -   [.gitignore](#org8b5cc07):code:
    -   [Dockerfile](#orgab14385):code:
    -   [shellcheck.sh](#org670200d):code:
    -   [docker\_image\_check.sh](#orgfc9d1bb):code:
    -   [dockerfile\_check.sh](#org9b80b48):code:
    -   [hook/build.sh](#org6dabead):code:
    -   [hook/push.sh](#orgb840e79):code:
    -   [rootfs/etc/cont-finish.d/.gitignore](#orga589e66):code:notangle:
    -   [rootfs/etc/cont-init.d/00\_settimezone.sh](#org016c584):code:
    -   [rootfs/etc/fix-attrs.d/.gitignore](#org9907f72):code:notangle:
    -   [rootfs/etc/services.d/.gitignore](#orgaefcead):code:notangle:



<a id="org8d2b8ea"></a>

# About

This is [ubuntu base docker image](https://hub.docker.com/_/ubuntu) (version 20.04) using [s6-overlay](https://github.com/just-containers/s6-overlay).

Ubuntu-s6 is self-hosting at <https://chiselapp.com/user/oupfiz5/repository/ubuntu-s6>.

If you are reading this on GitHub, then you are looking at a Git mirror of the self-hosting Ubuntu-s6 repository.  The purpose of that mirror is to test and exercise Fossil's ability to export a Git mirror and using Github CI/CD  (Github Actions). Nobody much uses the GitHub mirror, except to verify that the mirror logic works. If you want to know more about Ubuntu-s6, visit the official self-hosting site linked above.


<a id="org3588e7d"></a>

# Installation


<a id="org9d18812"></a>

## Download from dockerhub

    docker pull oupfiz5/ubuntu-s6:latest
    docker pull oupfiz5/ubuntu-s6:20.04


<a id="orgc2aa08e"></a>

## Build from chiselapp (fossil)

    fossil clone https://chiselapp.com/user/oupfiz5/repository/ubuntu-s6 ubuntu-s6.fossil
    mkdir ubuntu-s6
    cd ubuntu-s6
    fossil open ../ubuntu-s6.fossil
    docker build -t oupfiz5/ubuntu-s6 .


<a id="org3e5ba83"></a>

## Build from github

    git clone https://github.com/oupfiz5/ubuntu-s6.git
    cd ubuntu-s6
    docker build -t oupfiz5/ubuntu-s6 .


<a id="org53a6b68"></a>

# Configuration options


<a id="org2e34774"></a>

## General options

<table border="2" cellspacing="0" cellpadding="6" rules="groups" frame="hsides">


<colgroup>
<col  class="org-left" />

<col  class="org-left" />

<col  class="org-left" />
</colgroup>
<thead>
<tr>
<th scope="col" class="org-left">Option</th>
<th scope="col" class="org-left">Default</th>
<th scope="col" class="org-left">Description</th>
</tr>
</thead>

<tbody>
<tr>
<td class="org-left">TZ</td>
<td class="org-left">UTC</td>
<td class="org-left">Set timezone, example Europe/Moscow</td>
</tr>
</tbody>
</table>


<a id="org87954e2"></a>

## Timezone

Set the timezone for the container, defaults to UTC. To set the
timezone set the desired timezone with the variable TZ.

    docker run -itd --restart always \
               --name ubuntu-s6  \
               --env 'TZ=Europe/Moscow' \
               oupfiz5/ubuntu-s6:latest


<a id="org38746d3"></a>

# CI/CD

For  build and push docker images we use  [Github Actions workflow](https://github.com/oupfiz5/ubuntu-s6/blob/master/.github/workflows/on-push.yaml). Flow process is [GitHub flow](https://guides.github.com/introduction/flow/).


<a id="org86a5c62"></a>

# Maintenance


<a id="org1e74828"></a>

## Log output

For debugging and maintenance purposes you may want access the output log. If you are using Docker version 1.3.0 or higher you can access a running containers shell by starting bash using docker interactive:

    docker run -it --rm \
           --name=ubuntu-s6 \
           oupfiz5/ubuntu-s6:latest


<a id="org4333113"></a>

## Shell access

For debugging and maintenance purposes you may want access the containers shell. If you are using Docker version 1.3.0 or higher you can access a running containers shell by starting bash using docker exec:

    docker exec -it ubuntu-s6 /bin/bash


<a id="org3bd68ff"></a>

# Code     :code:


<a id="orgb1a41a6"></a>

## VERSION     :code:

    S6_OVERLAY_VERSION=2.2.0.3
    UBUNTU_VERSION=20.04


<a id="orgaeeb384"></a>

## .github/workflows/on-push.yaml     :code:

    name: Build and push docker images

    on:
      push:
        paths:
          - .github/workflows/on-push.yaml
          - .github/.trigger_on_push
          - Dockerfile
          - rootfs/*
          - hook/*
        branches:
          - version-*
          # - master


    jobs:
      build:
        name: Build and push dockerhub
        runs-on: ubuntu-latest
        steps:
          - name: Repo checkout
            uses: actions/checkout@v2

          - name: Login to DockerHub Registry
            run: |
              echo  ${{ secrets.DOCKERHUB_TOKEN }} | docker login --username ${{ secrets.DOCKERHUB_USERNAME }} --password-stdin

          - name: Build images
            run: |
              cd ${GITHUB_WORKSPACE}/hook
              ./build.sh

          - name: Push images
            run: |
              cd ${GITHUB_WORKSPACE}/hook
              ./push.sh


<a id="orgb00cab2"></a>

## .github/workflows/test.yaml     :code:

    name: Tests

    # * Controls
    # Controls when the action will run.
    on: [push, pull_request, workflow_dispatch]

    # * Jobs
    jobs:
      checks:
        runs-on: ubuntu-20.04
        steps:
          - name: Repo checkout
            uses: actions/checkout@v2

          - name: Run shellcheck
            run: |
              sudo apt-get update -y
              sudo apt-get install shellcheck
              ./shellcheck.sh


<a id="org9233307"></a>

## .github/.trigger\_on\_push     :code:

    Trigger:4


<a id="org8b5cc07"></a>

## .gitignore     :code:

    .fslckout
    .projectile


<a id="orgab14385"></a>

## Dockerfile     :code:

    # * Base image
    ARG UBUNTU_VERSION=20.04
    FROM ubuntu:${UBUNTU_VERSION}

    # * Arguments
    ARG S6_OVERLAY_VERSION=2.2.0.3 \
        BUILD_DATE \
        UBUNTU_VERSION

    # * Labels
    LABEL \
        maintainer="Oupfiz V <oupfiz5@yandex.ru>" \
        org.opencontainers.image.created="${BUILD_DATE}" \
        org.opencontainers.image.authors="Oupfiz V (Five)" \
        org.opencontainers.image.url="https://chiselapp.com/user/oupfiz5/repository/ubuntu-s6/home" \
        org.opencontainers.image.documentation="https://chiselapp.com/user/oupfiz5/repository/ubuntu-s6/wiki" \
        org.opencontainers.image.source="https://chiselapp.com/user/oupfiz5/repository/ubuntu-s6/brlist" \
        org.opencontainers.image.version="0.0.3d" \
        org.opencontainers.image.revision="" \
        org.opencontainers.image.vendor="" \
        org.opencontainers.image.licenses="" \
        org.opencontainers.image.ref.name="" \
        org.opencontainers.image.title="Ubuntu image with s6 init system" \
        org.opencontainers.image.description="Ubuntu base docker image using s6-overlay" \
        org.opencontainers.ubuntu.version="${UBUNTU_VERSION}" \
        org.opencontainers.s6overlay.version="${S6_OVERLAY_VERSION}"

    # * Environment

    # * Copy
    COPY rootfs/ /

    # * Add
    ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz /tmp/s6-overlay.tar.gz

    # * Run
    RUN apt-get update && \
        DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata --no-install-recommends && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/* && \
        cd /tmp && \
        tar xzf /tmp/s6-overlay.tar.gz -C / --exclude='./bin' && \
        tar xzf /tmp/s6-overlay.tar.gz -C /usr ./bin && \
        rm /tmp/s6-overlay.tar.gz

    # * Entrypoint
    ENTRYPOINT ["/init"]


<a id="org670200d"></a>

## shellcheck.sh     :code:

    set -e

    targets=()
    while IFS=  read -r -d $'\0'; do
        targets+=("$REPLY")
    done < <(
      find \
        rootfs/etc \
        hook \
        ./*.sh \
        -type f \
        -print0
      )


    # shell_check.sh \
    # dockerfilecheck.sh \

    LC_ALL=C.UTF-8 shellcheck "${targets[@]}"

    exit $?


<a id="orgfc9d1bb"></a>

## docker\_image\_check.sh     :code:

    set -e

    # * Get list of targets
    targets=()
    while IFS=  read -r -d $'\0'; do
        targets+=("$REPLY")
    done < <(
      find \
         Dockerfile \
        -type f \
        -print0
      )


    # * Install dockle and check targets
    VERSION=$(
        curl --silent "https://api.github.com/repos/goodwithtech/dockle/releases/latest" | \
            grep '"tag_name":' | \
            sed -E 's/.*"v([^"]+)".*/\1/' \
           ) && docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
                       goodwithtech/dockle:v"${VERSION}" "${targets[@]}"

    exit $?


<a id="org9b80b48"></a>

## dockerfile\_check.sh     :code:

    set -e

    # * Get list of targets
    targets=()
    while IFS=  read -r -d $'\0'; do
        targets+=("$REPLY")
    done < <(
      find \
         Dockerfile \
        -type f \
        -print0
      )


    # * Pull hadolint and check targets
    docker run --rm -i hadolint/hadolint < "${targets[@]}"

    exit $?


<a id="org6dabead"></a>

## hook/build.sh     :code:

    # shellcheck source=../VERSION
    set -a; source ../VERSION ; set +a;

    docker build \
           --build-arg BUILD_DATE="$(date -u +"%Y-%m-%dT%H:%M:%SZ")" \
           --build-arg S6_OVERLAY_VERSION="${S6_OVERLAY_VERSION}" \
           --build-arg UBUNTU_VERSION="${UBUNTU_VERSION}" \
           -t oupfiz5/ubuntu-s6:"${UBUNTU_VERSION}" \
           -t oupfiz5/ubuntu-s6:latest \
           -f ../Dockerfile \
            ../.


<a id="orgb840e79"></a>

## hook/push.sh     :code:

    set -a; source ../VERSION ; set +a;

    docker push oupfiz5/ubuntu-s6:"${UBUNTU_VERSION}"
    docker push oupfiz5/ubuntu-s6:latest


<a id="orga589e66"></a>

## rootfs/etc/cont-finish.d/.gitignore     :code:notangle:


<a id="org016c584"></a>

## rootfs/etc/cont-init.d/00\_settimezone.sh     :code:

    # shellcheck shell=sh

    set -e

    # * User parameters
    TIMEZONE=${TZ:="UTC"}

    TZFILE="../usr/share/zoneinfo/${TIMEZONE}"

    # * Work from the /etc directory
    cd /etc

    if [ -f ${TZFILE} ]; then  # Make sure the file exists
       echo "Setting timezone to ${TIMEZONE}"
       ln -sf ${TZFILE} localtime  # Set the timezone
    else
       echo "Timezone: ${TIMEZONE} not found, skipping"
    fi


<a id="org9907f72"></a>

## rootfs/etc/fix-attrs.d/.gitignore     :code:notangle:


<a id="orgaefcead"></a>

## rootfs/etc/services.d/.gitignore     :code:notangle:
