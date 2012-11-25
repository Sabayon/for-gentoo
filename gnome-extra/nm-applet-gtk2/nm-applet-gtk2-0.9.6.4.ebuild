# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
GNOME_ORG_MODULE="network-manager-applet"

inherit gnome2

DESCRIPTION="GNOME applet for NetworkManager, gtk+-2 flavour"
HOMEPAGE="http://projects.gnome.org/NetworkManager/"

LICENSE="GPL-2"
SLOT="0"
IUSE="bluetooth"
KEYWORDS="~amd64 ~arm ~ppc ~x86"

RDEPEND="!gnome-extra/nm-applet
	>=dev-libs/glib-2.16:2
	>=dev-libs/dbus-glib-0.88
	>=gnome-base/gconf-2.26:2
	>=gnome-base/gnome-keyring-2.20
	>=sys-apps/dbus-1.4.1
	>=sys-auth/polkit-0.96-r1
	>=x11-libs/gtk+-2.20:2
	>=x11-libs/libnotify-0.7.0

	app-text/iso-codes
	>=net-misc/networkmanager-0.9.6.4
	net-misc/mobile-broadband-provider-info

	bluetooth? ( >=net-wireless/gnome-bluetooth-2.27.6 )
	virtual/freedesktop-icon-theme"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=dev-util/intltool-0.40"

src_prepare() {
	DOCS="AUTHORS ChangeLog NEWS README"
	G2CONF="${G2CONF}
		--with-gtkver=2
		--disable-more-warnings
		--disable-static
		--localstatedir=/var
		$(use_with bluetooth)"
	gnome2_src_prepare
}
