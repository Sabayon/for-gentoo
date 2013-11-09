# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit autotools eutils gnome2 systemd virtualx

DESCRIPTION="Cinnamon Settings Daemon"
HOMEPAGE="https://github.com/linuxmint/cinnamon-settings-daemon"

SRC_URI="https://github.com/linuxmint/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"

IUSE="+cups debug +i18n policykit smartcard systemd +udev"
REQUIRED_USE="
	smartcard? ( udev )
"

COMMON_DEPEND="
	>=dev-libs/glib-2.31.0:2
	>=x11-libs/gtk+-3.3.18:3
	>=gnome-extra/cinnamon-desktop-1.0.0
	>=gnome-base/gsettings-desktop-schemas-3.6
	>=gnome-base/libgnomekbd-2.91.1
	>=gnome-base/librsvg-2.36.2
	media-fonts/cantarell
	media-libs/fontconfig
	>=media-libs/lcms-2.2:2
	media-libs/libcanberra[gtk3]
	>=media-sound/pulseaudio-0.9.16
	>=sys-power/upower-0.9.11
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	>=x11-libs/libnotify-0.7.3:=
	x11-libs/libX11
	x11-libs/libxkbfile
	x11-libs/libXi
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXtst
	x11-libs/libXxf86misc

	>=x11-misc/colord-0.1.9:=
	cups? ( >=net-print/cups-1.4[dbus] )
	i18n? ( >=app-i18n/ibus-1.4.99 )
	>=dev-libs/libwacom-0.7
	x11-drivers/xf86-input-wacom
	smartcard? ( >=dev-libs/nss-3.11.2 )
	systemd? ( sys-apps/systemd )
	!systemd? ( sys-auth/consolekit )
	udev? ( virtual/udev[gudev] )
"
RDEPEND="${COMMON_DEPEND}
	gnome-base/dconf
	x11-proto/kbproto
	>=x11-themes/gnome-themes-standard-2.91
	>=x11-themes/gnome-icon-theme-2.91
	>=x11-themes/gnome-icon-theme-symbolic-2.91
"
DEPEND="${COMMON_DEPEND}
	cups? ( sys-apps/sed )
	dev-libs/libxml2:2
	sys-devel/gettext
	>=dev-util/intltool-0.37.1
	virtual/pkgconfig
	x11-proto/inputproto
	x11-proto/xf86miscproto
	>=x11-proto/xproto-7.0.15
"

src_prepare() {
	# Taken from Arch.
	epatch "${FILESDIR}/keyboard.patch"

	epatch_user
	eautoreconf

	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-static \
		--enable-man \
		$(use_enable cups) \
		$(use_enable debug) \
		$(use_enable debug more-warnings) \
		$(use_enable i18n ibus) \
		$(use_enable smartcard smartcard-support) \
		$(use_enable systemd) \
		$(use_enable udev gudev)
}

src_test() {
	Xemake check
}
