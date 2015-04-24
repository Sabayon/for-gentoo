# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_DEPEND="2:2.6"
GCONF_DEBUG=no

build=954

inherit autotools eutils gnome2 python

MY_P="${P}-dev-build${build}"
DESCRIPTION="a text editor that is simple, slim and sleek, yet powerful"
HOMEPAGE="http://scribes.sourceforge.net"
SRC_URI="http://launchpad.net/scribes/${PV}/scribes-milestone1/+download/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="gnome-base/gconf
	doc? ( gnome-extra/yelp )
	dev-libs/dbus-glib
	dev-python/dbus-python
	dev-python/pygtk
	dev-python/gtkspell-python
	dev-python/pygtksourceview
	dev-python/pyxdg"
DEPEND="app-text/gnome-doc-utils
	dev-util/pkgconfig
	dev-util/intltool
	sys-devel/gettext"

S=${WORKDIR}/${MY_P}

DOCS="AUTHORS ChangeLog CONTRIBUTORS NEWS README TODO TRANSLATORS"

pkg_setup() {
	python_set_active_version 2
	G2CONF="--disable-scrollkeeper"
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-sandbox.patch
	# keep make from byte-compiling python modules itself
	epatch "${FILESDIR}"/${PN}-byte-compiling-plugins.patch
	eautoreconf

	# make py-compile useless (but true)
	echo '#!/bin/sh' > py-compile || die "Could not kill py-compile"

	python_convert_shebangs -r 2 .

	gnome2_src_prepare
}

src_install() {
	gnome2_src_install
	python_clean_installation_image
}

pkg_postinst() {
	gnome2_pkg_postinst
	python_mod_optimize SCRIBES
}

pkg_postrm() {
	gnome2_pkg_postrm
	python_mod_cleanup SCRIBES
}
