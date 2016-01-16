#!/bin/sh

if [ -z "${2}" ]; then
	echo "${0} <portage CVS dir> <entropy version>"
	exit 1
fi
PORTDIR="${1}"
TARGET_VERSION="${2}"

PACKAGES="
	app-admin/matter
	x11-misc/magneto-gtk
	kde-misc/magneto-kde
	app-misc/magneto-loader
	sys-apps/magneto-core
	app-admin/rigo
	sys-apps/rigo-daemon
	sys-apps/entropy-server
	app-admin/equo
	sys-apps/entropy
	"


for package in ${PACKAGES}; do
	package_name=$(basename ${package})

	source_ebuild="${PORTDIR}/${package}/${package_name}-${TARGET_VERSION}.ebuild"
	source_ebuild_dir=$(dirname "${source_ebuild}")
	source_ebuild_name=$(basename "${source_ebuild}")
	cd "${source_ebuild_dir}" || continue

	rm "${source_ebuild_name}" || continue
	cvs rm "${source_ebuild_name}" || exit 1
	echangelog "drop older version ${TARGET_VERSION}" || exit 1
	ebuild "$(ls -1 *.ebuild | sort | tail -n 1)" manifest || exit 1
	repoman full || exit 1
	repoman ci -m "drop older version ${TARGET_VERSION}" || exit 1
done
