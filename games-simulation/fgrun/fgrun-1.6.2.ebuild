# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils cmake-utils games

DESCRIPTION="A graphical frontend for the FlightGear Flight Simulator"
HOMEPAGE="http://sourceforge.net/projects/fgrun"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEPEND="
	>=dev-games/openscenegraph-3.0.1
	sys-libs/zlib
	x11-libs/fltk:1[opengl,threads]
"
DEPEND="${COMMON_DEPEND}
	>=dev-games/simgear-2
	>=dev-libs/boost-1.34
"
RDEPEND="${COMMON_DEPEND}
	>=games-simulation/flightgear-2
"

src_prepare() {
	cmake-utils_src_prepare
}

src_configure() {
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	dodoc AUTHORS NEWS
	prepgamesdirs
}
