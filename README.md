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
