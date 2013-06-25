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
# Yay team.
#

PROGS = \
	rand \
	vnic \
	zvol \
	devsearcher \
	devfsadmer \
	chmoder \
	chmod-agent \
	vmadmer \
	runner

CC = /opt/local/bin/gcc
CFLAGS = -Wall -Wextra
CP = /usr/bin/cp

%: %.c
	$(CC) $(CFLAGS) -o $@ $<

%: %.sh
	$(CP) $< $@
	chmod +x $@

install: $(PROGS)
	mkdir -p output
	$(CP) $(PROGS) output/

all: $(PROGS)

clean:
	rm -f $(PROGS)

clobber: clean
	rm -rf output
