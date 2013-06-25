#!/usr/bin/bash
#
#
# This file and its contents are supplied under the terms of the
# Common Development and Distribution License ("CDDL"), version 1.0.
# You may only use this file in accordance with the terms of version
# 1.0 of the CDDL.
#
# A full copy of the text of the CDDL should have accompanied this
# source.  A copy of the CDDL is also available via the Internet at
# http://www.illumos.org/license/CDDL.
#

#
# Copyright (c) 2013 Joyent, Inc.  All rights reserved.
#

#
# You've got vms, I'll halt them and start them.
#

vm_arg0=$(basename $0)
vm_vms=

function fatal
{
	local msg="$*"
	[[ -z "$msg" ]] && msg="failed"
	echo "$ch_arg0: $msg" >&2
	exit 1
}

function warn
{
	local msg="$*"
	[[ -z "$msg" ]] && msg="failed"
	echo "$ch_arg0: $msg" >&2
}

function setup
{
	vm_vms=$(vmadm list -p -o uuid)
	[[ $? -eq 0 ]] || fatal "failed to list vms"
}

function do_vm
{
	local vm act
	act=$1
	vm=$(./rand $vm_vms)
	vmadm $act $vm
}

setup
while :; do
	vm_rand=$((($RANDOM % 2)))
	if [[ $vm_rand -eq 0 ]]; then
		do_vm start
	else
		do_vm halt	
	fi
done
