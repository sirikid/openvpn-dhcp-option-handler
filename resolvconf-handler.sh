#!/bin/bash -eu

# $script_type and $dev are set by openvpn

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
        done | resolvconf -a "$dev"
        ;;

    (down)
        resolvconf -d "$dev"
        ;;
esac
