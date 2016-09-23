#!/bin/bash

run_hook()
{
	local B
	
	for B in fsck fsck.ext{2,3,4} fsck.reiserfs fsck.btrfs
	do
		if [ -x $(command -v ${B} 2>/dev/null) ]
		then
			cp_this ${B}
		fi
	done
}
