{ writeShellScriptBin, envsubst }:

writeShellScriptBin "stura-default-config" ''
  if [[ $# -ne 3 ]]; then
    echo "Usage: stura-default-config [out-path] [hostname] [last-ip-block]"
    echo ""
    echo "out-path:        path to which the configuration will be written"
    echo "hostname:        path to which the configuration will be written"
    echo "last-ip-block:   last block of the IPv6 address of this host"
    exit 1
  fi
  
  OUT_PATH=$1
  export TARGET_HOSTNAME="$2"
  export LAST_IP_BLOCK="$3"

  ${envsubst}/bin/envsubst -i ${./config-template.txt} -o $OUT_PATH
''
