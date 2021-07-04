# Table of Contents

-   [About](#org009ff23)
-   [Installation](#orgd5482c2)
    -   [Download from dockerhub](#org4510f01)
    -   [Build from chiselapp (fossil)](#orgd0a65fb)
    -   [Build from github](#orga30ee93)
-   [Configuration options](#orgfa742ca)
    -   [General options](#orgbb058bd)
    -   [Timezone](#orgf4fec00)
-   [Continues Integration](#org2104483)
-   [Troubleshooting](#org5207120)
    -   [Log output](#orgf991271)
    -   [Shell access](#org5dc48ea)
-   [Code](#orgce636ae):code:
    -   [VERSION](#orgf9f4889):code:
    -   [../.github/workflows/on-push.yaml](#org7acb648):code:
    -   [../.github/workflows/test.yaml](#org860d16d):code:
    -   [../.github/.trigger\_on\_push](#orgf041202):code:
    -   [../.gitignore](#org4b22659):code:
    -   [Dockerfile](#org0a67c7b):code:
    -   [hook/build.sh](#org60ab419):code:
    -   [hook/push.sh](#org05a7637):code:
    -   [rootfs/etc/cont-finish.d/.gitignore](#orgf489478):code:notangle:
    -   [rootfs/etc/cont-init.d/00\_settimezone.sh](#orgf38321a):code:
    -   [rootfs/etc/fix-attrs.d/.gitignore](#org495b961):code:notangle:
    -   [rootfs/etc/services.d/.gitignore](#org7d4fe31):code:notangle:
-   [Tests](#org63743a5):test:
    -   [01.shellchecks.bats](#orgdf5077b):test:
    -   [02.dockerfile\_check.bats](#org2c77e1b):test:
    -   [03.docker\_image\_check.bats](#org220fc47):test:
    -   [04.container\_check.bats](#org5993356):test:
    -   [.dockleignore](#orgce9b74d):test:



<a id="org009ff23"></a>

# About

This is [ubuntu base docker image](https://hub.docker.com/_/ubuntu) (version 20.04) using [s6-overlay](https://github.com/just-containers/s6-overlay).

Ubuntu-s6 is self-hosting at <https://chiselapp.com/user/oupfiz5/repository/ubuntu-s6>.

If you are reading this on GitHub, then you are looking at a Git mirror of the self-hosting Ubuntu-s6 repository.  The purpose of that mirror is to test and exercise Fossil's ability to export a Git mirror and using Github CI/CD  (Github Actions). Nobody much uses the GitHub mirror, except to verify that the mirror logic works. If you want to know more about Ubuntu-s6, visit the official self-hosting site linked above.


<a id="orgd5482c2"></a>

# Installation


<a id="org4510f01"></a>

## Download from dockerhub

    docker pull oupfiz5/ubuntu-s6:latest
    docker pull oupfiz5/ubuntu-s6:20.04


<a id="orgd0a65fb"></a>

## Build from chiselapp (fossil)

    fossil clone https://chiselapp.com/user/oupfiz5/repository/ubuntu-s6 ubuntu-s6.fossil
    mkdir ubuntu-s6
    cd ubuntu-s6
    fossil open ../ubuntu-s6.fossil
    docker build -t oupfiz5/ubuntu-s6 .


<a id="orga30ee93"></a>

## Build from github

    git clone https://github.com/oupfiz5/ubuntu-s6.git
    cd ubuntu-s6
    docker build -t oupfiz5/ubuntu-s6 .


<a id="orgfa742ca"></a>

# Configuration options


<a id="orgbb058bd"></a>

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


<a id="orgf4fec00"></a>

## Timezone

Set the timezone for the container, defaults to UTC. To set the
timezone set the desired timezone with the variable TZ.

    docker run -itd --restart always \
               --name ubuntu-s6  \
               --env 'TZ=Europe/Moscow' \
               oupfiz5/ubuntu-s6:latest


<a id="org2104483"></a>

# Continues Integration

For  build and push docker images we use  [Github Actions workflow](https://github.com/oupfiz5/ubuntu-s6/blob/master/.github/workflows/on-push.yaml). Flow process is [GitHub flow](https://guides.github.com/introduction/flow/).


<a id="org5207120"></a>

# Troubleshooting


<a id="orgf991271"></a>

## Log output

For debugging and maintenance purposes you may want access the output log. If you are using Docker version 1.3.0 or higher you can access a running containers shell by starting bash using docker interactive:

    docker run -it --rm \
           --name=ubuntu-s6 \
           oupfiz5/ubuntu-s6:latest


<a id="org5dc48ea"></a>

## Shell access

For debugging and maintenance purposes you may want access the containers shell. If you are using Docker version 1.3.0 or higher you can access a running containers shell by starting bash using docker exec:

    docker exec -it ubuntu-s6 /bin/bash


<a id="orgce636ae"></a>

# Code     :code:


<a id="orgf9f4889"></a>

## VERSION     :code:

    S6_OVERLAY_VERSION='2.2.0.3'
    UBUNTU_VERSION='20.04'


<a id="org7acb648"></a>

## ../.github/workflows/on-push.yaml     :code:

    name: Build and push docker images

    on:
      push:
        branches:
          - master
          - main
      pull_request:
        branches:
          - master
          - main

    jobs:
      build:
        name: Build and push image to dockerhub
        runs-on: ubuntu-latest
        steps:
          - name: Repo checkout
            uses: actions/checkout@v2

          - name: Login to DockerHub Registry
            run: |
              echo  ${{ secrets.DOCKERHUB_TOKEN }} | docker login --username ${{ secrets.DOCKERHUB_USERNAME }} --password-stdin

          - name: Build images
            run: |
              cd ${GITHUB_WORKSPACE}/src/hook
              ./build.sh

          - name: Push images
            run: |
              cd ${GITHUB_WORKSPACE}/src/hook
              ./push.sh


<a id="org860d16d"></a>

## ../.github/workflows/test.yaml     :code:

    name: Tests

    # * Controls
    # Controls when the action will run.
    on:
      push:
        paths:
          - '.github/workflows/*'
          - '.github/*'
          - 'src/Dockerfile'
          - 'src/rootfs/*'
          - 'src/hook/*'
          - 'src/*.sh'
          - 'tests/**'
        branches-ignore:
          - 'master'
          - 'main'
      pull_request:
        paths:
          - '.github/workflows/*'
          - '.github/*'
          - 'src/Dockerfile'
          - 'src/rootfs/*'
          - 'src/hook/*'
          - 'src/*.sh'
          - 'tests/**'
        branches-ignore:
          - 'master'
          - 'main'
      workflow_dispatch:

    # * Environments
    env:
      CONTAINER_NAME: "ubuntu-s6"
      IMAGE_NAME: "ubuntu-s6"
      IMAGE_TAG: "${{ github.sha }}"
      REPOSITORY: "oupfiz5"
      IMAGE: "${REPOSITORY}/${IMAGE_NAME}:${IMAGE_TAG}"

    # * Jobs
    jobs:
      checks:
        name: Checks
        runs-on: ubuntu-20.04
        steps:
          - name: Repo checkout
            uses: actions/checkout@v2

          - name: Check shell files (shellcheck)
            run: |
              sudo apt-get update -y
              sudo apt-get install shellcheck
              cd ${GITHUB_WORKSPACE}/tests
              .bats-battery/bats-core/bin/bats 01.shellchecks.bats

          - name: Check Dockerfile (hadolint)
            run: |
              cd ${GITHUB_WORKSPACE}/tests
              .bats-battery/bats-core/bin/bats 02.dockerfile_check.bats

          - name: Build image
            run: |
              cd ${GITHUB_WORKSPACE}/src
              set -a; source VERSION ; set +a;
              docker build \
              --build-arg BUILD_DATE="$(date -u +"%Y-%m-%dT%H:%M:%SZ")" \
              --build-arg S6_OVERLAY_VERSION="${S6_OVERLAY_VERSION}" \
              --build-arg UBUNTU_VERSION="${UBUNTU_VERSION}" \
              -t "${IMAGE}" \
              -f ./Dockerfile \
              .

          - name: Check docker image (dockle)
            run: |
              cd ${GITHUB_WORKSPACE}/tests
              .bats-battery/bats-core/bin/bats 03.docker_image_check.bats

          - name: Check docker container
            run: |
              cd ${GITHUB_WORKSPACE}/tests
              .bats-battery/bats-core/bin/bats 04.container_check.bats


<a id="orgf041202"></a>

## ../.github/.trigger\_on\_push     :code:

    Trigger:1


<a id="org4b22659"></a>

## ../.gitignore     :code:

    .fslckout
    .projectile


<a id="org0a67c7b"></a>

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


<a id="org60ab419"></a>

## hook/build.sh     :code:

    # shellcheck disable=SC1091
    set -a; source ../VERSION ; set +a;

    IMAGE="${IMAGE:-oupfiz5/ubuntu-s6:${UBUNTU_VERSION}}"

    docker build \
           --build-arg BUILD_DATE="$(date -u +"%Y-%m-%dT%H:%M:%SZ")" \
           --build-arg S6_OVERLAY_VERSION="${S6_OVERLAY_VERSION}" \
           --build-arg UBUNTU_VERSION="${UBUNTU_VERSION}" \
           -t "${IMAGE}" \
           -t oupfiz5/ubuntu-s6:latest \
           -f ../Dockerfile \
            ../.


<a id="org05a7637"></a>

## hook/push.sh     :code:

    # shellcheck disable=SC1091
    set -a; source ../VERSION ; set +a;

    # CIS-DI-0005: Enable Content trust for Docker
    # export DOCKER_CONTENT_TRUST=1

    docker push oupfiz5/ubuntu-s6:"${UBUNTU_VERSION}"
    docker push oupfiz5/ubuntu-s6:latest


<a id="orgf489478"></a>

## rootfs/etc/cont-finish.d/.gitignore     :code:notangle:


<a id="orgf38321a"></a>

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


<a id="org495b961"></a>

## rootfs/etc/fix-attrs.d/.gitignore     :code:notangle:


<a id="org7d4fe31"></a>

## rootfs/etc/services.d/.gitignore     :code:notangle:


<a id="org63743a5"></a>

# Tests     :test:


<a id="orgdf5077b"></a>

## 01.shellchecks.bats     :test:


    setup() {
        targets=()
        while IFS=  read -r -d $'\0'; do
            targets+=("$REPLY")
        done < <(
            find \
                ../src/rootfs/etc \
                ../src/hook \
                -type f \
                -print0
        )
    }

    @test "Check shell files" {
          run export LC_ALL=C.UTF-8; shellcheck "${targets[@]}"
          assert_success
    }

    @test "Check VERSION file" {
          run export LC_ALL=C.UTF-8; shellcheck --shell=sh --exclude=SC2034 ../src/VERSION
          assert_success
    }


<a id="org2c77e1b"></a>

## 02.dockerfile\_check.bats     :test:


    @test "Check Dockerfile" {
          run docker run --rm -i hadolint/hadolint < ../src/Dockerfile
          assert_success
    }


<a id="org220fc47"></a>

## 03.docker\_image\_check.bats     :test:


    setup() {
          IMAGE="${IMAGE:-oupfiz5/ubuntu-s6:latest}"
          VERSION=$(
          curl --silent "https://api.github.com/repos/goodwithtech/dockle/releases/latest" | \
              grep '"tag_name":' | \
              sed -E 's/.*"v([^"]+)".*/\1/' \
             )
      }

    @test "Check docker image" {
        run docker run --rm \
            -v /var/run/docker.sock:/var/run/docker.sock \
            -v "$(pwd)"/.dockleignore:/.dockleignore \
            goodwithtech/dockle:v"${VERSION}" \
            --exit-code 1 \
            --exit-level fatal \
            "${IMAGE}"
        assert_success
      }


<a id="org5993356"></a>

## 04.container\_check.bats     :test:


    setup() {
        export IMAGE="${IMAGE:-oupfiz5/ubuntu-s6:latest}"
        export CONTAINER_NAME="${CONTAINER_NAME:-ubuntu-s6}"
    }

    @test "Verify container run" {
          run docker run -d --rm --name="${CONTAINER_NAME}" "${IMAGE}"
          assert_success
    }

    @test "Verify state status container - running" {
          sleep 5
          run docker inspect --format 'result={{ .State.Status }}' "${CONTAINER_NAME}"
          assert_success
          assert_output 'result=running'
    }

    @test "Verify state running container - true" {
          run docker inspect --format 'result={{ .State.Running }}' "${CONTAINER_NAME}"
          assert_success
          assert_output 'result=true'
    }

    @test "Verify state restarting container - false" {
          run docker inspect --format 'result={{ .State.Restarting }}' "${CONTAINER_NAME}"
          assert_success
          assert_output 'result=false'
    }

    @test "Verify state error container - <empty>" {
          run docker inspect --format 'result={{ .State.Error }}' "${CONTAINER_NAME}"
          assert_success
          assert_output 'result='
    }

    @test "Verify restart count container - 0" {
          run docker inspect --format 'result={{ .RestartCount }}' "${CONTAINER_NAME}"
          assert_success
          assert_output 'result=0'
    }

    # @test "Verify AppArmor Profile - if applicable" {
    #       skip
    #       run docker inspect --format 'AppArmorProfile={{ .AppArmorProfile }}' "${CONTAINER_NAME}"
    #       assert_success
    #       refute_output "AppArmorProfile=[]"
    #       refute_output "AppArmorProfile="
    #       refute_output "AppArmorProfile=<no value>"
    # }

    @test "Verify container stop" {
          run docker container stop "${CONTAINER_NAME}"
          assert_success
    }


<a id="orgce9b74d"></a>

## .dockleignore     :test:

    # Use COPY instead of ADD in Dockerfile because need to add s6-overlay from urlencode
    CIS-DI-0009
    # Use latest tag because to check the image inside only
    DKL-DI-0006
    # set root to default user because it will be use for next build
    CIS-DI-0001
