#!/bin/bash
source ./hosts

virsh --connect $URL $1 $2 $3
