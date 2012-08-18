# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-input-synaptics/xf86-input-synaptics-1.6.2.ebuild,v 1.6 2012/08/11 12:54:08 maekke Exp $

EAPI=4

inherit linux-info xorg-2 eutils

DESCRIPTION="Driver for Synaptics touchpads"
HOMEPAGE="http://cgit.freedesktop.org/xorg/driver/xf86-input-synaptics/"

KEYWORDS="amd64 ~arm ~mips ppc ppc64 x86"
IUSE=""

RDEPEND="sys-libs/mtdev
	>=x11-base/xorg-server-1.8
	>=x11-libs/libXi-1.2
	>=x11-libs/libXtst-1.1.0"
DEPEND="${RDEPEND}
	>=sys-kernel/linux-headers-2.6.37
	>=x11-proto/recordproto-1.14"

DOCS=( "README" )

pkg_pretend() {
	linux-info_pkg_setup
	# Just a friendly warning
	if ! linux_config_exists \
			|| ! linux_chkconfig_present INPUT_EVDEV; then
		echo
		ewarn "This driver requires event interface support in your kernel"
		ewarn "  Device Drivers --->"
		ewarn "    Input device support --->"
		ewarn "      <*>     Event interface"
		echo
	fi
}

src_prepare() {
	xorg-2_src_prepare
	epatch "${FILESDIR}/${PN}-untypedef_model_lookup_t.patch"
	epatch "${FILESDIR}/${PN}-add_model_unibody_macbook.patch"
	epatch "${FILESDIR}/${PN}-turn_down_sensitivity_macbook.patch"
}
