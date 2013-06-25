#!/bin/ksh
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
# Run all this stuff.
#

set -o xtrace

./vnic &
./zvol &

for i in $(seq 1 5); do
	./devfsadmer &
done

for i in $(seq 1 200); do
	./devsearcher &
done

for i in $(seq 1 25); do
	./chmoder &
done

for i in $(seq 1 7); do
	./vmadmer &
done
