# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit autotools gnome2

DESCRIPTION="GTK+-based Last.fm client"
HOMEPAGE="http://vagalume.igalia.com/"
SRC_URI="http://vagalume.igalia.com/files/source/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dbus libnotify libproxy"

RDEPEND="dev-libs/libxml2
	>=media-libs/gst-plugins-base-0.10
	>=media-plugins/gst-plugins-mad-0.10
	>=media-plugins/gst-plugins-gconf-0.10
	net-misc/curl
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	dbus? ( dev-libs/dbus-glib )
	libnotify? ( x11-libs/libnotify )
	libproxy? ( net-libs/libproxy )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

DOCS="AUTHORS README THANKS TODO TRANSLATORS"

src_prepare() {
	gnome2_src_prepare
	eautoreconf
}

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_enable dbus)
		$(use_enable libnotify tray-icon)
		$(use_enable libproxy)
		--with-gtk-version=3"
}
