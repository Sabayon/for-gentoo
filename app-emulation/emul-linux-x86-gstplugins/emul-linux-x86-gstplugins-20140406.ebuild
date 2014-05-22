# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit emul-linux-x86

LICENSE="GPL-2 LGPL-2 LGPL-2.1"
KEYWORDS="-* amd64"
IUSE="abi_x86_32"

DEPEND=""
RDEPEND="~app-emulation/emul-linux-x86-baselibs-${PV}
	~app-emulation/emul-linux-x86-db-${PV}
	~app-emulation/emul-linux-x86-gtklibs-${PV}
	~app-emulation/emul-linux-x86-medialibs-${PV}
	~app-emulation/emul-linux-x86-soundlibs-${PV}
	media-libs/gst-plugins-good:0.10[abi_x86_32(-)]
	media-libs/gst-plugins-bad:0.10[abi_x86_32(-)]
	media-libs/gst-plugins-ugly:0.10[abi_x86_32(-)]
"

src_install() {
	use abi_x86_32 || emul-linux-x86_src_install
}
