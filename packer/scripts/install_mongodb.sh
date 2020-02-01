#!/usr/bin/env sh

wget -qO - http://www.mongodb.org/static/pgp/server-3.2.asc | sudo apt-key add -
echo "deb [ arch=amd64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.2.list

apt update
apt install -y mongodb-org

systemctl start mongod
systemctl enable mongod
