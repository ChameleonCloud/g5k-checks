#! /bin/bash

./scripts/build_rpm.sh
yum -y remove rubygem-g5k-checks
yum localinstall -y /root/rpmbuild/RPMS/noarch/rubygem-g5k-checks-0.7.5-1.el7.noarch.rpm