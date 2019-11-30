#!/bin/bash

echo $1

scp ~/Downloads/$1 root@10.122.69.131:/opt/mrbs

ssh root@10.122.69.131 "cd /opt/mrbs; ./tomcat-deploy.sh $1"
