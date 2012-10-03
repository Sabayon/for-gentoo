# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils multilib versionator

DESCRIPTION="Professional photo workflow and RAW conversion software"
HOMEPAGE="http://www.corel.com/corel/product/index.jsp?pid=prod4670071"
RESTRICT="mirror strip"
SRC_URI="http://www.corel.com/akdlm/6763/downloads/${PN}/$(get_major_version)/PF/${PN}_i386.deb
	-> ${PN}-${PV}_i386.deb"

LICENSE="AfterShotPro"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="nuance"

DEPEND="sys-apps/debianutils"
RDEPEND="virtual/libc
	media-libs/fontconfig
	media-libs/freetype
	sys-libs/zlib
	dev-libs/expat
	dev-libs/glib:2
	x86? (
		media-libs/libpng:1.2
	)
	amd64? (
		app-emulation/emul-linux-x86-baselibs
		app-emulation/emul-linux-x86-xlibs
	)
	!media-plugins/asp-plugins-nostalgia"

PDEPEND="nuance? ( media-plugins/asp-plugins-nuance )"

# Skip some QA checks we cannot fix
QA_TEXTRELS="opt/${PN}/lib/libkodakcms.so*"
QA_EXECSTACK="opt/${PN}/bin/AfterShotPro
	opt/${PN}/lib/libkodakcms.so*"
QA_FLAGS_IGNORED="opt/${PN}/supportfiles/libs/NoiseNinja/libnoiseninja\.so.*"

S="${WORKDIR}"

src_unpack() {
	unpack ${A}
	unpack ./data.tar.gz
	rm -f control.tar.gz data.tar.gz debian-binary
}

pkg_setup() {
	has_multilib_profile && ABI="x86"
}

src_install() {
	dodir /opt/AfterShotPro

	# AfterShotPro binary
	dodir /opt/AfterShotPro/bin
	exeinto /opt/AfterShotPro/bin
	doexe opt/AfterShotPro/bin/AfterShotPro
	exeinto /usr/bin
	doexe usr/bin/AfterShotPro

	# AfterShotPro data files
	insinto /opt/AfterShotPro
	doins -r opt/AfterShotPro/supportfiles

	# AfterShotPro libs
	# We use cp -pPR to preserve files (libs) permissions without listing all files
	cp -pPR opt/AfterShotPro/lib "${D}/opt/AfterShotPro/" || die "failed to copy"

	# AfterShotPro icon
	dodir /usr/share/pixmaps
	insinto /usr/share/pixmaps
	doins usr/share/pixmaps/AfterShotPro.png

	# .desktop file
	insinto /usr/share/applications
	doins usr/share/applications/AfterShotPro.desktop
}
