#!/bin/bash

#configuration script for AWS Radhat instance. 
#Installs apache, git, python, and django, and modifies a few permessions.
#Before running, make sure that you have inbound firewall rules set for: 
#      ssh on port 22
#      http on port 80
#      Custom port 8000 for django

echo "installing apache server"
sudo yum -y install httpd

echo "enabling apache server"
sudo systemctl enable httpd.service

echo "starting apache server"
sudo systemctl start httpd.service

echo "cloning branch from Grants github"
sudo yum -y install git
sudo git clone https://github.com/grantypantyyy/NTI-300-GG.git

echo "publishing content"
sudo cp NTI-300-GG/webgrant.html /var/www/html

echo "adjusting permissions"
sudo chmod 644 /var/www/html/webgrant.html
sudo setenforce 0

echo "installing apache server"
sudo yum -y install httpd

echo "enabling apache server"
sudo systemctl enable httpd.service

echo "starting apache server"
sudo systemctl start httpd.service

echo "cloning master branch from Grants github"
sudo yum -y install git
sudo git clone https://github.com/grantypantyyy/NTI-300-GG.git

echo "publishing content"
sudo cp NTI-300-GG/webgrant.html /var/www/html

echo "adjusting permissions"
sudo chmod 644 /var/www/html/webgrant.html
sudo setenforce 0

echo "installing python"
sudo yum -y install python

echo "current python version:"

python --version

echo "install virtualenv so we can give django its own version of python"

# here you can install with updates or without updates.  To install python pip with a full kernel upgrade (not somthing you would do in prod, but
# definately somthing you might do to your testing or staging server: sudo yum update

# for a prod install (no update)

# this adds the noarch release reposatory from the fedora project, wich contains python pip
# python pip is a package manager for python...

sudo rpm -iUvh https://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-8.noarch.rpm

sudo yum -y install python-pip

# Now we're installing virtualenv, which will allow us to create a python installation and environment, just for our Django server
sudo pip install virtualenv

cd /opt
# we're going to install our django libs in /opt, often used for optional or add-on.  /usr/local is also a perfectly fine place for new apps
# we want to make this env accisible to the ec2-user at first, because we don't want to have to run it as root.

sudo mkdir django
sudo chown -R ec2-user django

sleep 5

cd django
sudo virtualenv django-env

echo "activating virtualenv"

source /opt/django/django-env/bin/activate

echo "to switch out of virtualenv, type deactivate"

echo "now using:"

which python

sudo chown -R ec2-user /opt/django

echo "installing django"
 
pip install django


echo "django admin is version:"

django-admin --version

django-admin startproject project1

sudo yum -y install tree

echo "here's our new django project dir"

tree project1

echo "Making django server accessible from web"

source /opt/django/django-env/bin/activate

sudo chmod 644 /opt/django/project1/manage.py
sudo setenforce 0

cd /opt/django/project1

python manage.py runserver 0.0.0.0:8000

echo "go to https://docs.djangoproject.com/en/1.10/intro/tutorial01/"


