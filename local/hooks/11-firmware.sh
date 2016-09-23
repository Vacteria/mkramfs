#!/bin/bash

run_hook()
{
	[ "${RAMFS_HOTPLUG}" == "mdev" ] && return 0
	
	local m f
	
	if [ -d "${_basekmods}" ]
	then
		for m in $(find ${_basekmods} -type f -name "*.ko*")
		do
			m="${m%%.ko*}" && m="${m##*/}"
			for f in $(modinfo --set-version="${_kernver}" --basedir="${_tmpdir}" --field="firmware" ${m} 2>/dev/null)
			do
				cp_this ${_fwrdir}/${f}
			done
		done
	fi
	
	return 0
}
