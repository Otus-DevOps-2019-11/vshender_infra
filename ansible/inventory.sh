#!/bin/bash

function get_gcp_host_ip {
    echo $(cd ../terraform/stage && terraform show -json | jq ".values.root_module.child_modules[].resources[] | select(.address == \"$1\") | .values.network_interface[0].access_config[0].nat_ip")
}

case "$1" in
"--list")
    cat<<EOF
{
  "app": {
    "hosts": [
      $(get_gcp_host_ip "google_compute_instance.app")
    ]
  },
  "db": {
    "hosts": [
      $(get_gcp_host_ip "google_compute_instance.db")
    ]
  }
}
EOF
    ;;

"--host")
    cat<<EOF
{
  "_meta": {
    "hostvars": {}
  }
}
EOF
    ;;

*)
    echo "{}"
    ;;
esac
