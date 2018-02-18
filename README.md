# docker-alpine
[![License][license-img]][license-href]
[![pipeline][pipeline-img]][pipeline-href]
[![docker][docker-img]][docker-href]

## Overview

Alpine Linux  is a security-oriented,  lightweight Linux distribution  based on
musl libc and busybox.

[alpinelinux.org](https://alpinelinux.org/)

## Description

Use this script to build your own base system.

We've included the last ca-certificates files  in the repository to ensure that
all of our images are accurates.

## Tags

Supported tags.

- 3.5, 3.5.2
- 3.6, 3.6.2
- 3.7, 3.7.0, latest

## Requirements

On Debian, Devuan and Ubuntu you need the following packages:

```bash
sudo apt-get -qq -y install wget
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

You first need to choose which dist between 3.5, 3,6 and 3.7 you want (3.7 will
be the 'latest' tag) and you need  to choose you user (or organization) name on
Docker Hub.

Show help.

```bash
./build.sh -h
```

Build your own Alpine image (eg. 3.6).

```bash
./build.sh -d 3.6 -u vpgrp
```

Build your own Alpine image (eg. 3.7) and push it on the Docker Hub.

```bash
./build.sh -d 3.7 -u vpgrp -p
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

[license-img]: https://img.shields.io/badge/license-Apache-blue.svg
[license-href]: /LICENSE
[pipeline-img]: https://git.vpgrp.io/docker/docker-alpine/badges/master/pipeline.svg
[pipeline-href]: https://git.vpgrp.io/docker/docker-alpine/commits/master
[docker-img]: https://img.shields.io/docker/pulls/vpgrp/alpine.svg
[docker-href]: https://registry.hub.docker.com/u/vpgrp/alpine
[contribute-href]: /CONTRIBUTING.md
