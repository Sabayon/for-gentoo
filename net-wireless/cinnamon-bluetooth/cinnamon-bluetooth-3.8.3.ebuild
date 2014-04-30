# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="yes"

inherit autotools multilib eutils gnome2 udev user flag-o-matic

DESCRIPTION="Bluetooth graphical utilities integrated with Cinnamon"
HOMEPAGE="https://github.com/linuxmint/cinnamon-bluetooth"

SRC_URI="https://github.com/linuxmint/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE="doc"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"

COMMON_DEPEND="
	>=gnome-extra/cinnamon-control-center-2.0.7
	>=net-wireless/gnome-bluetooth-3.4.1
	>=dev-libs/glib-2.31.0:2
	>=x11-libs/gtk+-3.4.2:3
"
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.40.0
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
	doc? ( dev-libs/libxslt )
"

src_prepare() {
	# Build system is broken
	append-cppflags "-I/usr/include/glib-2.0 -I/usr/$(get_libdir)/glib-2.0/include"

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure $(use_enable doc documentation)
}
