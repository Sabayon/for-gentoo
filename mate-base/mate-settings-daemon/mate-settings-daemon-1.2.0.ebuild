# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

EAPI="4"
GCONF_DEBUG="yes"

inherit autotools eutils mate mate-desktop.org

DESCRIPTION="MATE Settings Daemon"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="debug libnotify policykit pulseaudio smartcard"

COMMON_DEPEND=">=dev-libs/dbus-glib-0.74
	>=dev-libs/glib-2.18:2
	>=x11-libs/gtk+-2.21.2:2
	>=mate-base/mate-conf-1.2.1
	>=mate-base/libmatekbd-1.2.0
	>=mate-base/mate-desktop-1.2.0

	x11-libs/libX11
	x11-libs/libXi
	x11-libs/libXext
	x11-libs/libXxf86misc
	>=x11-libs/libxklavier-5.0
	media-libs/fontconfig

	libnotify? ( >=x11-libs/libmatenotify-1.2.0 )
	policykit? (
		>=sys-auth/polkit-0.91
		>=dev-libs/dbus-glib-0.71
		>=sys-apps/dbus-1.1.2 )
	pulseaudio? (
		>=media-sound/pulseaudio-0.9.15
		media-libs/libcanberra[gtk] )
	!pulseaudio? (
		>=media-libs/gstreamer-0.10.1.2:0.10
		>=media-libs/gst-plugins-base-0.10.1.2:0.10 )
	smartcard? ( >=dev-libs/nss-3.11.2 )"

# 50-accessibility.xml moved to gnome-control-center in gnome-3
RDEPEND="${COMMON_DEPEND}"

DEPEND="${COMMON_DEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.40
	virtual/pkgconfig
	x11-proto/inputproto
	x11-proto/xproto"

pkg_setup() {
	# README is empty
	DOCS="AUTHORS NEWS ChangeLog"
	G2CONF="${G2CONF}
		--disable-static
		$(use_enable debug)
		$(use_with libnotify)
		$(use_enable policykit polkit)
		$(use_enable pulseaudio pulse)
		$(use_enable !pulseaudio gstreamer)
		$(use_enable smartcard smartcard-support)"

	if use pulseaudio; then
		elog "Building volume media keys using Pulseaudio"
	else
		elog "Building volume media keys using GStreamer"
	fi
}

src_prepare() {
	mate_src_prepare

	# We use now debian patch as looks to fix bug #327609
	# epatch "${DISTDIR}/${PN}-2.30.0-gst-vol-control-support.patch"
	# epatch "${DISTDIR}/${PN}-2.32.1-gst-vol-control-support.patch"

	# More network filesystems not to monitor, upstream bug #606421
	# epatch "${FILESDIR}/${PN}-2.32.1-netfs-monitor.patch"

	# xsettings: Export Xft.lcdfilter for OO.o's benefit, upstream bug #631924
	# epatch "${FILESDIR}/${PN}-2.32.1-lcdfilter.patch"

	# media-keys: React to stream-removed signal from GvcMixerControl
	# epatch "${FILESDIR}/${PN}-2.32.1-media-keys-react.patch"

	# mouse: Use event driven mode for syndaemon
	# epatch "${FILESDIR}/${PN}-2.32.1-syndaemon-mode.patch"

	intltoolize --force --copy --automake || die "intltoolize failed"
	eautoreconf
}

pkg_postinst() {
	mate_pkg_postinst

	if ! use pulseaudio; then
		elog "GStreamer volume control support is a feature powered by Gentoo GNOME Team"
		elog "PLEASE DO NOT report bugs upstream, report on https://bugs.gentoo.org instead"
	fi
}
