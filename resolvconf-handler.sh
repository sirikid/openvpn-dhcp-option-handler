#!/bin/bash -eu

# Copyright 2025 Ivan Sokolov
# SPDX-License-Identifier: Apache-2.0

# Example usage:
# up "/path/to/resolvconf-handler.sh -p -x --"

eval set -- "$(/bin/getopt -n "$0" -o h,m:,p,x -l help,metric:,private,exclusive -- "$@")"

while :
do
    case $1 in
        (-m|--metric) metric=$2; shift 2 ;;
        (-p|--private) private=1; shift ;;
        (-x|--exclusive) exclusive=1; shift ;;
        (--) shift; break ;;
    esac
done

# script_type and dev are set by openvpn

case $script_type in
    (up)
        for var in "${!foreign_option_@}"
        do
            case ${!var} in
                (dhcp-option\ DNS\ *)
                    echo nameserver "${!var:16}"
                    ;;

                (dhcp-option\ DOMAIN\ *)
                    echo search "${!var:19}"
                    ;;
            esac
        done | /sbin/resolvconf -a "$dev" ${metric:+-m "${metric}"} ${private:+-p} ${exclusive:+-x}
        /sbin/resolvconf -u
        ;;

    (down)
        /sbin/resolvconf -d "$dev"
        ;;
esac
