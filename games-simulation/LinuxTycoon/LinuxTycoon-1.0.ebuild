# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils

DESCRIPTION="Linux Tycoon by Lunduke"
HOMEPAGE="http://lunduke.com/?page_id=2646"
SRC_URI="${PN}.tar.gz"

LICENSE="EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"

RDEPEND="media-libs/libpng:1.2
	x11-libs/pango
	x11-libs/pixman
	amd64? (
		app-emulation/emul-linux-x86-baselibs 
		app-emulation/emul-linux-x86-gtklibs
	)"
DEPEND=""

RESTRICT="fetch strip"

S="${WORKDIR}"

pkg_nofetch() {
	einfo "Please purchase the game and download: ${MY_PN}.tar.gz"
	einfo "From ${HOMEPAGE} and place it into ${DISTDIR}"
}

src_install() {
	insinto "/opt"
	doins -r "${S}/${PN}"
	fperms +x "/opt/$PN/${PN}"
	dosym "/opt/${PN}/${PN}" "/opt/bin/${PN}"

	doicon "${S}/${PN}/${PN}.png"
	make_desktop_entry "${PN}" "${PN}" "${PN}" Game
}
