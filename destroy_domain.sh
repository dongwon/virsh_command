#!/bin/bash
. ./hosts

virsh --connect $URL snapshot-delete $1 default
virsh --connect $URL destroy $1
virsh --connect $URL undefine $1
virsh --connect $URL vol-delete $1 --pool $POOL
