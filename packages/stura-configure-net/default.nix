{ writeShellScriptBin, iproute2 }:

writeShellScriptBin "stura-configure-net" ''
  if [[ $# -ne 2 ]]; then
    echo "Usage: stura-configure-net [interface] [last-ip-block]"
    echo ""
    echo "interface:       name of the network interface to configure"
    echo "last-ip-block:   last block of the IPv6 address of this host"
    exit 1
  fi

  INTERFACE=$1
  LAST_IP_BLOCK=$2

  ${iproute2}/bin/ip link set up $INTERFACE
  ${iproute2}/bin/ip a a 2001:638:904:ffd0::$LAST_IP_BLOCK/64 dev $INTERFACE
  ${iproute2}/bin/ip r a default via 2001:638:904:ffd0::1

  echo "nameserver 2606:4700:4700::1111" > /etc/resolv.conf
''
