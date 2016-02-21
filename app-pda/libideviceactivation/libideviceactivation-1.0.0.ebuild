# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools

DESCRIPTION="A library to manage the activation process of Apple iOS devices."
HOMEPAGE="http://www.libimobiledevice.org/"
SRC_URI="http://www.libimobiledevice.org/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=app-pda/libimobiledevice-1.1.4:=
	>=app-pda/libplist-1.8:=
	>=dev-libs/libxml2-2.9.2-r4:=
	net-misc/curl
	app-pda/usbmuxd"
DEPEND="${RDEPEND}
	sys-devel/libtool
	virtual/pkgconfig"

DOCS="AUTHORS NEWS README"

src_prepare() {
	eautoreconf
}
