# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

EAPI="3"
GCONF_DEBUG="yes"

inherit autotools mate eutils

DESCRIPTION="Essential MATE Libraries"
HOMEPAGE="http://mate-desktop.org"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="doc"

RDEPEND=">=mate-base/mate-conf-1.2.1
	>=dev-libs/glib-2.16:2
	>=mate-base/mate-vfs-1.2.1
	>=mate-base/libmatecomponent-1.2.1
	>=dev-libs/popt-1.7
	media-libs/libcanberra"

DEPEND="${RDEPEND}
	>=app-text/mate-doc-utils-1.2.1
	>=dev-lang/perl-5
	>=dev-util/intltool-0.40
	virtual/pkgconfig
	dev-util/gtk-doc"

PDEPEND=">=mate-base/mate-vfs-1.2.1"

pkg_setup() {
	G2CONF="${G2CONF}
		--enable-canberra
		--disable-esd"
	DOCS="AUTHORS ChangeLog NEWS README"
}

src_prepare() {
	gtkdocize || die
	mate-doc-prepare --force --copy || die
	mate-doc-common --copy || die
	eautoreconf
	mate_src_prepare

	# Default to Adwaita theme over Clearlooks to proper gtk3 support
	# sed -i -e 's/Clearlooks/Adwaita/' schemas/desktop_gnome_interface.schemas.in.in || die
}
