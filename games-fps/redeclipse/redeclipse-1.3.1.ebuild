# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils games

DESCRIPTION="First-person ego-shooter, built as a total conversion of Cube Engine 2"
HOMEPAGE="http://www.redeclipse.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${PV}_all.tar.bz2"

LICENSE="as-is ZLIB CCPL-Attribution-ShareAlike-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dedicated"

DEPEND="!dedicated? (
		media-libs/libsdl[opengl]
		media-libs/sdl-image[jpeg,png]
		media-libs/sdl-mixer[mp3,vorbis]
		virtual/opengl
		x11-libs/libX11
	)
	net-libs/enet:1.3
	sys-libs/zlib
"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${P}

src_prepare() {
	cd "${S}" || die
	sed -i -e "s:\(addpackagedir(\"\)data:\1${GAMES_DATADIR}/${PN}/data:" \
		src/engine/server.cpp || die "Sed failed"

	sed -i \
		-e "s:\(client\)\: libenet:\1\::" \
		-e   "s:\(server\)\: libenet:\1\::" \
		src/Makefile || die "Sed failed"

	sed -i "/STRIP=strip/d" src/Makefile || die
}

src_compile() {
	cd src
	if ! use dedicated ; then
		emake CXXFLAGS="${CXXFLAGS}" client server || die
	else
		emake CXXFLAGS="${CXXFLAGS}" server || die
	fi
}

src_install() {
	newgamesbin src/reserver ${PN}-server || die
	dodir "${GAMES_DATADIR}"/${PN}/ || die 
	insinto "${GAMES_DATADIR}"/${PN}/ || die
	doins -r "${S}"/data || die

	dodoc readme.txt
	if ! use dedicated ; then
		newgamesbin src/reclient "${PN}" || die
	fi
	prepgamesdirs
}
