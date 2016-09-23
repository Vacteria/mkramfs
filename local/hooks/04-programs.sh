#!/bin/bash

run_hook()
{
	if [ -x "${RAMFS_BUSYBOX}" ]
	then
		cp_this -d /bin/busybox ${RAMFS_BUSYBOX}
		chroot ${_tmpdir} /bin/busybox --install -s
	else
		die "$(gettext 'Unable to find busybox binary')"
	fi
	
	cp_this lsblock
	
	[ -L "${_tmpdir}/linuxrc" ] && rm -f ${_tmpdir}/linuxrc
}
