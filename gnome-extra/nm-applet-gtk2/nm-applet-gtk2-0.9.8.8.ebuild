# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
GNOME_ORG_MODULE="network-manager-applet"

inherit gnome2

DESCRIPTION="GNOME applet for NetworkManager, gtk+-2 flavour"
HOMEPAGE="http://projects.gnome.org/NetworkManager/"

LICENSE="GPL-2+"
SLOT="0"
IUSE="bluetooth gconf +introspection modemmanager"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="!gnome-extra/nm-applet
	app-crypt/libsecret
	>=dev-libs/glib-2.26:2
	>=dev-libs/dbus-glib-0.88
	>=gnome-base/gconf-2.26:2
	>=gnome-base/libgnome-keyring-2.20
	>=sys-apps/dbus-1.4.1
	>=sys-auth/polkit-0.96-r1
	>=x11-libs/gtk+-2.20:2
	>=x11-libs/libnotify-0.7.0

	app-text/iso-codes
	>=net-misc/networkmanager-0.9.8
	net-misc/mobile-broadband-provider-info

	bluetooth? ( >=net-wireless/gnome-bluetooth-2.27.6 )
	gconf? (
		>=gnome-base/gconf-2.20:2
		gnome-base/libgnome-keyring )
	introspection? ( >=dev-libs/gobject-introspection-0.9.6 )
	modemmanager? ( >=net-misc/modemmanager-0.7.990 )
	virtual/freedesktop-icon-theme
	virtual/udev[gudev]
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=dev-util/intltool-0.40
"

src_configure() {
	sed -i s/Gtk-3.0/Gtk-2.0/ src/libnm-gtk/Makefile.in
	gnome2_src_configure \
		--with-gtkver=2 \
		--disable-more-warnings \
		--disable-static \
		--localstatedir=/var \
		$(use_with bluetooth) \
		$(use_enable gconf migration) \
		$(use_enable introspection) \
		$(use_with modemmanager modem-manager-1)
}
