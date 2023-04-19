#!/bin/bash
yum update -y
hostnamectl set-hostname "gravserver"

tee -a /etc/yum.repos.d/graviteeio.repo <<EOF
[graviteeio]
name=graviteeio
baseurl=https://packagecloud.io/graviteeio/rpms/el/7/\$basearch
gpgcheck=0
enabled=1
gpgkey=https://packagecloud.io/graviteeio/rpms/gpgkey
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300
EOF

yum install pygpgme yum-utils -y

yum -q makecache -y --disablerepo='*' --enablerepo='graviteeio'

#Enable the repository that contains java:
amazon-linux-extras enable java-openjdk11
#Install Java
yum install java-11-openjdk -y

#Create a file called /etc/yum.repos.d/mongodb-org-3.6.repo
tee -a /etc/yum.repos.d/graviteeio.repo <<EOF
[mongodb-org-3.6]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2013.03/mongodb-org/3.6/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-3.6.asc
EOF

#Install MongoDB
yum install mongodb-org -y
systemctl daemon-reload
systemctl enable mongod
systemctl start mongod

# Create a file called /etc/yum.repos.d/elasticsearch.repo
tee -a /etc/yum.repos.d/elasticsearch.repo <<EOF
[elasticsearch]
name=Elasticsearch repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=0
autorefresh=1
type=rpm-md
EOF

# Install Elasticsearch
yum install --enablerepo=elasticsearch elasticsearch -y
# Enable Elasticsearch on startup
systemctl daemon-reload
systemctl enable elasticsearch.service
systemctl start elasticsearch.service

# Create a file called /etc/yum.repos.d/nginx.repo
tee -a /etc/yum.repos.d/nginx.repo <<EOF
[nginx-stable]
name=nginx stable repo
baseurl=http://nginx.org/packages/amzn2/\$releasever/\$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true
EOF

# Install Nginx
yum install nginx -y
systemctl daemon-reload
systemctl enable nginx
# Start Nginx
systemctl start nginx

# Install all Gravitee APIM components
yum install graviteeio-apim-3x -y

# Enable Gateway and REST API on startup:

systemctl daemon-reload
systemctl enable graviteeio-apim-gateway
systemctl enable graviteeio-apim-rest-api

# Start Gateway and REST API:

systemctl start graviteeio-apim-gateway
systemctl start graviteeio-apim-rest-api

# Restart Nginx:

systemctl restart nginx

# Remove the http://localhost:8083 from the baseURL
perl -pi -e 's/"baseURL": "http:\/\/localhost:8083/"baseURL": "/g' /opt/graviteeio/apim/portal-ui/assets/config.json

# Restart Nginx:
systemctl restart nginx
