# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Desktop automation utility for Linux and X11"
HOMEPAGE="http://code.google.com/p/autokey/"
SRC_URI="https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/autokey/${PN}_${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND=""
RDEPEND="${DEPEND}
	dev-python/dbus-python
	dev-python/pyatspi
	dev-python/pygtksourceview:2
	dev-python/python-xlib
	dev-python/pygtk:2
	dev-python/pyinotify"

src_install() {
	distutils-r1_src_install
	if use doc; then
		dodoc -r "${S}"/doc/scripting
	fi
}
