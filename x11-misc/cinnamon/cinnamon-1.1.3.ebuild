# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
GNOME2_LA_PUNT="yes"
PYTHON_DEPEND="2"
inherit eutils python gnome2

DESCRIPTION="A fork of GNOME Shell with layout similar to GNOME 2"
HOMEPAGE="http://cinnamon.linuxmint.com/"
SRC_URI="https://github.com/linuxmint/Cinnamon/tarball/${PV} -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	app-accessibility/caribou
	dev-libs/glib:2
	gnome-base/gconf
	gnome-base/gnome-menus:3
	gnome-extra/evolution-data-server
	>=dev-libs/folks-0.5.2
	>=dev-libs/gjs-1.29.18
	dev-libs/gobject-introspection
	>=gnome-base/gnome-session-3
	gnome-base/libgnome-keyring
	>=media-libs/clutter-1.7.5:1.0
	media-libs/gstreamer
	net-im/telepathy-logger
	net-misc/networkmanager
	>=net-libs/telepathy-glib-0.15.5
	sys-auth/polkit[introspection]
	x11-libs/gtk+:3
	>=x11-wm/mutter-3.2.1
	x11-libs/startup-notification
"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40
	dev-util/pkgconfig
	sys-devel/gettext
"
S="${WORKDIR}/linuxmint-Cinnamon-dae5da1"

src_prepare() {
	gnome2_src_prepare
	# https://github.com/linuxmint/Cinnamon/issues/55
	sed -i -e '/^SHELL = @SHELL@/d' "${S}/js/Makefile.in" || die
}

src_install() {
	gnome2_src_install
	python_convert_shebangs 2 "${ED}"usr/bin/${PN}-extension-tool
	insinto /usr/share/gnome-session/sessions
	newins "${FILESDIR}/${P}.session" ${PN}.session
	insinto /usr/share/xsessions
	newins "${FILESDIR}/${P}.desktop" ${PN}.desktop
}
