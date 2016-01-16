# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"
inherit distutils

DESCRIPTION="Desktop automation utility for Linux and X11"
HOMEPAGE="http://code.google.com/p/autokey/"
SRC_URI="http://autokey.googlecode.com/files/${PN}_${PV}.tar.gz"

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
	distutils_src_install
	if use doc; then
		dodoc -r "${S}"/doc/scripting
	fi
}
