#!/usr/bin/env bash

# -----------------------------------------------------------------------------

# allow running the jobs by hand
[ -z "${NETDATA_INSTALL_PATH}" ] && export NETDATA_INSTALL_PATH="${1-/opt/netdata}"
[ -z "${NETDATA_MAKESELF_PATH}" ] && export NETDATA_MAKESELF_PATH="$(dirname "${0}")/.."
[ "${NETDATA_MAKESELF_PATH:0:1}" != "/" ] && export NETDATA_MAKESELF_PATH="$(pwd)/${NETDATA_MAKESELF_PATH}"
[ -z "${NETDATA_SOURCE_PATH}" ] && export NETDATA_SOURCE_PATH="${NETDATA_MAKESELF_PATH}/.."
[ -z "${PROCESSORS}" ] && export PROCESSORS=$(cat /proc/cpuinfo 2>/dev/null | grep ^processor | wc -l)
[ -z "${PROCESSORS}" -o $((PROCESSORS)) -lt 1 ] && export PROCESSORS=1


# debug
echo "ME=${0}"
echo "NETDATA_INSTALL_PATH=${NETDATA_INSTALL_PATH}"
echo "NETDATA_MAKESELF_PATH=${NETDATA_MAKESELF_PATH}"
echo "NETDATA_SOURCE_PATH=${NETDATA_SOURCE_PATH}"
echo "PROCESSORS=${PROCESSORS}"

# bash strict mode
set -euo pipefail

# -----------------------------------------------------------------------------

fetch() {
    local dir="${1}" url="${2}"
    local tar="${dir}.tar.gz"

    if [ ! -f "${NETDATA_MAKESELF_PATH}/tmp/${tar}" ]
        then
        run wget -O "${NETDATA_MAKESELF_PATH}/tmp/${tar}" "${url}"
    fi
    
    if [ ! -d "${NETDATA_MAKESELF_PATH}/tmp/${dir}" ]
        then
        cd "${NETDATA_MAKESELF_PATH}/tmp"
        run tar -zxvpf "${tar}"
        cd -
    fi

    run cd "${NETDATA_MAKESELF_PATH}/tmp/${dir}"
}

# -----------------------------------------------------------------------------

# load the functions of the netdata-installer.sh
. "${NETDATA_SOURCE_PATH}/installer/functions.sh"
