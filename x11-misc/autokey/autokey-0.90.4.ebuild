# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"
inherit eutils gnome2-utils distutils

DESCRIPTION="Desktop automation utility for Linux and X11"
HOMEPAGE="http://code.google.com/p/autokey/"
SRC_URI="http://autokey.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND=""
RDEPEND="${DEPEND}
	dev-libs/glib:2
	dev-libs/gobject-introspection
	dev-python/dbus-python
	dev-python/pygobject:3
	dev-python/pyatspi
	dev-python/pyinotify
	dev-python/python-xlib
	gnome-extra/zenity
	x11-libs/gtk+:3[introspection]
	x11-libs/gtksourceview:3.0[introspection]
	x11-libs/libnotify[introspection]
	x11-libs/pango[introspection]
"

# qt4 doesn't work... deps for qt4 for future reference:
# x11-libs/qscintilla[python] dev-python/PyQt4[X,dbus] kde-base/pykde4
src_prepare() {
	epatch "${FILESDIR}"/${P}-disable-qt4.patch
	rm ./src/lib/qtapp.py || die
	distutils_src_prepare
}

src_install() {
	distutils_src_install
	if use doc; then
		dodoc -r "${S}"/doc/scripting
	fi
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
