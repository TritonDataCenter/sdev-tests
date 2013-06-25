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
# Create and destroy zvols ad nauseum
#

zv_arg0=$(basename $0)
zv_test="zones/rm-test"
zv_devpath="/dev/zvol/dsk/$zv_test"

function fatal
{
	local msg="$*"
	[[ -z "$msg" ]] && msg="failed"
	echo "$zv_arg0: $msg" >&2
	exit 1
}

function warn
{
	local msg="$*"
	[[ -z "$msg" ]] && msg="failed"
	echo "$zv_arg0: $msg" >&2
}

function cleanup
{
	if zfs list -po name | grep -q $zv_test; then
		zfs destroy -r $zv_test
		[[ $? -eq 0 ]] || fatal "failed to clean up old datasets"
	fi
}

function setup_dataset
{
	zfs create $zv_test || fatal "failed to create $zv_test dataset"	
}

function create_ds
{
	local name
	name="$zv_test/$(uuid)"
	zfs create "$name" || warn "failed to create dataset $name"
	warn "created dataset $name"
}

function destroy_ds
{
	local ds rand
	rand=$(./rand $(ls "$zv_devpath"))
	if [[ -z "$rand" ]]; then
		warn "no datasets to destroy"
		return
	fi
	ds="$zv_test/$rand"
	zfs destroy $ds
	if [[ $? -eq 0 ]]; then
		warn "destroyed dataset $ds"
	else
		warn "failed to destroy dataset $ds"
	fi
}

cleanup
setup_dataset
while :; do
	choice=$((( $RANDOM % 2 )))
	[[ $choice -eq 0 ]] && create_ds
	[[ $choice -eq 1 ]] && destroy_ds
done
