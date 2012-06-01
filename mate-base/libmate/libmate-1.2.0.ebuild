# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

EAPI="4"
GCONF_DEBUG="yes"

inherit autotools mate eutils mate-desktop.org

DESCRIPTION="Essential MATE Libraries"
HOMEPAGE="http://mate-desktop.org"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="doc"

RDEPEND="mate-base/mate-conf
	>=dev-libs/glib-2.16:2
	mate-base/mate-vfs
	mate-base/libmatecomponent
	>=dev-libs/popt-1.7
	media-libs/libcanberra"

DEPEND="${RDEPEND}
	>=dev-lang/perl-5
	>=dev-util/intltool-0.40
	virtual/pkgconfig
	doc? ( >=dev-util/gtk-doc-1 )"

PDEPEND="gnome-base/gvfs"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-static
		--disable-schemas-install
		--enable-canberra
		--disable-esd"
	DOCS="AUTHORS ChangeLog NEWS README"
}

src_prepare() {
	./autogen.sh || die

        eautoreconf
	mate_src_prepare

	# Default to Adwaita theme over Clearlooks to proper gtk3 support
	# sed -i -e 's/Clearlooks/Adwaita/' schemas/desktop_gnome_interface.schemas.in.in || die
}

src_install() {
	mate_src_install
}
