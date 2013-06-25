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
# Make directory chains, create files inside of them, change persmissions at
# various points in that chain, and then delete it.
#

set -o xtrace

ch_arg0=$(basename $0)
ch_root="/dev/rm-test"
ch_mfiles=30
ch_path=
ch_depth=10
ch_helper=
ch_rand=

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
	mkdir -p "$ch_root" || fatal "failed to make directory $path"
}

function create_files
{
	local path comps oldifs nfiles i
	comps=$1

	oldifs=$IFS
	IFS=/
	path="$ch_root"
	for c in $comps; do
		IFS=$oldifs
		path="$path/$c"
		mkdir -p $path
		nfiles=$((($RANDOM % $ch_mfiles)))
		for ((i = 0; i < $nfiles; i++)); do
			touch "$path/$(uuid)"
		done
		IFS=/
	done
	IFS=$oldifs
}

function chmod_files
{
	find $ch_root -mindepth 1 -exec $ch_helper '{}' \;
}

function remove_subtree
{
	local path nents

	path=$(./rand $(find $ch_root -type d -mindepth 1))
	if [[ -z "$path" ]]; then
		warn "nothing to remove"
		return
	fi

	rm -rf $rpath
}

function gen_path
{
	local i
	ch_path=""
	for ((i = 0; i < $ch_depth; i++)); do
		ch_path="$ch_path/$(uuid)"
	done
}

cd $(dirname $0)
ch_helper="$PWD/chmod-agent"
cd - > /dev/null
setup
gen_path
create_files $ch_path
while :; do
	ch_rand=$((($RANDOM % 10)))
	if [[ $ch_rand -lt 3 ]]; then
		gen_path
		create_files $ch_path
	elif [[ $ch_rand -lt 6 ]]; then
		remove_subtree
	else
		chmod_files
	fi
done
