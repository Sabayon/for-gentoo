# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

EAPI=4
inherit autotools mate-desktop.org

DESCRIPTION="A library for sending desktop notifications"
HOMEPAGE="http://mate-desktop.org"
SRC_URI="${SRC_URI}
	mirror://gentoo/introspection-20110205.m4.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="doc +introspection -symlink test"

RDEPEND=">=dev-libs/glib-2.26
	x11-libs/gdk-pixbuf:2
	introspection? ( >=dev-libs/gobject-introspection-0.9.12 )"
DEPEND="${RDEPEND}
	dev-util/gtk-doc-am
	virtual/pkgconfig
	doc? ( >=dev-util/gtk-doc-1.14 )
	symlink? ( !x11-misc/tinynotify-send[symlink] )
	test? ( x11-libs/gtk+:3 )"
PDEPEND="virtual/notification-daemon"

DOCS=( AUTHORS ChangeLog NEWS )

src_prepare() {
	mkdir "${S}/m4" || die
	gtkdocize || die

	sed -i -e 's:noinst_PROG:check_PROG:' tests/Makefile.am || die

	if ! use test; then
		sed -i -e '/PKG_CHECK_MODULES(TESTS/d' configure.ac || die
	fi

	if has_version 'dev-libs/gobject-introspection'; then
		eautoreconf
	else
		AT_M4DIR=${WORKDIR} eautoreconf
	fi
}

src_configure() {
	econf \
		--disable-static \
		$(use_enable introspection)
}

src_install() {
	default
	rm -f "${ED}"usr/lib*/${PN}.la

	use symlink && dosym ${PN}-notify-send /usr/bin/notify-send
}
