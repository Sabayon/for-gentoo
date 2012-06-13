# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

EAPI="3"
GCONF_DEBUG="no"

inherit autotools eutils mate virtualx mate-desktop.org

DESCRIPTION="User Interface part of libmatecomponent"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="doc examples test"

# GTK+ dep due to bug #126565
RDEPEND=">=mate-base/libmatecanvas-1.2.0
	>=mate-base/libmatecomponent-1.2.1
	>=mate-base/libmate-1.2.0
	>=dev-libs/libxml2-2.4.20:2
	>=mate-base/mate-conf-1.2.1
	>=x11-libs/gtk+-2.8.12:2
	>=dev-libs/glib-2.6.0:2
	>=gnome-base/libglade-1.99.11:2.0
	>=dev-libs/popt-1.5"

DEPEND="${RDEPEND}
	x11-apps/xrdb
	sys-devel/gettext
	virtual/pkgconfig
	>=dev-util/intltool-0.40
	doc? ( >=dev-util/gtk-doc-1 )"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README"
	G2CONF="${G2CONF}
		--disable-static
		--disable-maintainer-mode"
}

src_prepare() {
	gtkdocize || die
	eautoreconf
	mate_src_prepare

	if ! use test; then
		# don't waste time building tests
		sed 's/tests//' -i Makefile.am Makefile.in || die "sed 1 failed"
	fi

	if ! use examples; then
		sed 's/samples//' -i Makefile.am Makefile.in || die "sed 2 failed"
	fi
}

src_configure() {
	addpredict "/root/.gnome2_private"

	mate_src_configure
}

src_test() {
	addwrite "/root/.gnome2_private"
	Xemake check || die "tests failed"
}

src_install() {
	mate_src_install
	find "${ED}" -name '*.la' -exec rm -f {} +
}
