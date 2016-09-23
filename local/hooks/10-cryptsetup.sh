#!/bin/bash

run_hook()
{
	cp_this cryptsetup

	if [ -n "${RAMFS_GPGKEY}" ]
	then
		if [ -f "${RAMFS_GPGKEY}" ]
		then
			cp_this ${RAMFS_GPGKEY}
		else
			warn "$(gettext 'GnuPG key for lukus open is defined but file does not exist')"
		fi
	fi
		
	return 0
}
