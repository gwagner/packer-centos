#!/bin/bash

yum install -y make bzip2 openssh-clients htop wget automake gcc cpp \
    glibc-devel glibc-headers glibc-kernheaders glibc glibc-common libgcc \
    zlib-devel openssl-devel readline-devel gcc-c++ patch readline \
    readline-devel zlib libyaml-devel libffi-devel \
    autoconf libtool bison

#######################################################
# Fix sudo requiring tty under Vagrant
#######################################################
sed --in-place=".BAK" 's/Defaults\(.*\)requiretty/Defaults\1!requiretty/' /etc/sudoers

#######################################################
# Build Ruby
#######################################################

echo "?? Building Ruby 1.9"
# Keep it clean
mkdir /tmp/ruby
cd /tmp/ruby

# install yaml
wget http://pyyaml.org/download/libyaml/yaml-0.1.4.tar.gz
tar xzvf yaml-0.1.4.tar.gz
cd yaml-0.1.4 && ./configure --prefix=/usr && make && make install
cd /tmp/ruby

# build ruby-1.9.3-p484
wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p484.tar.bz2
tar -xjf ruby-1.9.3-p484.tar.bz2
cd ruby-1.9.3-p484
./configure --prefix=/usr && make && make install

# clean up
cd /
rm -rf /tmp/ruby

#######################################################
# Install Puppet
#######################################################
echo "?? Installing Puppet"
gem install puppet --no-rdoc --no-ri

# add the puppet group
groupadd puppet


#######################################################
# Install Chef
#######################################################
echo "?? Installing chef"
curl -L https://www.opscode.com/chef/install.sh | bash


#######################################################
# Turn off un-needed services
#######################################################
chkconfig sendmail off
chkconfig vbox-add-x11 off
chkconfig smartd off
chkconfig ntpd off
chkconfig cupsd off

########################################################
# Cleanup for compression
#######################################################
# Remove ruby build libs
yum -y remove zlib-devel openssl-devel readline-devel

# Cleanup other files we do not need
yum -y groupremove "Dialup Networking Support" Editors "Printing Support" "Additional Development" "E-mail server"

# Clean cache
yum clean all

# Clean out all of the caching dirs
rm -rf /var/cache/* /usr/share/doc/*
