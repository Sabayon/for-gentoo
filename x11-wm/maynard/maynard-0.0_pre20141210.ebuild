# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils autotools


KEYWORDS="~arm"
BUILD="a3ece65"
DESCRIPTION="Desktop environment designed for the Raspberry Pi"
HOMEPAGE="https://github.com/raspberrypi/maynard/wiki"
SRC_URI="https://github.com/raspberrypi/maynard/tarball/${BUILD} -> ${P}.tar.gz"

RESTRICT="mirror"
LICENSE="GPL-2+ MIT"
SLOT="0"
IUSE=""
S="${WORKDIR}/raspberrypi-${PN}-${BUILD}"

RDEPEND=">=dev-libs/wayland-1.0.2
	>=dev-libs/weston-1.5.91
	>=x11-libs/gtk+-3.10:3[wayland]
	gnome-base/gnome-menus:3
	gnome-base/gnome-desktop:3
	media-libs/alsa-lib"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=dev-util/intltool-0.40"

src_prepare() {
	epatch_user
	eautoreconf
}

pkg_postinst() {
	ewarn "Maynard requires a background from kde-wallpapers, which does not seem"
	ewarn "to be even provided anymore. Set the BACKGROUND environment variable"
	ewarn "to point to a background image that exists, in order to be able to"
	ewarn "launch Maynard for now."
	# FIXME: Additionally opening the application menu freezes weston for me
}
