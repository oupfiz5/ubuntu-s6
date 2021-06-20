# Table of Contents

-   [About](#orga11b112)
-   [Installation](#org8c28c0b)
    -   [Download from dockerhub](#org93573e4)
    -   [Build from chiselapp (fossil)](#orgc1aaeec)
    -   [Build from github](#org1448ae7)
-   [Configuration options](#org584e8fe)
    -   [General options](#org8670c58)
    -   [Timezone](#org46def85)
-   [CI/CD](#org85afd01)
-   [Troubleshooting](#org67cd214)
    -   [Log output](#org2b29b94)
    -   [Shell access](#orge9051b6)
-   [Code](#orgc483d95):code:
    -   [VERSION](#org7efb2e4):code:
    -   [../.github/workflows/on-push.yaml](#orgae32605):code:
    -   [../.github/workflows/test.yaml](#org6e5f0bb):code:
    -   [../.github/.trigger\_on\_push](#org0e92ff3):code:
    -   [../.gitignore](#org07f23db):code:
    -   [Dockerfile](#orga13ac44):code:
    -   [shellcheck.sh](#org0d8f529):code:
    -   [docker\_image\_check.sh](#org55fb690):code:
    -   [.dockleignore](#orgac43aed):code:
    -   [dockerfile\_check.sh](#org6476d80):code:
    -   [hook/build.sh](#org5c37212):code:
    -   [hook/push.sh](#org735e363):code:
    -   [rootfs/etc/cont-finish.d/.gitignore](#orgc64468e):code:notangle:
    -   [rootfs/etc/cont-init.d/00\_settimezone.sh](#orgde889bd):code:
    -   [rootfs/etc/fix-attrs.d/.gitignore](#orga4fcdc1):code:notangle:
    -   [rootfs/etc/services.d/.gitignore](#orga0a7732):code:notangle:



<a id="orga11b112"></a>

# About

This is [ubuntu base docker image](https://hub.docker.com/_/ubuntu) (version 20.04) using [s6-overlay](https://github.com/just-containers/s6-overlay).

Ubuntu-s6 is self-hosting at <https://chiselapp.com/user/oupfiz5/repository/ubuntu-s6>.

If you are reading this on GitHub, then you are looking at a Git mirror of the self-hosting Ubuntu-s6 repository.  The purpose of that mirror is to test and exercise Fossil's ability to export a Git mirror and using Github CI/CD  (Github Actions). Nobody much uses the GitHub mirror, except to verify that the mirror logic works. If you want to know more about Ubuntu-s6, visit the official self-hosting site linked above.


<a id="org8c28c0b"></a>

# Installation


<a id="org93573e4"></a>

## Download from dockerhub

    docker pull oupfiz5/ubuntu-s6:latest
    docker pull oupfiz5/ubuntu-s6:20.04


<a id="orgc1aaeec"></a>

## Build from chiselapp (fossil)

    fossil clone https://chiselapp.com/user/oupfiz5/repository/ubuntu-s6 ubuntu-s6.fossil
    mkdir ubuntu-s6
    cd ubuntu-s6
    fossil open ../ubuntu-s6.fossil
    docker build -t oupfiz5/ubuntu-s6 .


<a id="org1448ae7"></a>

## Build from github

    git clone https://github.com/oupfiz5/ubuntu-s6.git
    cd ubuntu-s6
    docker build -t oupfiz5/ubuntu-s6 .


<a id="org584e8fe"></a>

# Configuration options


<a id="org8670c58"></a>

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


<a id="org46def85"></a>

## Timezone

Set the timezone for the container, defaults to UTC. To set the
timezone set the desired timezone with the variable TZ.

    docker run -itd --restart always \
               --name ubuntu-s6  \
               --env 'TZ=Europe/Moscow' \
               oupfiz5/ubuntu-s6:latest


<a id="org85afd01"></a>

# CI/CD

For  build and push docker images we use  [Github Actions workflow](https://github.com/oupfiz5/ubuntu-s6/blob/master/.github/workflows/on-push.yaml). Flow process is [GitHub flow](https://guides.github.com/introduction/flow/).


<a id="org67cd214"></a>

# Troubleshooting


<a id="org2b29b94"></a>

## Log output

For debugging and maintenance purposes you may want access the output log. If you are using Docker version 1.3.0 or higher you can access a running containers shell by starting bash using docker interactive:

    docker run -it --rm \
           --name=ubuntu-s6 \
           oupfiz5/ubuntu-s6:latest


<a id="orge9051b6"></a>

## Shell access

For debugging and maintenance purposes you may want access the containers shell. If you are using Docker version 1.3.0 or higher you can access a running containers shell by starting bash using docker exec:

    docker exec -it ubuntu-s6 /bin/bash


<a id="orgc483d95"></a>

# Code     :code:


<a id="org7efb2e4"></a>

## VERSION     :code:

    S6_OVERLAY_VERSION='2.2.0.3'
    UBUNTU_VERSION='20.04'


<a id="orgae32605"></a>

## ../.github/workflows/on-push.yaml     :code:

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


<a id="org6e5f0bb"></a>

## ../.github/workflows/test.yaml     :code:

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

          - name: Check shell files (shellcheck)
            run: |
              sudo apt-get update -y
              sudo apt-get install shellcheck
              cd src
              ./shellcheck.sh

          - name: Check dockerfile (hadolint)
            run: |
              cd src
              ./dockerfile_check.sh


<a id="org0e92ff3"></a>

## ../.github/.trigger\_on\_push     :code:

    Trigger:1


<a id="org07f23db"></a>

## ../.gitignore     :code:

    .fslckout
    .projectile


<a id="orga13ac44"></a>

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
    # hadolint ignore=DL3008,DL3003
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


<a id="org0d8f529"></a>

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

    echo "Shellcheck main files"
    LC_ALL=C.UTF-8 shellcheck "${targets[@]}"

    # VERSION were exclude from main check (above)
    # exclude warning https://github.com/koalaman/shellcheck/wiki/SC2034
    echo "Shellcheck VERSION"
    LC_ALL=C.UTF-8 shellcheck --shell=sh --exclude=SC2034 VERSION

    exit $?


<a id="org55fb690"></a>

## docker\_image\_check.sh     :code:

    set -e
    IMAGE_NAME="${1}"

    # * Install dockle and check targets
    # Pay attention: some checks are ignored using .dockleignore
    VERSION=$(
        curl --silent "https://api.github.com/repos/goodwithtech/dockle/releases/latest" | \
            grep '"tag_name":' | \
            sed -E 's/.*"v([^"]+)".*/\1/' \
           ) && docker run --rm \
                           -v /var/run/docker.sock:/var/run/docker.sock \
                           -v $(pwd)/.dockleignore:/.dockleignore \
                           goodwithtech/dockle:v"${VERSION}" \
                           --exit-code 1 \
                           --exit-level fatal \
                           "${IMAGE_NAME}"
    exit $?


<a id="orgac43aed"></a>

## .dockleignore     :code:

    # Use COPY instead of ADD in Dockerfile because need to add s6-overlay from urlencode
    CIS-DI-0009
    # Use latest tag because to check the image inside only
    DKL-DI-0006
    # set root to default user because it will be use for next build
    CIS-DI-0001


<a id="org6476d80"></a>

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
    docker run --rm -i hadolint/hadolint < "${targets[@]}" && echo "success"

    exit $?


<a id="org5c37212"></a>

## hook/build.sh     :code:

    # shellcheck disable=SC1091
    set -a; source ../VERSION ; set +a;

    docker build \
           --build-arg BUILD_DATE="$(date -u +"%Y-%m-%dT%H:%M:%SZ")" \
           --build-arg S6_OVERLAY_VERSION="${S6_OVERLAY_VERSION}" \
           --build-arg UBUNTU_VERSION="${UBUNTU_VERSION}" \
           -t oupfiz5/ubuntu-s6:"${UBUNTU_VERSION}" \
           -t oupfiz5/ubuntu-s6:latest \
           -f ../Dockerfile \
            ../.


<a id="org735e363"></a>

## hook/push.sh     :code:

    # shellcheck disable=SC1091
    set -a; source ../VERSION ; set +a;

    docker push oupfiz5/ubuntu-s6:"${UBUNTU_VERSION}"
    docker push oupfiz5/ubuntu-s6:latest


<a id="orgc64468e"></a>

## rootfs/etc/cont-finish.d/.gitignore     :code:notangle:


<a id="orgde889bd"></a>

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


<a id="orga4fcdc1"></a>

## rootfs/etc/fix-attrs.d/.gitignore     :code:notangle:


<a id="orga0a7732"></a>

## rootfs/etc/services.d/.gitignore     :code:notangle:
