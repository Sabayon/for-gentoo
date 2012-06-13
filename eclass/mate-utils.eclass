# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

# @ECLASS: mate-utils.eclass
# @MAINTAINER:
# gnome@gentoo.org
# @BLURB: Auxiliary functions commonly used by Gnome packages.
# @DESCRIPTION:
# This eclass provides a set of auxiliary functions needed by most Gnome
# packages. It may be used by non-Gnome packages as needed for handling various
# Gnome stack related functions such as:
#  * Gtk+ icon cache management
#  * GSettings schemas management
#  * GConf schemas management
#  * scrollkeeper (old Gnome help system) management

case "${EAPI:-0}" in
	0|1|2|3|4) ;;
	*) die "EAPI=${EAPI} is not supported" ;;
esac

# @ECLASS-VARIABLE: GCONFTOOL_BIN
# @INTERNAL
# @DESCRIPTION:
# Path to /usr/bin/mateconftool-2
: ${GCONFTOOL_BIN:="/usr/bin/mateconftool-2"}

# @ECLASS-VARIABLE: SCROLLKEEPER_DIR
# @INTERNAL
# @DESCRIPTION:
# Directory where scrollkeeper-update should do its work
: ${SCROLLKEEPER_DIR:="/var/lib/scrollkeeper"}

# @ECLASS-VARIABLE: SCROLLKEEPER_UPDATE_BIN
# @INTERNAL
# @DESCRIPTION:
# Path to scrollkeeper-update
: ${SCROLLKEEPER_UPDATE_BIN:="/usr/bin/scrollkeeper-update"}

# @ECLASS-VARIABLE: GTK_UPDATE_ICON_CACHE
# @INTERNAL
# @DESCRIPTION:
# Path to gtk-update-icon-cache
: ${GTK_UPDATE_ICON_CACHE:="/usr/bin/gtk-update-icon-cache"}

# @ECLASS-VARIABLE: GLIB_COMPILE_SCHEMAS
# @INTERNAL
# @DESCRIPTION:
# Path to glib-compile-schemas
: ${GLIB_COMPILE_SCHEMAS:="/usr/bin/glib-compile-schemas"}

# @ECLASS-VARIABLE: GNOME2_ECLASS_SCHEMAS
# @INTERNAL
# @DEFAULT_UNSET
# @DESCRIPTION:
# List of GConf schemas provided by the package

# @ECLASS-VARIABLE: GNOME2_ECLASS_ICONS
# @INTERNAL
# @DEFAULT_UNSET
# @DESCRIPTION:
# List of icons provided by the package

# @ECLASS-VARIABLE: GNOME2_ECLASS_SCROLLS
# @INTERNAL
# @DEFAULT_UNSET
# @DESCRIPTION:
# List of scrolls (documentation files) provided by the package

# @ECLASS-VARIABLE: GNOME2_ECLASS_GLIB_SCHEMAS
# @INTERNAL
# @DEFAULT_UNSET
# @DESCRIPTION:
# List of GSettings schemas provided by the package

DEPEND=">=sys-apps/sed-4"


# @FUNCTION: mate_environment_reset
# @DESCRIPTION:
# Reset various variables inherited from root's evironment to a reasonable
# default for ebuilds to help avoid access violations and test failures.
mate_environment_reset() {
	# Respected by >=glib-2.30.1-r1
	export G_HOME="${T}"

	# GST_REGISTRY is to work around gst utilities trying to read/write /root
	export GST_REGISTRY="${T}/registry.xml"

	# XXX: code for resetting XDG_* directories should probably be moved into
	# a separate function in a non-gnome eclass
	export XDG_DATA_HOME="${T}/.local/share"
	export XDG_CONFIG_HOME="${T}/.config"
	export XDG_CACHE_HOME="${T}/.cache"
	export XDG_RUNTIME_DIR="${T}/run"
	mkdir -p "${XDG_DATA_HOME}" "${XDG_CONFIG_HOME}" "${XDG_CACHE_HOME}" \
		"${XDG_RUNTIME_DIR}"
	# This directory needs to be owned by the user, and chmod 0700
	# http://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html
	chmod 0700 "${XDG_RUNTIME_DIR}"
}

# @FUNCTION: mate_gconf_savelist
# @DESCRIPTION:
# Find the GConf schemas that are about to be installed and save their location
# in the GNOME2_ECLASS_SCHEMAS environment variable.
# This function should be called from pkg_preinst.
mate_gconf_savelist() {
	has ${EAPI:-0} 0 1 2 && ! use prefix && ED="${D}"
	pushd "${ED}" &> /dev/null
	export GNOME2_ECLASS_SCHEMAS=$(find 'etc/mateconf/schemas/' -name '*.schemas' 2> /dev/null)
	popd &> /dev/null
}

# @FUNCTION: mate_gconf_install
# @DESCRIPTION:
# Applies any schema files installed by the current ebuild to Gconf's database
# using gconftool-2.
# This function should be called from pkg_postinst.
mate_gconf_install() {
	has ${EAPI:-0} 0 1 2 && ! use prefix && EROOT="${ROOT}"
	local updater="${EROOT}${GCONFTOOL_BIN}"

	if [[ ! -x "${updater}" ]]; then
		debug-print "${updater} is not executable"
		return
	fi

	if [[ -z "${GNOME2_ECLASS_SCHEMAS}" ]]; then
		debug-print "No MATE GConf schemas found"
		return
	fi

	# We are ready to install the GCONF Scheme now
	unset MATECONF_DISABLE_MAKEFILE_SCHEMA_INSTALL
	export MATECONF_CONFIG_SOURCE="$("${updater}" --get-default-source | sed "s;:/;:${ROOT};")"

	einfo "Installing MATE GConf schemas"

	local F
	for F in ${GNOME2_ECLASS_SCHEMAS}; do
		if [[ -e "${EROOT}${F}" ]]; then
			debug-print "Installing schema: ${F}"
			"${updater}" --makefile-install-rule "${EROOT}${F}" 1>/dev/null
		fi
	done

	# have gconf reload the new schemas
	pids=$(pgrep -x mateconfd-2)
	if [[ $? == 0 ]] ; then
		ebegin "Reloading GConf schemas"
		kill -HUP ${pids}
		eend $?
	fi
}

# @FUNCTION: mate_gconf_uninstall
# @DESCRIPTION:
# Removes schema files previously installed by the current ebuild from Gconf's
# database.
mate_gconf_uninstall() {
	has ${EAPI:-0} 0 1 2 && ! use prefix && EROOT="${ROOT}"
	local updater="${EROOT}${GCONFTOOL_BIN}"

	if [[ ! -x "${updater}" ]]; then
		debug-print "${updater} is not executable"
		return
	fi

	if [[ -z "${GNOME2_ECLASS_SCHEMAS}" ]]; then
		debug-print "No MATE GConf schemas found"
		return
	fi

	unset MATECONF_DISABLE_MAKEFILE_SCHEMA_INSTALL
	export MATECONF_CONFIG_SOURCE="$("${updater}" --get-default-source | sed "s;:/;:${ROOT};")"

	einfo "Uninstalling MATE GConf schemas"

	local F
	for F in ${GNOME2_ECLASS_SCHEMAS}; do
		if [[ -e "${EROOT}${F}" ]]; then
			debug-print "Uninstalling gconf schema: ${F}"
			"${updater}" --makefile-uninstall-rule "${EROOT}${F}" 1>/dev/null
		fi
	done

	# have gconf reload the new schemas
	pids=$(pgrep -x gconfd-2)
	if [[ $? == 0 ]] ; then
		ebegin "Reloading GConf schemas"
		kill -HUP ${pids}
		eend $?
	fi
}

# @FUNCTION: mate_icon_savelist
# @DESCRIPTION:
# Find the icons that are about to be installed and save their location
# in the GNOME2_ECLASS_ICONS environment variable.
# This function should be called from pkg_preinst.
mate_icon_savelist() {
	has ${EAPI:-0} 0 1 2 && ! use prefix && ED="${D}"
	pushd "${ED}" &> /dev/null
	export GNOME2_ECLASS_ICONS=$(find 'usr/share/icons' -maxdepth 1 -mindepth 1 -type d 2> /dev/null)
	popd &> /dev/null
}

# @FUNCTION: mate_icon_cache_update
# @DESCRIPTION:
# Updates Gtk+ icon cache files under /usr/share/icons if the current ebuild
# have installed anything under that location.
# This function should be called from pkg_postinst and pkg_postrm.
mate_icon_cache_update() {
	has ${EAPI:-0} 0 1 2 && ! use prefix && EROOT="${ROOT}"
	local updater="${EROOT}${GTK_UPDATE_ICON_CACHE}"

	if [[ ! -x "${updater}" ]] ; then
		debug-print "${updater} is not executable"
		return
	fi

	if [[ -z "${GNOME2_ECLASS_ICONS}" ]]; then
		debug-print "No icon cache to update"
		return
	fi

	ebegin "Updating icons cache"

	local retval=0
	local fails=( )

	for dir in ${GNOME2_ECLASS_ICONS}
	do
		if [[ -f "${EROOT}${dir}/index.theme" ]] ; then
			local rv=0

			"${updater}" -qf "${EROOT}${dir}"
			rv=$?

			if [[ ! $rv -eq 0 ]] ; then
				debug-print "Updating cache failed on ${EROOT}${dir}"

				# Add to the list of failures
				fails[$(( ${#fails[@]} + 1 ))]="${EROOT}${dir}"

				retval=2
			fi
		elif [[ $(ls "${EROOT}${dir}") = "icon-theme.cache" ]]; then
			# Clear stale cache files after theme uninstallation
			rm "${EROOT}${dir}/icon-theme.cache"
		fi

		if [[ -z $(ls "${EROOT}${dir}") ]]; then
			# Clear empty theme directories after theme uninstallation
			rmdir "${EROOT}${dir}"
		fi
	done

	eend ${retval}

	for f in "${fails[@]}" ; do
		eerror "Failed to update cache with icon $f"
	done
}

# @FUNCTION: mate_omf_fix
# @DESCRIPTION:
# Workaround applied to Makefile rules in order to remove redundant
# calls to scrollkeeper-update and sandbox violations.
# This function should be called from src_prepare.
mate_omf_fix() {
	local omf_makefiles filename

	omf_makefiles="$@"

	if [[ -f ${S}/omf.make ]] ; then
		omf_makefiles="${omf_makefiles} ${S}/omf.make"
	fi

	if [[ -f ${S}/mate-doc-tool.make ]] ; then
		omf_makefiles="${omf_makefiles} ${S}/mate-doc-tool.make"
	fi

	# testing fixing of all makefiles found
	# The sort is important to ensure .am is listed before the respective .in for
	# maintainer mode regeneration not kicking in due to .am being newer than .in
	for filename in $(find "${S}" -name "Makefile.in" -o -name "Makefile.am" |sort) ; do
		omf_makefiles="${omf_makefiles} ${filename}"
	done

	ebegin "Fixing OMF Makefiles"

	local retval=0
	local fails=( )

	for omf in ${omf_makefiles} ; do
		sed -i -e 's:scrollkeeper-update:true:' "${omf}"
		retval=$?

		if [[ $retval -ne 0 ]] ; then
			debug-print "updating of ${omf} failed"

			# Add to the list of failures
			fails[$(( ${#fails[@]} + 1 ))]=$omf

			retval=2
		fi
	done

	eend $retval

	for f in "${fails[@]}" ; do
		eerror "Failed to update OMF Makefile $f"
	done
}

# @FUNCTION: mate_scrollkeeper_savelist
# @DESCRIPTION:
# Find the scrolls that are about to be installed and save their location
# in the GNOME2_ECLASS_SCROLLS environment variable.
# This function should be called from pkg_preinst.
mate_scrollkeeper_savelist() {
	has ${EAPI:-0} 0 1 2 && ! use prefix && ED="${D}"
	pushd "${ED}" &> /dev/null
	export GNOME2_ECLASS_SCROLLS=$(find 'usr/share/omf' -type f -name "*.omf" 2> /dev/null)
	popd &> /dev/null
}

# @FUNCTION: mate_scrollkeeper_update
# @DESCRIPTION:
# Updates the global scrollkeeper database.
# This function should be called from pkg_postinst and pkg_postrm.
mate_scrollkeeper_update() {
	has ${EAPI:-0} 0 1 2 && ! use prefix && EROOT="${ROOT}"
	local updater="${EROOT}${SCROLLKEEPER_UPDATE_BIN}"

	if [[ ! -x "${updater}" ]] ; then
		debug-print "${updater} is not executable"
		return
	fi

	if [[ -z "${GNOME2_ECLASS_SCROLLS}" ]]; then
		debug-print "No scroll cache to update"
		return
	fi

	ebegin "Updating scrollkeeper database ..."
	"${updater}" -q -p "${EROOT}${SCROLLKEEPER_DIR}"
	eend $?
}

# @FUNCTION: mate_schemas_savelist
# @DESCRIPTION:
# Find if there is any GSettings schema to install and save the list in
# GNOME2_ECLASS_GLIB_SCHEMAS variable.
# This function should be called from pkg_preinst.
mate_schemas_savelist() {
	has ${EAPI:-0} 0 1 2 && ! use prefix && ED="${D}"
	pushd "${ED}" &>/dev/null
	export GNOME2_ECLASS_GLIB_SCHEMAS=$(find 'usr/share/mateconf/schemas' -name '*.gschema.xml' 2>/dev/null)
	popd &>/dev/null
}

# @FUNCTION: mate_schemas_update
# @USAGE: mate_schemas_update
# @DESCRIPTION:
# Updates GSettings schemas if GNOME2_ECLASS_GLIB_SCHEMAS has some.
# This function should be called from pkg_postinst and pkg_postrm.
mate_schemas_update() {
	has ${EAPI:-0} 0 1 2 && ! use prefix && EROOT="${ROOT}"
	local updater="${EROOT}${GLIB_COMPILE_SCHEMAS}"

	if [[ ! -x ${updater} ]]; then
		debug-print "${updater} is not executable"
		return
	fi

	if [[ -z ${GNOME2_ECLASS_GLIB_SCHEMAS} ]]; then
		debug-print "No GSettings schemas to update"
		return
	fi

	ebegin "Updating GSettings schemas"
	${updater} --allow-any-name "$@" "${EROOT%/}/usr/share/mateconf/schemas" &>/dev/null
	eend $?
}
