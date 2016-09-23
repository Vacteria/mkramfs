#!/bin/bash

run_hook()
{
	local SPLASHCONF SPLASHBIN SPLASHTHEMES SPLASHFILES
	
	case ${RAMFS_SPLASH} in
		bootsplash )			
			SPLASHCONF="/etc/rc.conf.d/bootsplash"
			SPLASHTHEMES="/etc/bootsplash/themes"
			SPLASHBIN="$(command -v splash)"

			if [ -z "${SPLASHBIN}" ]
			then
				warn "$(gettext 'Unable to find splash binary')"
				return 0
			fi
			
			if [ -f  "${SPLASHCONF}" ]
			then
				. "${SPLASHCONF}" || die "$(gettext 'Failed to read splash config file')"
			else
				warn "$(gettext 'Unable to find global configuration file')"
				return 0
			fi

			[ "${BOOTSPLASH_ACTIVE}" == "0" ] && return 0
						
			if [ "${BOOTSPLASH_THEME}" == "default" ]
			then
				if [ -L "${SPLASHTHEMES}/default" ]
				then
					MYTHEME="$(readlink -e ${SPLASHTHEMES}/default)"
				else
					die "$(gettext '"%s" theme will be set but link does not exist')" "default"
				fi
			else
				MYTHEME="${SPLASHTHEMES}/${BOOTSPLASH_THEME}"
			fi
			
			[ ! -d "${MYTHEME}" ] && die "$(gettext 'Unable to find %s theme')" "${MYTHEME}"
			
			MYRES="${BOOTSPLASH_RESOLUTION:-800x600}"
			MYFILE="${MYTHEME}/config/bootsplash-${MYRES}.cfg"
			
			[ ! -f "${MYFILE}" ] && MYFILE="${MYTHEME}/config/bootsplash-${MYRES}.cfg" 
			[ ! -f "${MYFILE}" ] && die "$(gettext 'Unable to find config file for %s theme')" "${MYTHEME}"

			${SPLASHBIN} -s -f ${MYFILE} > ${_tmpdir}/bootsplash
			cp_this ${SPLASHBIN}
			cp_this ${MYTHEME}
		;;			
		fbsplash   ) true ;;
		splashy    ) true ;;
		plymouth   ) true ;;
	esac
	
	return 0
}
