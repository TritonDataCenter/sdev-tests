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
# Create and destroy vnics over physical nics. We need to be good citizens and
# must not destroy any vnics that we did not create.
#

vn_phys=
vn_vnics=
vn_arg0=$(basename $0)
vn_id=0

function fatal
{
	local msg="$*"
	[[ -z "$msg" ]] && msg="failed"
	echo "$vn_arg0: $msg" >&2
	exit 1
}

function warn
{
	local msg="$*"
	[[ -z "$msg" ]] && msg="failed"
	echo "$vn_arg0: $msg" >&2
}

function get_phys
{
	vn_phys=$(dladm show-phys -po device)	
	[[ $? -eq 0 ]] || fatal "failed to get physical nics"
	[[ -z "$vn_phys" ]] && fatal "no physical nics found"
}

function clean_old
{
	local vnics
	vnics=$(dladm show-vnic -po LINK | grep test)
	for v in $vnics; do
		dladm delete-vnic $v
		[[ $? -eq 0 ]] || fatal "failed to clean up old vnic $v"
	done
}

function create_vnic
{
	local phys name
	phys=$(./rand $vn_phys)
	[[ $? -eq 0 ]] || fatal "failed to a pic a physical nic from $vn_phys"
	name="test$vn_id"
	dladm create-vnic -l $phys $name
	if [[ $? -eq 0 ]]; then
		((vn_id++))
		vn_vnics="$vn_vnics $name"
		warn "Created vnic $name"
	else
		warn "failed to create vnic $name"
	fi
}

function destroy_vnic
{
	local vnic
	if [[ -z "$vn_vnics" ]]; then
		warn "no vnics exist to destroy"
		return
	fi
	vnic=$(./rand $vn_vnics)
	dladm delete-vnic $vnic
	if [[ $? -eq 0 ]]; then
		warn "deleted vnic $vnic"
		vn_vnics=$(echo $vn_vnics | sed "s/$vnic//g")
	else
		warn "failed to delete vnic $vnic"
	fi
}

get_phys
clean_old
while :; do
	choice=$((( $RANDOM % 2 )))
	[[ $choice -eq 0 ]] && create_vnic	
	[[ $choice -eq 1 ]] && destroy_vnic 
done
