#!/bin/sh
if [ -z "$1" ]; then
	echo do-entropy-cleanup.sh VERSION_TO_CLEAN
	exit
fi

PACKAGES="
	sys-apps/rigo-daemon
	sys-apps/entropy
	app-admin/equo
	app-admin/rigo
	sys-apps/entropy-server
	sys-apps/magneto-core
	app-misc/magneto-loader
	kde-misc/magneto-kde
	x11-misc/magneto-gtk
	x11-misc/magneto-gtk3
	app-admin/matter"

for ver in ${@}; do
	for package in ${PACKAGES}; do
		name=$(echo ${package} | cut -d/ -f2)
		git rm -f "${package}/${name}-${ver}.ebuild"
		kept_ebuild=$(find ${package} -name "${name}*.ebuild" | tail --lines 1)
		ebuild ${kept_ebuild} manifest
	done
done
