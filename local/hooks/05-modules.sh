#!/bin/bash

run_hook()
{
	local a b dir new load
	
	load="${_loadmods//none}"
	new="${_newmods//none}"
	
	if [ -n "${load}" ]
	then
		if [ "${load}" == "all" ]
		then
			[ -n "${new}" ] && load="${new}"
		fi
			
		for a in ${load}
		do
			b="${b} ${a%%.ko*}"
		done
		load="$(trim ${b})"
		
		mkdir -p ${_tmpdir}/etc/rc.conf.d
		cat >> ${_tmpdir}/etc/rc.conf.d/modules <<EOF
$(printf "%s\n" ${load})

EOF
	fi
	
	if [ "${RAMFS_HOTPLUG}" == "udev" ]
	then
		for dir in {crypt,fs,lib} drivers/{block,ata,md,firewire,gpu/drm} \
			drivers/{scsi,message,pcmcia,virtio,usb} divers/input/keyboard
		do
			cp_this ${_kernmods}/kernel/${dir}
		done
		cp_mod ${new}
		cp_this ${_kernmods}/modules.{builtin,order}
		depmod -b ${_tmpdir} ${_kernver}
	else
		for mod in ${new} scsi_mod sd_mod ata_generic ata_piix \
			usb-common usbcore hid usbhid hid usbhid uhci-hcd ohci-hcd \
			ehci-hcd jbd jbd2 mbcache crc16 ext2 ext3 ext4 reiserfs \
			squashfs fat nls_cp437 msdos vfat ntfs
		do
			cp_mod -n -d ${_tmpdir}/${_basekmods} ${mod}
		done
		
		find ${_tmpdir}/${_basekmods} -type f -name "*.gz" -exec gzip -d {} \;
	fi
	
	return 0
}
