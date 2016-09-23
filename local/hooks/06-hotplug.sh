#!/bin/bash

run_hook()
{
	case ${RAMFS_HOTPLUG} in
		udev )
			cp_this udevd
			cp_this udevadm
			cp_this /etc/udev
			cp_this /lib/udev
		;;
	esac

	return 0
}
