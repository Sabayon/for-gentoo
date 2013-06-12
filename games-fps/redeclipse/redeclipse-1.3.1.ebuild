# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils games

DESCRIPTION="First-person ego-shooter, built as a total conversion of Cube Engine 2"
HOMEPAGE="http://www.redeclipse.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${PV}_all.tar.bz2"

# According to license.txt file
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
	# Respect GAMES_DATADIR
	sed -i -e "s:\(addpackagedir(\"\)data:\1${GAMES_DATADIR}/${PN}/data:" \
		src/engine/server.cpp || die "sed failed"
	echo "\n ${GAMES_DATADIR} \n This is the variabile"

	# Unbundle enet
	sed -i \
		-e "s:\(client\)\: libenet:\1\::" \
		-e   "s:\(server\)\: libenet:\1\::" \
		src/Makefile || die "sed failed"

	# Remove strip
	sed -i "/STRIP=strip/d" src/Makefile || die "sed failed"
}

src_compile() {
	cd src
	if ! use dedicated ; then
		emake CXXFLAGS="${CXXFLAGS}" client server || die "Make failed"
	else
		emake CXXFLAGS="${CXXFLAGS}" server
	fi
}

src_install() {
	newgamesbin src/reserver ${PN}-server || die
	dodir ${GAMES_DATADIR}/${PN}/ || die "Was not able to create the directory"
	insinto ${GAMES_DATADIR}/${PN}/ || die "There is no such directory or file"
	doins -r "${S}"/data || die "Cannot copy the directory: Not existent"

	dodoc readme.txt
	if ! use dedicated ; then
		newgamesbin src/reclient ${PN} || die
		#insinto "${GAMES_DATADIR}"/${PN}
		#doins -r data
		#newicon src/site/bits/favicon.png ${PN}.png || die
		#make_desktop_entry ${PN} "Red Eclipse" ${PN}
	fi

	prepgamesdirs
}
