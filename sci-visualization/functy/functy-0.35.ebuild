# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils

DESCRIPTION="a 3D graph drawing package"
HOMEPAGE="http://functy.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=sci-libs/symbolic-0.31
	x11-libs/gtk+:2
	x11-libs/gdk-pixbuf:2
	x11-libs/gtkglext
	dev-libs/libzip
	media-libs/glee
	media-libs/freeglut
	>=media-gfx/openvdb-3.1.0
	media-libs/libpng:="
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/glee.patch"
	eautoreconf
}

src_install() {
	DESTDIR="${D}" emake install
	doicon "${WORKDIR}"/${P}/assets/icons/${PN}.png
	make_desktop_entry ${PN} ${PN} ${PN} "Science"
}
