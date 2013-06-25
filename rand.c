/*
 * This file and its contents are supplied under the terms of the
 * Common Development and Distribution License ("CDDL"), version 1.0.
 * You may only use this file in accordance with the terms of version
 * 1.0 of the CDDL.
 *
 * A full copy of the text of the CDDL should have accompanied this
 * source.  A copy of the CDDL is also available via the Internet at
 * http://www.illumos.org/license/CDDL.
 */

/*
 * Copyright (c) 2013 Joyent, Inc.  All rights reserved.
 */

#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

int
main(int argc, const char *argv[])
{
	int idx;

	/* Make sure we account for ourselves */
	argc--;
	argv++;
	if (argc == 0)
		return (1);

	srand(gethrtime());
	idx = rand() % argc;
	printf("%s\n", argv[idx]);
	return (0);
}
