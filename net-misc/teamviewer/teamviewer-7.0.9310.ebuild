# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils

# Major version
MV=${PV/\.*}

DESCRIPTION="the All-In-One Solution for Remote Access and Support over the Internet"
HOMEPAGE="http://www.teamviewer.com"
SRC_URI="http://www.teamviewer.com/download/${PN}_linux.tar.gz -> ${P}.tar.gz"

LICENSE="TeamViewerNovember2011"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="mirror strip"

RDEPEND="
	app-emulation/wine
"

S="${WORKDIR}/teamviewer${MV}"

pkg_setup() {
	elog "This ebuild installs the TeamViewer binary and libraries and relies on"
	elog "Gentoo's wine package to run the actual program."
	elog
	elog "If you encounter any problems, consider running TeamViewer with the"
	elog "bundled wine package manually."
}

src_install() {
pwd
	insinto /opt/teamviewer/
	doins .wine/drive_c/Program\ Files/TeamViewer/Version${MV}/*

	rm teamviewer || die
	echo "#!/bin/bash" > teamviewer || die
	echo "/usr/bin/wine /opt/teamviewer/TeamViewer.exe" >> teamviewer || die
	insinto /usr/bin
	dobin teamviewer

	dodoc linux_FAQ_{EN,DE}.txt
	dodoc CopyRights_{EN,DE}.txt

	make_desktop_entry ${PN} TeamViewer ${PN}
}
