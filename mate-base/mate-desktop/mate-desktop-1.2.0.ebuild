# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

EAPI="4"
GCONF_DEBUG="yes"
PYTHON_DEPEND="2"
WANT_AUTOMAKE="1.9"

inherit autotools mate python mate-desktop.org

DESCRIPTION="Libraries for the MATE desktop that are not part of the UI"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2 FDL-1.1 LGPL-2"
SLOT="2"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="doc"

RDEPEND=">=x11-libs/gtk+-2.18:2
	>=dev-libs/glib-2.19.1:2
	>=x11-libs/libXrandr-1.2
	>=mate-base/mate-conf-1.2.1
	>=x11-libs/startup-notification-0.5"
DEPEND="${RDEPEND}
	dev-util/gtk-doc
	>=dev-util/intltool-0.40
	virtual/pkgconfig
	>=app-text/mate-doc-utils-1.2.1
	~app-text/docbook-xml-dtd-4.1.2
	x11-proto/xproto
	>=x11-proto/randrproto-1.2"
PDEPEND=">=dev-python/pygtk-2.8:2
	>=dev-python/pygobject-2.14:2"

# Includes X11/Xatom.h in libgnome-desktop/gnome-bg.c which comes from xproto
# Includes X11/extensions/Xrandr.h that includes randr.h from randrproto (and
# eventually libXrandr shouldn't RDEPEND on randrproto)

src_prepare() {
	mkdir "${S}/m4" || die
	gtkdocize || die
	mate-doc-prepare --force --copy || die
	mate-doc-common --copy || die
        eautoreconf
        mate_src_prepare
}

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
	G2CONF="${G2CONF}
		PYTHON=$(PYTHON -a)
		--disable-scrollkeeper
		--disable-static
		--disable-deprecations
		$(use_enable doc desktop-docs)"
	DOCS="AUTHORS ChangeLog HACKING NEWS README"
}

src_install() {
	mate_src_install
	find "${ED}" -name '*.la' -exec rm -f {} +
}
