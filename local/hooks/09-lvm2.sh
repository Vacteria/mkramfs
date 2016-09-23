#!/bin/bash

run_hook()
{
	local links i
	
	links="
		pvs vgremove vgmerge vgconvert vgexport lvdisplay lvconvert pvck
		pvchange vgreduce pvdisplay lvmchange pvscan vgcreate vgdisplay
		lvmsar lvmdiskscan pvremove vgcfgbackup vgs pvcreate lvs vgmknodes
		lvmsadc vgrename vgextend vgck vgchange vgscan lvreduce lvscan
		lvextend pvresize lvremove lvcreate lvrename lvchange vgcfgrestore
		pvmove vgsplit vgimport lvresize
	"
	cp_this lvm
	cp_this dmsetup
	
	{ cd ${_tmpdir}/sbin
		for i in ${links}
		do
			ln -sf lvm ${i}
		done
	}
		
	mkdir -p ${_tmpdir}/lib/udev/rules.d
	cat > ${_tmpdir}/lib/udev/rules.d/95-dm-initrd.rules << "EOF"
KERNEL=="dm-[0-9]*", OPTIONS+="db_persist"
EOF

	return 0
}
