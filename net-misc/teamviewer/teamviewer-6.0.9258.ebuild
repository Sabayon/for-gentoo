# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils

DESCRIPTION="the All-In-One Solution for Remote Access and Support over the Internet"
HOMEPAGE="http://www.teamviewer.com"
SRC_URI="http://www.teamviewer.com/download/${PN}_linux.tar.gz -> ${P}.tar.gz"

LICENSE="TeamViewer"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="mirror strip"

RDEPEND="
	app-emulation/wine
"

pkg_setup() {
	elog "This ebuild installs the TeamViewer binary and libraries and relies on"
	elog "Gentoo's wine package to run the actual program."
	elog
	elog "If you encounter any problems, consider running TeamViewer with the"
	elog "bundled wine package manually."
}

src_install() {
	insinto /opt/teamviewer/ || die
	doins teamviewer6/.wine/drive_c/Program\ Files/TeamViewer/Version6/* ||
		die
	echo "#!/bin/bash" > teamviewer || die
	echo "/usr/bin/wine /opt/teamviewer/TeamViewer.exe" >> teamviewer || die
	insinto /usr/bin || die
	dobin teamviewer || die

	dodoc teamviewer6/linux_FAQ_{EN,DE}.txt || die

	make_desktop_entry ${PN} TeamViewer ${PN}
}
