# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit versionator autotools gnome2

DESCRIPTION="Me TV is a GTK desktop application for watching digital television."
HOMEPAGE="http://me-tv.sourceforge.net/"
SRC_URI="http://launchpad.net/${PN}/$(get_version_component_range 1-2)/$(get_version_component_range 1-3)/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="nls"

RDEPEND=">=dev-cpp/gconfmm-2.20.0
	dev-cpp/gtkmm:2.4
	dev-cpp/libxmlpp:2.6
	dev-libs/libunique:1
	>=dev-libs/dbus-glib-0.92
	=dev-db/sqlite-3*
	>=net-libs/gnet-2.0.0
	>=x11-libs/libXtst-1.0.0
	>=media-video/vlc-1.1.8
	>=media-libs/gstreamer-0.10"

DEPEND="${RDEPEND}"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable nls) \
		--disable-schemas-install
}
