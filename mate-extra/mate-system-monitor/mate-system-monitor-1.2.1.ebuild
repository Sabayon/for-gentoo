# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

EAPI="3"
GCONF_DEBUG="no"

inherit autotools mate mate-desktop.org

DESCRIPTION="The MATE System Monitor"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.20:2
	mate-base/mate-conf
	>=x11-libs/libwnck-2.5:1
	>=gnome-base/libgtop-2.23.1:2
	>=x11-libs/gtk+-2.20:2
	x11-themes/mate-icon-theme
	>=dev-cpp/gtkmm-2.8:2.4
	>=dev-cpp/glibmm-2.16:2
	dev-libs/libxml2:2
	>=gnome-base/librsvg-2.12:2
	>=dev-libs/dbus-glib-0.70"

DEPEND="${RDEPEND}
	app-text/mate-doc-utils
	virtual/pkgconfig
	>=app-text/scrollkeeper-0.3.11
	>=dev-util/intltool-0.35
	dev-util/gtk-doc"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README"
	G2CONF="${G2CONF} --disable-scrollkeeper"
}

src_prepare() {
	gtkdocize || die
	mate-doc-prepare --force --copy || die
	mate-doc-common --copy || die
	intltoolize --force --copy --automake || die "intltoolize failed"
	eautoreconf
	mate_src_prepare
}
