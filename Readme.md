# Table of Contents

-   [About](#h:53b0a7f5-76d9-4c40-a735-b6873507a6bc)
-   [Prerequisite](#h:9283ccc3-f6ff-4ca7-af60-6ba2827d1255)
    -   [Tools](#h:a3405a5c-7b6b-47d6-88e8-670a2a3e0ef9)
    -   [Third party tools](#h:ff933ce2-15ea-4e97-b285-9cb705d97adc)
-   [Installation](#h:19c8c605-bd2e-4a06-b30f-45160b56fe33)
    -   [Download from dockerhub](#h:749f3a93-53a9-461b-b6d4-f20b72a1f70d)
    -   [Build from chiselapp (fossil)](#h:cea39dc9-87ef-4950-966f-c58c4428021f)
    -   [Build from github](#h:3325841a-8fe0-443d-9c32-8a2c723c1b15)
-   [Configuration options](#h:7c3f1b20-a1be-48b4-8d46-276029aa244f)
    -   [General options](#h:daa5b735-9632-4d65-bc55-10fc29fa940e)
    -   [Timezone](#h:aaf92048-f4f1-42d5-b60b-525dde2e18c8)
-   [Continues Integration](#h:78c9b494-2e3e-4f81-a297-a0bde9141a2a)
-   [Troubleshooting](#h:6237bea9-415b-4fa0-bd47-df6a8743c1f7)
    -   [Log output](#h:d899a010-2e0b-474b-93ac-ae145a09decb)
    -   [Shell access](#h:0065f92d-56b9-454f-8224-79b322ab7132)



<a id="h:53b0a7f5-76d9-4c40-a735-b6873507a6bc"></a>

# About

This is [ubuntu base docker image](https://hub.docker.com/_/ubuntu) (version 20.04) using [s6-overlay](https://github.com/just-containers/s6-overlay).

Ubuntu-s6 is self-hosting at <https://chiselapp.com/user/oupfiz5/repository/ubuntu-s6>.

If you are reading this on GitHub, then you are looking at a Git mirror of the self-hosting Ubuntu-s6 repository.  The purpose of that mirror is to test and exercise Fossil's ability to export a Git mirror and using Github CI/CD  (Github Actions). Nobody much uses the GitHub mirror, except to verify that the mirror logic works. If you want to know more about Ubuntu-s6, visit the official self-hosting site linked above.


<a id="h:9283ccc3-f6ff-4ca7-af60-6ba2827d1255"></a>

# Prerequisite


<a id="h:a3405a5c-7b6b-47d6-88e8-670a2a3e0ef9"></a>

## Tools

1.  \*nix operation system
2.  Install Docker
3.  Install git (optional)
4.  Install fossil (optional)


<a id="h:ff933ce2-15ea-4e97-b285-9cb705d97adc"></a>

## Third party tools

They are using for testing and scanning:

1.  BATS
2.  Shellcheck
3.  Hadolynt
4.  Dockle
5.  Snyk
6.  Trivy


<a id="h:19c8c605-bd2e-4a06-b30f-45160b56fe33"></a>

# Installation


<a id="h:749f3a93-53a9-461b-b6d4-f20b72a1f70d"></a>

## Download from dockerhub

    docker pull oupfiz5/ubuntu-s6:latest
    docker pull oupfiz5/ubuntu-s6:20.04


<a id="h:cea39dc9-87ef-4950-966f-c58c4428021f"></a>

## Build from chiselapp (fossil)

    fossil clone https://chiselapp.com/user/oupfiz5/repository/ubuntu-s6 ubuntu-s6.fossil
    mkdir ubuntu-s6
    cd ubuntu-s6
    fossil open ../ubuntu-s6.fossil
    docker build -t oupfiz5/ubuntu-s6 .


<a id="h:3325841a-8fe0-443d-9c32-8a2c723c1b15"></a>

## Build from github

    git clone https://github.com/oupfiz5/ubuntu-s6.git
    cd ubuntu-s6
    docker build -t oupfiz5/ubuntu-s6 .


<a id="h:7c3f1b20-a1be-48b4-8d46-276029aa244f"></a>

# Configuration options


<a id="h:daa5b735-9632-4d65-bc55-10fc29fa940e"></a>

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


<a id="h:aaf92048-f4f1-42d5-b60b-525dde2e18c8"></a>

## Timezone

Set the timezone for the container, defaults to UTC. To set the
timezone set the desired timezone with the variable TZ.

    docker run -itd --restart always \
               --name ubuntu-s6  \
               --env 'TZ=Europe/Moscow' \
               oupfiz5/ubuntu-s6:latest


<a id="h:78c9b494-2e3e-4f81-a297-a0bde9141a2a"></a>

# Continues Integration

For  build and push docker images we use  [Github Actions workflow](https://github.com/oupfiz5/ubuntu-s6/blob/master/.github/workflows/on-push.yaml). Flow process is [GitHub flow](https://guides.github.com/introduction/flow/).


<a id="h:6237bea9-415b-4fa0-bd47-df6a8743c1f7"></a>

# Troubleshooting


<a id="h:d899a010-2e0b-474b-93ac-ae145a09decb"></a>

## Log output

For debugging and maintenance purposes you may want access the output log. If you are using Docker version 1.3.0 or higher you can access a running containers shell by starting bash using docker interactive:

    docker run -it --rm \
           --name=ubuntu-s6 \
           oupfiz5/ubuntu-s6:latest


<a id="h:0065f92d-56b9-454f-8224-79b322ab7132"></a>

## Shell access

For debugging and maintenance purposes you may want access the containers shell. If you are using Docker version 1.3.0 or higher you can access a running containers shell by starting bash using docker exec:

    docker exec -it ubuntu-s6 /bin/bash
