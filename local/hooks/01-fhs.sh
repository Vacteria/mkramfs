#!/bin/bash

run_hook()
{
	mkdir -p ${_tmpdir}/{bin,dev,lib/{modules,firmware},run,sbin,sys,proc}
	mkdir -p ${_tmpdir}/usr/{bin,sbin,lib}
	mkdir -p ${_tmpdir}/etc/{modprobe.d,udev/rules.d,rc.conf.d}
	touch ${_tmpdir}/etc/modprobe.d/modprobe.conf
	ln  -s lib ${_tmpdir}/lib64

	mknod -m 640 ${_tmpdir}/dev/console c 5 1
	mknod -m 664 ${_tmpdir}/dev/null    c 1 3
	mknod -m 664 ${_tmpdir}/dev/random  c 1 8
	mknod -m 664 ${_tmpdir}/dev/urandom c 1 9
	
	cp_this ${RAMFS_CONF}
	cp_this ${RAMFS_INIT}
	cp_this ${RAMFS_LOCAL}
	
	return 0
}
