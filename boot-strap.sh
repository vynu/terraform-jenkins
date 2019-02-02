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
groupadd docker
usermod -aG docker ec2-user
usermod -aG docker jenkins
curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
aws s3 cp s3://tf-files-repo/project-files/docker-compose.yml /home/ec2-user/
cd /home/ec2-user/
docker-compose up -d
yum install git -y
cat /var/lib/jenkins/secrets/initialAdminPassword > jenkins-pswd.txt
aws s3 cp jenkins-pswd.txt s3://tf-files//jenkins-files/jenkins-pswd.txt
aws s3 cp s3://tf-files-repo/.aws /home/ec2-user/.aws/ --recursive
