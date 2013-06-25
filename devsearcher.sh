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
# Go around various directories in /dev, stick there for some time and continue
# on. This person is a bit slower, so you should fire off lots of them.
#

ds_root="/dev"
ds_arg0=$(basename $0)
ds_rand=

function fatal
{
	local msg="$*"
	[[ -z "$msg" ]] && msg="failed"
	echo "$ds_arg0: $msg" >&2
	exit 1
}

function warn
{
	local msg="$*"
	[[ -z "$msg" ]] && msg="failed"
	echo "$ds_arg0: $msg" >&2
}

function descend
{
	local nextdir
	nextdir=$($ds_rand $(find . -type d -mindepth 1 -maxdepth 1))
	if [[ -z "$nextdir" ]]; then
		nextdir=$ds_root
		warn "returning to $ds_root"
	else
		warn "descending to $nextdir"
	fi
	cd $nextdir
	if [[ $? -ne 0 ]]; then
		warn "failed to descend into $nextdir, returning to $ds_root"
		cd $ds_root	
	fi
}

function getrand
{
	cd $(dirname $0)
	ds_rand="$PWD/rand"	
	cd - > /dev/null
}

getrand
cd /dev
while :; do
	ls > /dev/null
	sleep 1
	ls > /dev/null
	descend
done
