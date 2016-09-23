#!/bin/bash

run_hook()
{
	case ${RAMFS_RAIDCMD} in
		mdadm )
			cp_this mdadm
			cp_this /etc/mdadm.conf		
		;;
	esac

	mkdir -p ${_tmpdir}/lib/udev/rules.d
	cat > ${_tmpdir}/lib/udev/rules.d/95-dm-initrd.rules << "EOF"
KERNEL=="dm-[0-9]*", OPTIONS+="db_persist"
EOF

	return 0
}
