# docker-alpine

[![License][license-img]][license-href]
[![docker][docker-img]][docker-href]

1. [Overview](#overview)
2. [Description](#description)
3. [Tags](#tags)
4. [Setup](#setup)
5. [Usage](#usage)
6. [Limitations](#limitations)
7. [Development](#development)
8. [Miscellaneous](#miscellaneous)

## Overview

Alpine Linux  is a security-oriented,  lightweight Linux distribution  based on
musl libc and busybox.

[alpinelinux.org][overview-href]

## Description

Use this script to build your own base system.

We've included the last ca-certificates files  in the repository to ensure that
all of our images are accurates.

## Tags

Supported tags.

- 3.5, 3.5.2
- 3.6, 3.6.2
- 3.7, 3.7.0
- 3.8, 3.8.2, 
- 3.9, 3.9.2, latest

## Setup

On Debian, Devuan and Ubuntu you need the following packages:

```bash
sudo apt-get -qq -y install curl
```

You also need to be in the docker group to use Docker.

```bash
sudo usermod -a -G docker ${USER}
```

Finally you need to login on Docker Hub.

```bash
docker login
```

## Usage

You first need to choose which dist between 3.5, 3.6, 3.7, 3.8 and 3.9 you want
(3.9 will be the 'latest' tag) and you need to choose you user (or organization)
name on Docker Hub.

Show help.

```bash
./build.sh -h
```

Build your own Alpine image (eg. 3.8).

```bash
./build.sh -d 3.8 -u vptech
```

Build your own Alpine image (eg. 3.9) and push it on the Docker Hub.

```bash
./build.sh -d 3.9 -u vptech -p
```

## Limitations

Only work on Debian, Devuan and Ubuntu.

## Development

Please read carefully [CONTRIBUTING.md][contribute-href]  before making a merge
request.

## Miscellaneous

```
    ╚⊙ ⊙╝
  ╚═(███)═╝
 ╚═(███)═╝
╚═(███)═╝
 ╚═(███)═╝
  ╚═(███)═╝
   ╚═(███)═╝
```

[license-img]: https://img.shields.io/badge/license-ISC-blue.svg
[license-href]: LICENSE
[docker-img]: https://img.shields.io/docker/pulls/vptech/alpine.svg
[docker-href]: https://hub.docker.com/r/vptech/alpine
[overview-href]: https://alpinelinux.org/
[contribute-href]: CONTRIBUTING.md
