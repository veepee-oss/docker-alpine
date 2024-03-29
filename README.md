# alpine

1. [Overview](#overview)
1. [Description](#description)
1. [Tags](#tags)
1. [Setup](#setup)
1. [Usage](#usage)
1. [Limitations](#limitations)
1. [Development](#development)
1. [Miscellaneous](#miscellaneous)

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

- 3.5
- 3.6
- 3.7
- 3.8
- 3.9
- 3.10
- 3.11
- 3.12
- 3.13
- 3.14
- 3.15, latest

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

You first  need to  choose which dist  between 3.5, 3.6,  3.7, 3.8,  3.9, 3.10,
3.11, 3.12  or 3.13 you want  (3.13 will be the  'latest' tag) and you  need to
choose you user (or organization) name on Docker Hub.

Show help.

```bash
./build.sh -h
```

Build your own Alpine image (eg. 3.12).

```bash
./build.sh -d 3.12 -u vptech
```

Build your own Alpine image (eg. 3.13) and push it on the Docker Hub.

```bash
./build.sh -d 3.13 -u vptech -p
```

## Limitations

Only work on Debian, Devuan and Ubuntu.

## Development

Please read carefully [CONTRIBUTING.md](CONTRIBUTING.md) before making a merge
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
