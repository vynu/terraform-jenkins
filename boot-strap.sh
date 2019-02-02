#!/bin/sh
yum update -y
yum install java -y
yum install docker -y
service docker start
yum install wget -y
wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins.io/redhat/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
yum install jenkins -y
service jenkins start
            
