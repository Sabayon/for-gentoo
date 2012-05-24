# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit unpacker multilib versionator

MY_PN="LinuxTycoon"
MY_PV=$(replace_version_separator 2 '-')
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="Lunduke made Linux Tycoon"
HOMEPAGE="http://lunduke.com/?page_id=2646"
SRC_URI="http://www.lunduke.com/linuxtycoon/${MY_PN}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"

RDEPEND="x11-libs/pango
	media-libs/libpng:2
	x11-libs/pixman
	amd64? ( 
	app-emulation/emul-linux-x86-gtklibs 
	app-emulation/emul-linux-x86-baselibs )"
DEPEND=""

S="${WORKDIR}"

src_install() {
	insinto "/opt/${MY_PN}" || die "Couldn't ins into dir"
	doins "${S}/LinuxTycoon/LinuxTycoon" || die "Couldn't copy to bin folder"
	fperms 700 "/opt/LinuxTycoon/LinuxTycoon" || die "Failed to change permission"
	doins "${S}/LinuxTycoon/LinuxTycoon.png" || die

	insinto "/opt/${MY_PN}/${MY_PN} Libs" || die "couldn't dir into dir"
	doins "${S}/${MY_PN}/${MY_PN} Libs/libRBXML.so" || die
	doins "${S}/${MY_PN}/${MY_PN} Libs/libRBAppearancePak.so" || die

	cd "/opt/${MY_PN}"
	dosym "/opt/${MY_PN}/LinuxTycoon" /usr/bin/LinuxTycoon || die
}
