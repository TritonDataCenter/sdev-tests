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
# Just sit in a loop and run devfsadm sleeping every 30 seconds between rounds.
#

ds_arg0=$(basename $0)
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

function dv_clean
{
	if devfsadm -C > /dev/null; then
		warn "devfsadm clean succeeded"
	else
		warn "devfsadm clean failed"
	fi
}

function dv_build
{
	if devfsadm > /dev/null; then
		warn "devfsadm build succeeded"
	else
		warn "devfsadm build failed"
	fi
}

while :; do
	choice=$((( $RANDOM % 2 )))
	[[ $choice -eq 0 ]] && dv_clean
	[[ $choice -eq 1 ]] && dv_build
	sleep 30
done
