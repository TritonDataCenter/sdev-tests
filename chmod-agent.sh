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
# Works with chmoder.sh to do the dirty work. This makes writing the find
# command a great deal easier.
#

ch_arg0=$(basename $0)
ch_file=
ch_change=3
ch_perm=

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

function gen_perm
{
	ch_perm="$((($RANDOM % 8)))"
	ch_perm="$ch_perm$((($RANDOM % 8)))"
	ch_perm="$ch_perm$((($RANDOM % 8)))"
}

function do_chmod
{
	chmod $ch_perm $ch_file || fatal "failed to chmod $ch_perm $ch_file"
}

[[ $# -eq 1 ]] || fatal "missing requried file"
ch_file=$1
[[ $((($RANDOM % 10))) -lt $ch_change ]] || exit 0
gen_perm
do_chmod
