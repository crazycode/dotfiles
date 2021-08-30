#!/bin/bash
cd ~/space/deploy/hyshi-vm-config/
git checkout .
git pull
cp front.conf /etc/hyshi
cp front.conf /etc/hyshi/oracle
