# Table of Contents

-   [About](#org3c476cc)
-   [Installation](#orgddb825a)
    -   [Download from dockerhub](#org0dff10a)
    -   [Build from chiselapp (fossil)](#orgceecc15)
    -   [Build from github](#org7649781)
-   [Configuration options](#org8a2cb82)
    -   [General options](#org2165096)
    -   [Timezone](#org4fcb056)
-   [Continues Integration](#org76b085e)
-   [Troubleshooting](#org30dd09a)
    -   [Log output](#org0d8ea5e)
    -   [Shell access](#org6fb467e)



<a id="org3c476cc"></a>

# About

This is [ubuntu base docker image](https://hub.docker.com/_/ubuntu) (version 20.04) using [s6-overlay](https://github.com/just-containers/s6-overlay).

Ubuntu-s6 is self-hosting at <https://chiselapp.com/user/oupfiz5/repository/ubuntu-s6>.

If you are reading this on GitHub, then you are looking at a Git mirror of the self-hosting Ubuntu-s6 repository.  The purpose of that mirror is to test and exercise Fossil's ability to export a Git mirror and using Github CI/CD  (Github Actions). Nobody much uses the GitHub mirror, except to verify that the mirror logic works. If you want to know more about Ubuntu-s6, visit the official self-hosting site linked above.


<a id="orgddb825a"></a>

# Installation


<a id="org0dff10a"></a>

## Download from dockerhub

    docker pull oupfiz5/ubuntu-s6:latest
    docker pull oupfiz5/ubuntu-s6:20.04


<a id="orgceecc15"></a>

## Build from chiselapp (fossil)

    fossil clone https://chiselapp.com/user/oupfiz5/repository/ubuntu-s6 ubuntu-s6.fossil
    mkdir ubuntu-s6
    cd ubuntu-s6
    fossil open ../ubuntu-s6.fossil
    docker build -t oupfiz5/ubuntu-s6 .


<a id="org7649781"></a>

## Build from github

    git clone https://github.com/oupfiz5/ubuntu-s6.git
    cd ubuntu-s6
    docker build -t oupfiz5/ubuntu-s6 .


<a id="org8a2cb82"></a>

# Configuration options


<a id="org2165096"></a>

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


<a id="org4fcb056"></a>

## Timezone

Set the timezone for the container, defaults to UTC. To set the
timezone set the desired timezone with the variable TZ.

    docker run -itd --restart always \
               --name ubuntu-s6  \
               --env 'TZ=Europe/Moscow' \
               oupfiz5/ubuntu-s6:latest


<a id="org76b085e"></a>

# Continues Integration

For  build and push docker images we use  [Github Actions workflow](https://github.com/oupfiz5/ubuntu-s6/blob/master/.github/workflows/on-push.yaml). Flow process is [GitHub flow](https://guides.github.com/introduction/flow/).


<a id="org30dd09a"></a>

# Troubleshooting


<a id="org0d8ea5e"></a>

## Log output

For debugging and maintenance purposes you may want access the output log. If you are using Docker version 1.3.0 or higher you can access a running containers shell by starting bash using docker interactive:

    docker run -it --rm \
           --name=ubuntu-s6 \
           oupfiz5/ubuntu-s6:latest


<a id="org6fb467e"></a>

## Shell access

For debugging and maintenance purposes you may want access the containers shell. If you are using Docker version 1.3.0 or higher you can access a running containers shell by starting bash using docker exec:

    docker exec -it ubuntu-s6 /bin/bash
