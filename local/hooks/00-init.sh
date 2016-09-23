#!/bin/bash

run_hook()
{
	[ ! -d ${_tmpdir} ] && mkdir -p ${_tmpdir}

	cat > ${_initfile} <<EOF
#!/bin/sh

export PATH=/bin:/usr/bin:/sbin:/usr/sbin

#
# Loading essential files
#
. ${RAMFS_CONF}
EOF

	cat >> ${_initfile} <<"EOF"
. ${RAMFS_INIT}
. ${RAMFS_LOCAL}

EOF

	cat >> ${_initfile} <<EOF
#
# Main default variables
#
SYSTEM="local"
DEBUG="0"
RESCUE="0"
FORCEFSCK="0"
INITLEVEL="3"
KEYBOARD="none"
INITCMD="/sbin/init"
ROOTDEV="none"
ROOTFS="none"
ROOTLV="0"
ROOTRAID="0"
ROOTBTRFS="0"
ROOTVG="none"
ROOTPV="none"
NEWROOT="/.root"
IMAGES="/images"

EOF

	cat >> ${_initfile} <<"EOF"
#
# Starting local boot process
#
mount_proc
mount_sys
mount_dev
mount_run
mount_rw_root
parse_cmdline
parse_variables
load_custom_modules
start_hotplug

if [ "${RESCUE}" == "1" ]
then
	rescue_shell
fi

parse_rootdev
volume_flags

if [ "${ROOTRAID}" == "1" ]
then
	start_raid
fi

if [ "${ROOTVOL}" == "1" ]
then
	start_lvm2
fi

if [ "${ROOTBTRFS}" == "1" ]
then
	start_btrfs
fi

if [ "${ROOTLUKUS}" == "1" ]
then
	start_lukus
fi

run_fsck
mount_root

if [ "${RESUME}" == "1" ]
then
	resume_power
fi

if system_is local live
then
	move_mountages
fi

change_root

EOF

	chmod +x ${_initfile}
	return 0
}
