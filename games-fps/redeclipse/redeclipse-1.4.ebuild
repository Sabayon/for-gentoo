# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit games versionator

MAJOR_VERSION=$(get_version_component_range 1-2)

DESCRIPTION="First-person ego-shooter, built as a total conversion of Cube Engine 2"
HOMEPAGE="http://www.redeclipse.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${MAJOR_VERSION}/${PN}_${PV}_nix.tar.bz2"

# According to doc/license.txt file
LICENSE="HPND ZLIB CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dedicated"

DEPEND="!dedicated? (
		media-libs/freetype:2
		media-libs/libsdl:0[opengl]
		media-libs/sdl-image:0[jpeg,png]
		media-libs/sdl-mixer:0[mp3,vorbis]
		virtual/opengl
		x11-libs/libX11
	)
	net-libs/enet:1.3
	sys-libs/zlib"
RDEPEND="${DEPEND}"

#S=${WORKDIR}/${PN}

src_prepare() {
	# Respect GAMES_DATADIR
	epatch "${FILESDIR}"/${P}_gamesdatadir.patch
#	sed -e "s:\(addpackagedir(\"\)data:\1${GAMES_DATADIR}/${PN}/data:" \
#		-e "s:::"
#
#		-i src/engine/server.cpp

	# Unbundle enet
	sed	-e "s:\(client\)\: libenet:\1\::" \
		-e "s:\(server\)\: libenet:\1\::" \
		-e "s:-Lenet/.libs ::" \
		-e "s:-Ienet/include ::" \
		-i src/core.mk
	sed -e ":src/enet \\:d" -i src/dist.mk
	rm -r src/enet

	#respect LDFLAGS
#	sed -e "/^client/,+1s:-o reclient:-o reclient \$(LDFLAGS):" \
#		-e "/^server/,+1s:-o reserver:-o reserver \$(LDFLAGS):" \
#		-i src/core.mk

	# Menu and mans
	sed -e "s:@APPNAME@:${PN}:" \
		src/install/nix/redeclipse.desktop.am \
		> src/install/nix/redeclipse.desktop

	sed -e "s:@LIBEXECDIR@:$(games_get_libdir):g" \
		-e "s:@DATADIR@:${GAMES_DATADIR}:g" \
		-e "s:@DOCDIR@:${GAMES_DATADIR_BASE}/doc/${PF}:" \
		-e "s:@REDECLIPSE@:${PN}:g" \
		doc/man/redeclipse.6.am \
		> doc/man/redeclipse.6

	sed -e "s:@LIBEXECDIR@:$(games_get_libdir):g" \
		-e "s:@DATADIR@:${GAMES_DATADIR}:g" \
		-e "s:@DOCDIR@:${GAMES_DATADIR_BASE}/doc/${PF}:" \
		-e "s:@REDECLIPSE@:${PN}:g" \
		doc/man/redeclipse-server.6.am \
		> doc/man/redeclipse-server.6

}

src_compile() {
#	cd src
	if ! use dedicated ; then
		emake CXXFLAGS="${CXXFLAGS}" STRIP= -C src client server
	else
		emake CXXFLAGS="${CXXFLAGS}" STRIP= -C src server
	fi
}

src_install() {
	dogamesbin src/${PN}_server
	doman doc/man/redeclipse-server.6
	dodoc readme.txt doc/examples/servinit.cfg
	if ! use dedicated ; then
		dogamesbin src/redeclipse

		insinto "${GAMES_DATADIR}"/${PN}
		doins -r data game
		newicon src/install/nix/${PN}_x128.png ${PN}.png
		domenu src/install/nix/redeclipse.desktop
		doman doc/man/redeclipse.6
	fi

	prepgamesdirs
}
