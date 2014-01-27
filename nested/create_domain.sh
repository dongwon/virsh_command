#!/bin/bash
DOMAIN_NAME=$1
CPUS=6
RAM=10240
PRI_DISK_SIZE=15
SEC_DISK_SIZE=300
FORMAT=raw
#FORMAT=qcow2

OS_VARIANT=ubuntuprecise
LOCATION="http://repo.donga.ktc/mirrors/ubuntu/dists/precise-updates/main/installer-amd64/"
#LOCATION="http://repo.donga.ktc/mirrors/ubuntu/dists/precise/main/debian-installer/"
#PRE_CONF="ks=http://repo.donga.ktc/ks/ubuntu-vm.cfg"
PRE_CONF="url=http://repo.donga.ktc/ks/ubuntu-vm.cfg"

BR1=br-ext
BR2=br-int

PRI_POOL=ssd
SEC_POOL=disk

# PRI(SSD)
virsh vol-create-as $PRI_POOL $DOMAIN_NAME "$PRI_DISK_SIZE"G --allocation "$PRI_DISK_SIZE"G --format $FORMAT
PRI_VOL_PATH=$(virsh vol-list --pool $PRI_POOL | grep $DOMAIN_NAME | awk '{print $2}')

# SEC(DISK)
virsh vol-create-as $SEC_POOL $DOMAIN_NAME "$SEC_DISK_SIZE"G --allocation "$SEC_DISK_SIZE"G --format $FORMAT
SEC_VOL_PATH=$(virsh vol-list --pool $SEC_POOL | grep $DOMAIN_NAME | awk '{print $2}')


## Installation using local location
virt-install \
--virt-type kvm \
--name $DOMAIN_NAME \
--ram $RAM \
--vcpus=$CPUS \
--cpu core2duo,match=exact,require=vmx \
--disk=$PRI_VOL_PATH,size=$PRI_DISK_SIZE,bus=virtio,cache=writeback,sparse=true,format=$FORMAT \
--disk=$SEC_VOL_PATH,size=$SEC_DISK_SIZE,bus=virtio,cache=writeback,sparse=true,format=$FORMAT \
--network bridge=$BR1,model=virtio \
--network bridge=$BR2,model=virtio \
--os-variant $OS_VARIANT \
--location=$LOCATION \
--graphics none \
--extra-args "auto=true hostname=precise interface=eth0 $PRE_CONF console=tty0 console=ttyS0,115200"
