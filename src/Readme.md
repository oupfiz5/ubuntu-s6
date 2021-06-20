# Table of Contents

-   [About](#org421b239)
-   [Installation](#orgde7df28)
    -   [Download from dockerhub](#org89f4af2)
    -   [Build from chiselapp (fossil)](#orga358a97)
    -   [Build from github](#orgfa898df)
-   [Configuration options](#org618c10f)
    -   [General options](#org581bd51)
    -   [Timezone](#orgb1e2202)
-   [CI/CD](#org4be944d)
-   [Troubleshooting](#org73517e8)
    -   [Log output](#org77d5089)
    -   [Shell access](#org2394c63)
-   [Code](#org13adaf0):code:
    -   [VERSION](#orgfa3d024):code:
    -   [../.github/workflows/on-push.yaml](#orge82bef1):code:
    -   [../.github/workflows/test.yaml](#org532570e):code:
    -   [../.github/.trigger\_on\_push](#org344ea45):code:
    -   [../.gitignore](#org5aff2d4):code:
    -   [Dockerfile](#org2b40a07):code:
    -   [shellcheck.sh](#org37d12bf):code:
    -   [docker\_image\_check.sh](#org0e36d1c):code:
    -   [.dockleignore](#org34cd3b5):code:
    -   [dockerfile\_check.sh](#org34862e5):code:
    -   [hook/build.sh](#org6000938):code:
    -   [hook/push.sh](#orgb708ae5):code:
    -   [rootfs/etc/cont-finish.d/.gitignore](#org05a7d8f):code:notangle:
    -   [rootfs/etc/cont-init.d/00\_settimezone.sh](#org2a5444a):code:
    -   [rootfs/etc/fix-attrs.d/.gitignore](#org3bdf1b0):code:notangle:
    -   [rootfs/etc/services.d/.gitignore](#org4b2b324):code:notangle:



<a id="org421b239"></a>

# About

This is [ubuntu base docker image](https://hub.docker.com/_/ubuntu) (version 20.04) using [s6-overlay](https://github.com/just-containers/s6-overlay).

Ubuntu-s6 is self-hosting at <https://chiselapp.com/user/oupfiz5/repository/ubuntu-s6>.

If you are reading this on GitHub, then you are looking at a Git mirror of the self-hosting Ubuntu-s6 repository.  The purpose of that mirror is to test and exercise Fossil's ability to export a Git mirror and using Github CI/CD  (Github Actions). Nobody much uses the GitHub mirror, except to verify that the mirror logic works. If you want to know more about Ubuntu-s6, visit the official self-hosting site linked above.


<a id="orgde7df28"></a>

# Installation


<a id="org89f4af2"></a>

## Download from dockerhub

    docker pull oupfiz5/ubuntu-s6:latest
    docker pull oupfiz5/ubuntu-s6:20.04


<a id="orga358a97"></a>

## Build from chiselapp (fossil)

    fossil clone https://chiselapp.com/user/oupfiz5/repository/ubuntu-s6 ubuntu-s6.fossil
    mkdir ubuntu-s6
    cd ubuntu-s6
    fossil open ../ubuntu-s6.fossil
    docker build -t oupfiz5/ubuntu-s6 .


<a id="orgfa898df"></a>

## Build from github

    git clone https://github.com/oupfiz5/ubuntu-s6.git
    cd ubuntu-s6
    docker build -t oupfiz5/ubuntu-s6 .


<a id="org618c10f"></a>

# Configuration options


<a id="org581bd51"></a>

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


<a id="orgb1e2202"></a>

## Timezone

Set the timezone for the container, defaults to UTC. To set the
timezone set the desired timezone with the variable TZ.

    docker run -itd --restart always \
               --name ubuntu-s6  \
               --env 'TZ=Europe/Moscow' \
               oupfiz5/ubuntu-s6:latest


<a id="org4be944d"></a>

# CI/CD

For  build and push docker images we use  [Github Actions workflow](https://github.com/oupfiz5/ubuntu-s6/blob/master/.github/workflows/on-push.yaml). Flow process is [GitHub flow](https://guides.github.com/introduction/flow/).


<a id="org73517e8"></a>

# Troubleshooting


<a id="org77d5089"></a>

## Log output

For debugging and maintenance purposes you may want access the output log. If you are using Docker version 1.3.0 or higher you can access a running containers shell by starting bash using docker interactive:

    docker run -it --rm \
           --name=ubuntu-s6 \
           oupfiz5/ubuntu-s6:latest


<a id="org2394c63"></a>

## Shell access

For debugging and maintenance purposes you may want access the containers shell. If you are using Docker version 1.3.0 or higher you can access a running containers shell by starting bash using docker exec:

    docker exec -it ubuntu-s6 /bin/bash


<a id="org13adaf0"></a>

# Code     :code:


<a id="orgfa3d024"></a>

## VERSION     :code:

    S6_OVERLAY_VERSION='2.2.0.3'
    UBUNTU_VERSION='20.04'


<a id="orge82bef1"></a>

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


<a id="org532570e"></a>

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


<a id="org344ea45"></a>

## ../.github/.trigger\_on\_push     :code:

    Trigger:1


<a id="org5aff2d4"></a>

## ../.gitignore     :code:

    .fslckout
    .projectile


<a id="org2b40a07"></a>

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


<a id="org37d12bf"></a>

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


<a id="org0e36d1c"></a>

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
                           -v "$(pwd)"/.dockleignore:/.dockleignore \
                           goodwithtech/dockle:v"${VERSION}" \
                           --exit-code 1 \
                           --exit-level fatal \
                           "${IMAGE_NAME}"
    exit $?


<a id="org34cd3b5"></a>

## .dockleignore     :code:

    # Use COPY instead of ADD in Dockerfile because need to add s6-overlay from urlencode
    CIS-DI-0009
    # Use latest tag because to check the image inside only
    DKL-DI-0006
    # set root to default user because it will be use for next build
    CIS-DI-0001


<a id="org34862e5"></a>

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


<a id="org6000938"></a>

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


<a id="orgb708ae5"></a>

## hook/push.sh     :code:

    # shellcheck disable=SC1091
    set -a; source ../VERSION ; set +a;

    docker push oupfiz5/ubuntu-s6:"${UBUNTU_VERSION}"
    docker push oupfiz5/ubuntu-s6:latest


<a id="org05a7d8f"></a>

## rootfs/etc/cont-finish.d/.gitignore     :code:notangle:


<a id="org2a5444a"></a>

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


<a id="org3bdf1b0"></a>

## rootfs/etc/fix-attrs.d/.gitignore     :code:notangle:


<a id="org4b2b324"></a>

## rootfs/etc/services.d/.gitignore     :code:notangle:
