#!/bin/bash

yum install -y make bzip2 openssh-clients nano htop wget automake gcc cpp glibc-devel glibc-headers \
glibc-kernheaders glibc glibc-common libgcc zlib-devel openssl-devel readline-devel

#######################################################
# Build Ruby
#######################################################

# Keep it clean
mkdir /tmp/ruby
cd /tmp/ruby

# autoconf 2.60 is required to build ruby
wget http://ftp.gnu.org/gnu/autoconf/autoconf-2.60.tar.gz
tar -xzf autoconf-2.60.tar.gz
cd autoconf-2.60
./configure --prefix=/usr && make && make install
cd /tmp/ruby

# build ruby-1.8.7-p358
wget http://ftp.ruby-lang.org/pub/ruby/1.8/ruby-1.8.7-p358.tar.bz2
tar -xjf ruby-1.8.7-p358.tar.bz2
cd ruby-1.8.7-p358
autoconf
./configure --prefix=/usr && make && make install
cd /tmp/ruby

# install ruby-gems 1.8.10
wget http://production.cf.rubygems.org/rubygems/rubygems-1.8.10.tgz
tar -xzf rubygems-1.8.10.tgz
cd rubygems-1.8.10
/usr/bin/ruby setup.rb

# clean up
cd /
rm -rf /tmp/ruby

#######################################################
# Install Puppet
#######################################################
gem install puppet --no-rdoc --no-ri

# add the puppet group
groupadd puppet

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