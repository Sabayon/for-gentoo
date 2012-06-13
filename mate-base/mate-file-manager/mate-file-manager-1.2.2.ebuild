# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

EAPI="3"
GCONF_DEBUG="no"

inherit autotools eutils mate virtualx mate-desktop.org

DESCRIPTION="A file manager for the MATE desktop"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2 LGPL-2 FDL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="doc gnome +introspection xmp"

RDEPEND=">=dev-libs/glib-2.28.0:2
	>=mate-base/mate-desktop-1.2.0
	>=x11-libs/pango-1.1.2
	>=x11-libs/gtk+-2.22:2[introspection?]
	>=dev-libs/libxml2-2.4.7:2
	>=media-libs/libexif-0.5.12
	>=mate-base/mate-conf-1.2.1
	dev-libs/libunique:1
	x11-libs/libXext
	x11-libs/libXrender
	introspection? ( >=dev-libs/gobject-introspection-0.6.4 )
	xmp? ( media-libs/exempi:2 )"

DEPEND="${RDEPEND}
	>=dev-lang/perl-5
	sys-devel/gettext
	virtual/pkgconfig
	>=dev-util/intltool-0.40.1
	doc? ( >=dev-util/gtk-doc-1.4 )
	>=mate-base/mate-common-1.2.2
	dev-util/gtk-doc-am"

PDEPEND="gnome? ( >=x11-themes/mate-icon-theme-1.2.0 )
	mate-base/mate-vfs"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-update-mimedb
		--disable-packagekit
		$(use_enable introspection)
		$(use_enable xmp)"
	DOCS="AUTHORS ChangeLog* HACKING MAINTAINERS NEWS README THANKS TODO"
}

src_prepare() {
	gtkdocize || die
	eautoreconf
	mate_src_prepare

	# Remove crazy CFLAGS
	sed -i \
		-e 's:-DG.*DISABLE_DEPRECATED::g' \
		configure{,.in} eel/Makefile.{am,in} || die
}

src_test() {
	addpredict "/root/.gnome2_private"
	unset SESSION_MANAGER
	unset ORBIT_SOCKETDIR
	unset DBUS_SESSION_BUS_ADDRESS
	Xemake check || die "Test phase failed"
}

src_install() {
	mate_src_install
	find "${ED}" -name "*.la" -delete || die "remove of la files failed"
}

pkg_postinst() {
	mate_pkg_postinst

	elog "caja can use gstreamer to preview audio files. Just make sure"
	elog "to have the necessary plugins available to play the media type you"
	elog "want to preview"
}
