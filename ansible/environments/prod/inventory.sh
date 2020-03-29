#!/bin/bash

function get_gcp_host_ip {
    echo $(cd ../terraform/prod && terraform show -json | jq ".values.root_module.child_modules[].resources[] | select(.address == \"$1\") | .values.network_interface[0].access_config[0].nat_ip")
}

function get_output_var {
    echo $(cd ../terraform/prod && terraform output | grep "$1" | awk '{ print $3 }')
}

case "$1" in
"--list")
    cat<<EOF
{
  "app": {
    "hosts": [
      $(get_gcp_host_ip "google_compute_instance.app")
    ],
    "vars": {
      db_host: $(get_output_var "db_ip")
    }
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
