#!/bin/sh
if [ -z "$2" ]; then
	echo do-entropy-bump.sh OLDVER NEWVER
	exit
fi

OLD=$1
NEW=$2
PACKAGES="sys-apps/rigo-daemon sys-apps/entropy app-admin/equo
	app-admin/rigo sys-apps/entropy-server
	sys-apps/magneto-core app-misc/magneto-loader
	kde-misc/magneto-kde x11-misc/magneto-gtk x11-misc/magneto-gtk3"

for package in ${PACKAGES}; do
	name=$(echo ${package} | cut -d/ -f2)
	cp ${package}/${name}-${OLD}.ebuild ${package}/${name}-${NEW}.ebuild
	git add ${package}/${name}-${NEW}.ebuild
	ebuild ${package}/${name}-${NEW}.ebuild manifest
done
