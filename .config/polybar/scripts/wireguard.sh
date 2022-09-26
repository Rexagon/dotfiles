#!/bin/bash

set -e

green="#b8bb26"
gray="#999896"

configs_path="/etc/wireguard"
connected_interface=$(sudo wg show | grep -oP "interface: \K.*" | xargs)

connect() {
  selected_config=$(find "$configs_path" -name "*.conf" | xargs basename -a -s .conf | rofi -dmenu -p "Wireguard" -config ~/.config/rofi/config-dmenu.rasi)
  [[ $selected_config ]] && sudo wg-quick up $selected_config
}

disconnect() {
  for connected_config in $(sudo wg show | grep -oP "interface: \K.*"); do
    sudo wg-quick down $connected_config
  done
}

toggle() {
  if [[ $connected_interface ]]; then
    disconnect
  else
    connect
  fi
}

print() {
  if [[ $connected_interface ]]; then
    echo "%{u"$green"}%{+u}%{F"$gray"}$connected_interface%{-u}"
  else
    echo "%{T3}%{T-}"
  fi
}

case "$1" in
  --connect)
    connect
    ;;
  --disconnect)
    disconnect
    ;;
  --toggle)
    toggle
    ;;
  *)
    print
    ;;
esac
