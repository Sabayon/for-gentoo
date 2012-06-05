# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

EAPI="3"
GCONF_DEBUG="no"
PYTHON_DEPEND="2:2.5"

inherit autotools eutils mate python mate-desktop.org

DESCRIPTION="Applets for the MATE Desktop and Panel"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2 FDL-1.1 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="gnome gstreamer ipv6 networkmanager policykit"

# TODO: configure says python stuff is optional
# null applet still needs bonobo support for gnome-panel

#TODO: probably needs ported Mate python bindings
RDEPEND=">=x11-libs/gtk+-2.20:2
	>=dev-libs/glib-2.22:2
	mate-base/mate-conf
	mate-base/mate-panel
	>=x11-libs/libxklavier-4.0
	>=x11-libs/libwnck-2.9.3:1
	mate-base/mate-desktop
	>=x11-libs/libnotify-0.3.2
	>=sys-apps/dbus-1.1.2
	>=dev-libs/dbus-glib-0.74
	>=dev-libs/libxml2-2.5.0:2
	x11-themes/mate-icon-theme
	dev-libs/libmateweather
	x11-libs/libX11

	gnome?	(
		mate-base/mate-settings-daemon
		mate-base/libmate

		>=gnome-extra/gucharmap-2.23:0
		>=gnome-base/libgtop-2.11.92:2
		>=dev-python/pygobject-2.6:2
		>=dev-python/pygtk-2.6:2
		>=dev-python/gconf-python-2.10:2
		>=dev-python/gnome-applets-python-2.10 )
	gstreamer?	(
		>=media-libs/gstreamer-0.10.2:0.10
		>=media-libs/gst-plugins-base-0.10.14:0.10
		|| (
			>=media-plugins/gst-plugins-alsa-0.10.14:0.10
			>=media-plugins/gst-plugins-oss-0.10.14:0.10 ) )
	networkmanager? ( >=net-misc/networkmanager-0.7.0 )
	policykit? ( >=sys-auth/polkit-0.92 )"

DEPEND="${RDEPEND}
	>=app-text/scrollkeeper-0.1.4
	app-text/mate-doc-utils
	virtual/pkgconfig
	dev-util/gtk-doc
	>=dev-util/intltool-0.35
	dev-libs/libxslt
	~app-text/docbook-xml-dtd-4.3
	mate-base/mate-common"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README"
	G2CONF="${G2CONF}
		--without-hal
		--disable-battstat
		--disable-scrollkeeper
		--disable-schemas-install
		$(use_enable gstreamer mixer-applet)
		$(use_enable ipv6)
		$(use_enable networkmanager)
		$(use_enable policykit polkit)"

	python_set_active_version 2
}

src_prepare() {
	# disable pyc compiling
	echo '#!/bin/sh' > py-compile

	# Invest applet tests need gconf/proxy/...
	sed 's/^TESTS.*/TESTS=/g' -i invest-applet/invest/Makefile.am \
		invest-applet/invest/Makefile.in || die "disabling invest tests failed"

	python_convert_shebangs -r 2 .

	gtkdocize || die
	mate-doc-prepare --force --copy || die
	mate-doc-common --copy || die
	intltoolize --force --copy --automake || die "intltoolize failed"
	eautoreconf

	mate_src_prepare
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	emake check || die "emake check failed"
}

src_install() {
	mate_src_install

	local APPLETS="accessx-status charpick cpufreq drivemount geyes
			 gkb-new gswitchit gweather invest-applet mini-commander
			 mixer modemlights multiload null_applet stickynotes trashapplet"

	# modemlights is out because it needs system-tools-backends-1

	for applet in ${APPLETS} ; do
		docinto ${applet}

		for d in AUTHORS ChangeLog NEWS README README.themes TODO ; do
			[ -s ${applet}/${d} ] && dodoc ${applet}/${d}
		done
	done
}

pkg_postinst() {
	mate_pkg_postinst

	# check for new python modules on bumps
	python_mod_optimize invest
}

pkg_postrm() {
	mate_pkg_postrm
	python_mod_cleanup invest
}
