#!/bin/bash

function print_help() {
    printf "USAGE:\n    wireguard.sh [options]\n\n"
    printf "OPTIONS:\n\n"
    printf "    --config CONFIG     Wireguard config name\n"
    printf "    --toggle            Toggle connection\n"
}

function connection_status() {
    local connection=$(
        sudo wg show dexpa 2>/dev/null \
            | head -n 1 \
            | awk '{print $NF}'
	)

    if [[ "$connection" == "$config" ]]; then
        echo "1"
    else
        echo "2"
    fi
}

config=""
toggle="false"
while [[ $# -gt 0 ]]; do
	key="$1"
	case $key in
		--config)
			config="$2"
            shift
            shift
            ;;

        --toggle)
            toggle="true"
            shift
            ;;

        --help)
            printf "Simple script for wg-quick polybar status\n\n"
            print_help
            exit 0
            ;;

        *)
            printf "error: Found unknown argument\n\n"
            print_help
            exit 0
            ;;
	esac
done

if [[ -z "$config" ]]; then
    echo "error: Config name is required"
    exit 1
fi

status="$(connection_status)"

if [[ "$toggle" = "true" ]]; then
    if [[ "$status" = "1" ]]; then
        sudo wg-quick down "$config" 2>/dev/null
    else
        sudo wg-quick up "$config" 2>/dev/null
    fi
else
    if [[ "$status" = "1" ]]; then
        echo "VPN: $config"
    else
        echo "VPN: off"
    fi
fi
