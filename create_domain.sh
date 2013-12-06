#!/bin/bash
DOMAIN_NAME=$1
CPUS=1
RAM=1024
DISK_SIZE=8
FORMAT=qcow2

. ./hosts

#OS_VARIANT=rhel5.4
#LOCATION="http://repo.donga.ktc/mirrors/centos/5/os/x86_64/"
#LOCATION="http://repo.donga.ktc/mirrors/rhel/5/"
#KS=http://repo.donga.ktc/ks/centos5.cfg
#KS=http://repo.donga.ktc/ks/rhel5.cfg

#OS_VARIANT=rhel6
#LOCATION="http://repo.donga.ktc/mirrors/centos/6/os/x86_64/"
#LOCATION="http://repo.donga.ktc/mirrors/rhel/6/"
#KS=http://repo.donga.ktc/ks/centos6.cfg
#KS=http://repo.donga.ktc/ks/rhel6.cfg

OS_VARIANT=ubuntuprecise
LOCATION="http://repo.donga.ktc/mirrors/ubuntu/dists/precise/main/installer-amd64/"
KS=http://repo.donga.ktc/ks/ubuntu.cfg

BR1=br-ext
BR2=br-int
BR3=br-sec
BR4=br-isol

virsh --connect $URL vol-create-as $POOL $DOMAIN_NAME "$DISK_SIZE"G --allocation "$DISK_SIZE"G --format $FORMAT
VOL_PATH=$(virsh --connect $URL vol-list --pool $POOL | grep $DOMAIN_NAME | awk '{print $2}')

## Installation using PXE
#virt-install \
#--connect $URL \
#--virt-type kvm \
#--name $DOMAIN_NAME \
#--ram $RAM \
#--vcpus=$CPUS \
#--disk=$VOL_PATH,size=$DISK_SIZE,bus=virtio,cache=writeback,sparse=true,format=$FORMAT \
#--network bridge=$BR1,model=virtio \
#--os-variant $OS_VARIANT \
#--vnc \
#--pxe \

## Installation using local location
virt-install \
--connect $URL \
--virt-type kvm \
--name $DOMAIN_NAME \
--ram $RAM \
--vcpus=$CPUS \
--disk=$VOL_PATH,size=$DISK_SIZE,bus=virtio,cache=writeback,sparse=true,format=$FORMAT \
--network bridge=$BR1,model=virtio \
--os-variant $OS_VARIANT \
--location=$LOCATION \
--graphics none \
--extra-args "ks=$KS ksdevice=eth0 console=tty0 console=ttyS0,115200"



