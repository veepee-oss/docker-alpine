#!/usr/bin/env bash
# shellcheck disable=SC1039
# shellcheck disable=SC2034

set -e

PATH='/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'

arch='amd64'
version='1.4'

function usage()
{
    cat <<EOF

NAME:
   build.sh - Docker images' builder of Alpine.

USAGE:
   build.sh -d <dist>

OPTIONS:
   -h, --help           Show help

   -d, --dist           Choose Alpine distribution
                        eg: 3.10, 3.11, 3.12, 3.13, 3.14, 3.15, 3.16, 3.18, 3.19, 3.20, 3.22

   -t, --timezone       Choose your preferred timezone
                        default: Europe/Amsterdam

   -u, --user           Docker Hub username or organisation
                        default: $USER

   -p, --push           Docker Hub push
                        default: no

   -l, --latest         Force the "latest"
                        default: 3.22

   -v, --verbose        Verbose mode

   -V, --version        Show version

VERSION:
   docker-alpine version: ${version}

EOF
}

function docker_bootstrap()
{
    # variables
    cdn="http://dl-cdn.alpinelinux.org"
    ftp="${cdn}/alpine/v${distid}/releases/x86_64"
    rootfs="${ftp}/alpine-minirootfs-${distname}-x86_64.tar.gz"
    image="/tmp/image-${distname}-${arch}"

    echo '-- bootstrap' 1>&3

    if [ "$(id -u)" -ne 0 ]
    then
        sudo='sudo'
    fi

    # clean old image
    if [ -f "${image}.tar" ]
    then
        ${sudo} rm -f "${image}.tar"
    fi

    if [ -f "${image}.tar.gz" ]
    then
        ${sudo} rm -f "${image}.tar.gz"
    fi

    if [ -d "/tmp/image-${distname}-${arch}" ]
    then
        ${sudo} rm -fr "${image}"
    fi

    # download minimal image
    echo " * download ${image}" 1>&3
    ${sudo} curl \
            --location \
            --output "${image}.tar.gz" \
            --silent \
            "${rootfs}"
    ${sudo} mkdir "${image}"
    ${sudo} tar \
            -x \
            -C "${image}" \
            -f "${image}.tar.gz" \
            --numeric-owner \
            -z

    # create /etc/timezone
    echo ' * /etc/timezone' 1>&3
    cat <<EOF | \
        ${sudo} tee "${image}/etc/timezone"
${timezone}
EOF

    # create /etc/resolv.conf
    echo ' * /etc/resolv.conf' 1>&3
    cat <<EOF | \
        ${sudo} tee "${image}/etc/resolv.conf"
nameserver 8.8.4.4
nameserver 8.8.8.8
EOF

    # create /etc/apk/repositories
    echo ' * /etc/apk/repositories' 1>&3
    cat <<EOF | \
        ${sudo} tee "${image}/etc/apk/repositories"
http://mirror.veepee.tech/alpine/v${distid}/main
http://mirror.veepee.tech/alpine/v${distid}/community
EOF

    # upgrade
    echo ' * apk upgrade' 1>&3
    ${sudo} chroot "${image}" sh -c \
            "apk update  -q && \
             apk upgrade -q"

    # add ca-certificates
    echo ' * apk add ca-certificates' 1>&3
    ${sudo} chroot "${image}" sh -c \
            "apk add -q ca-certificates"

    # add dumb-init
    echo ' * apk add dumb-init' 1>&3
    ${sudo} chroot "${image}" sh -c \
            "apk add -q dumb-init"

    # clean
    echo ' * clean image' 1>&3
    ${sudo} chroot "${image}" sh -c \
            "rm -f /var/cache/apk/*"

    # create archive
    if [ -f "${image}.tar" ]
    then
        ${sudo} rm "${image}.tar"
    fi
    ${sudo} tar -C "${image}" -c -f "${image}.tar" --numeric-owner .


}

# create images from bootstrap archive
function docker_import()
{
    echo "-- docker import from ${image}" 1>&3
    docker import "${image}.tar" "${user}alpine:${distname}"
    docker run "${user}alpine:${distname}" \
           echo " * build ${user}alpine:${distname}" 1>&3
    docker tag "${user}alpine:${distname}" "${user}alpine:${distid}"
    docker run "${user}alpine:${distid}" \
           echo " * build ${user}alpine:${distid}" 1>&3

    if [ "${distname}" = "${latest}" ]
    then
        docker tag "${user}alpine:${distname}" "${user}alpine:latest"
        docker run "${user}alpine:latest" \
               echo " * build ${user}alpine:latest" 1>&3
    fi
}

# push image to docker hub
function docker_push()
{
    echo "-- docker push" 1>&3
    echo " * push ${user}alpine:${distname}" 1>&3
    docker push "${user}alpine:${distname}"
    echo " * push ${user}alpine:${distid}" 1>&3
    docker push "${user}alpine:${distid}"

    if [ "${distname}" = "${latest}"  ]
    then
        echo " * push ${user}alpine:latest" 1>&3
        docker push "${user}alpine:latest"
    fi
}

while getopts 'hd:t:u:plvV' OPTIONS
do
    case ${OPTIONS} in
        h)
            # -h / --help
            usage
            exit 0
            ;;
        d)
            # -d / --dist
            dist=${OPTARG}
            ;;
        t)
            # -t / --timezone
            timezone=${OPTARG}
            ;;
        u)
            # -u / --user
            user="${OPTARG}/"
            ;;
        p)
            # -p / --push
            push='true'
            ;;
        l)
            # -l / --latest
            latest=${OPTARG}
            ;;
        v)
            # -v / --verbose
            verbose='true'
            ;;
        V)
            # -v / --version
            echo "${version}"
            exit 0
            ;;
        *)
            usage
            exit 1
            ;;
    esac
done

if [ ! -x "$(command -v curl)" ]
then
    echo "Please install curl (see README.md)"
    exit 1
fi

# -d / --dist
if [ -n "${dist}" ]
then
    case ${dist} in
        3.5|3.5.3)
            distname='3.5.3'
            distid='3.5'
            ;;
        3.6|3.6.5)
            distname='3.6.5'
            distid='3.6'
            ;;
        3.7|3.7.3)
            distname='3.7.3'
            distid='3.7'
            ;;
        3.8|3.8.5)
            distname='3.8.5'
            distid='3.8'
            ;;
        3.9|3.9.6)
            distname='3.9.6'
            distid='3.9'
            ;;
        3.10|3.10.9)
            distname='3.10.9'
            distid='3.10'
            ;;
        3.11|3.11.13)
            distname='3.11.13'
            distid='3.11'
            ;;
        3.12|3.12.12)
            distname='3.12.12'
            distid='3.12'
            ;;
        3.13|3.12.11)
            distname='3.13.11'
            distid='3.13'
            ;;
        3.14|3.14.7)
            distname='3.14.7'
            distid='3.14'
            ;;
        3.15|3.15.5)
            distname='3.15.5'
            distid='3.15'
            ;;
        3.16|3.16.1)
            distname='3.16.1'
            distid='3.16'
            ;;
        3.18|3.18.6)
            distname='3.18.6'
            distid='3.18'
            ;;
        3.19|3.19.1)
            distname='3.19.1'
            distid='3.19'
            ;;
        3.20|3.20.0)
            distname='3.20.0'
            distid='3.20'
            ;;
        3.22|3.22.0)
            distname='3.22.0'
            distid='3.22'
            ;;
        *)
            usage
            exit 1
            ;;
    esac
else
    usage
    exit 1
fi

# -t / --timezone
if [ -z "${timezone}" ]
then
    timezone='Europe/Amsterdam'
fi

# -u / --user
if [ -z "${user}" ]
then
    user=${USER}
fi

# -l / --latest
if [ -z "${latest}" ]
then
    latest='3.22'
fi

# -v / --verbose
if [ -z "${verbose}" ]
then
    exec 3>&1
    exec 1>/dev/null
    exec 2>/dev/null
else
    exec 3>&1
fi

docker_bootstrap
docker_import

if [ -n "${push}" ]
then
    docker_push
fi
# EOF
