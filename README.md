# vshender_infra

vshender Infra repository


## Homework #4: play-travis

- Slack integration was enabled
- Travis CI integration was enabled
- PR template was added
- Python test was fixed

In order to check the solution, you can see [the CI job result](https://travis-ci.com/Otus-DevOps-2019-11/vshender_infra/builds/145112121).


## Homework #5: cloud-bastion

- GCP account was created
- Two VMs (`bastion` and `someinternalhost`) were created
- Connection to `someinternalhost` via `bastion` was configured
- Connection to `someinternalhost` via VPN was configured (based on Pritunl)
- SSL certificate was configured using Let's Encrypt

Host IP addresses:
```
bastion_IP = 34.65.22.212
someinternalhost_IP = 10.172.0.3
```

To directly access the internal host via the bastion host the following command can be used:

```
ssh -A -t appuser@34.65.22.212 ssh 10.172.0.3
```

Contents of the `.ssh/config` file for accessing the hosts using aliases:

```
Host bastion
    Hostname 34.65.22.212
    User appuser
    IdentityFile ~/.ssh/appuser

Host someinternalhost
    User appuser
    IdentityFile ~/.ssh/appuser
    ProxyCommand ssh -q bastion nc -q0 10.172.0.3 22
```

In order to check the solution, you can see [the CI job result](https://travis-ci.com/Otus-DevOps-2019-11/vshender_infra/builds/145504413).


## Homework #6: cloud-testapp

- Installation and deployment scripts are created
- Startup script is created
- The command to create a VM was added to the readme file
- The command to create a firewall rule was added to the readme file

Test application address:
```
testapp_IP = 34.76.189.129
testapp_port = 9292
```

The command to create a VM:
```
$ gcloud compute instances create reddit-app \
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --metadata-from-file startup-script=startup_script.sh
```

The command to create a firewall rule:
```
$ gcloud compute firewall-rules create default-puma-server \
  --network=default \
  --priority=1000 \
  --direction=INGRESS \
  --action=ALLOW \
  --rules=tcp:9292 \
  --source-ranges=0.0.0.0/0 \
  --target-tags=puma-server
```
