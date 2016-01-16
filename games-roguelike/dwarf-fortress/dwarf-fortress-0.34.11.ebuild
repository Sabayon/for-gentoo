# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit games versionator

MY_PV=$(replace_all_version_separators _ "$(get_version_component_range 2-)")
MY_PN=df
MY_P=${MY_PN}_${MY_PV}

DESCRIPTION="A single-player fantasy game"
HOMEPAGE="http://www.bay12games.com/dwarves"
SRC_URI="http://www.bay12games.com/dwarves/${MY_P}_linux.tar.bz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86 -*"
IUSE=""
# this is all precompiled
RESTRICT="strip"

RDEPEND="
	virtual/glu
	amd64? (
		app-emulation/emul-linux-x86-baselibs
		app-emulation/emul-linux-x86-gtklibs
		app-emulation/emul-linux-x86-opengl
		app-emulation/emul-linux-x86-sdl
		app-emulation/emul-linux-x86-soundlibs
		app-emulation/emul-linux-x86-xlibs
	)
	x86? (
		media-libs/fmod:1
		media-libs/freetype
		media-libs/libsdl[opengl,video,X]
		media-libs/libsndfile[alsa]
		media-libs/openal
		media-libs/sdl-image[png,tiff,jpeg]
		media-libs/sdl-ttf
		sys-libs/zlib
		x11-libs/cairo[xcb,X]
		x11-libs/gtk+:2[xinerama]
		x11-libs/libXcomposite
		x11-libs/libXcursor
		x11-libs/pango[X]
	)"

S=${WORKDIR}/${MY_PN}_linux

src_install() {
	# install config stuff
	insinto "${GAMES_SYSCONFDIR}"/${PN}
	doins -r data/init/* || die

	# keep saves, movies and objects directories
	keepdir "${GAMES_STATEDIR}"/${PN}/save \
		"${GAMES_STATEDIR}"/${PN}/movies \
		"${GAMES_STATEDIR}"/${PN}/objects || die

	# install data-files and libs
	local gamesdir="${GAMES_PREFIX_OPT}/${PN}"
	insinto "${gamesdir}"
	rm -r data/{movies,init} || die
	doins -r raw data libs || die

	# install our wrapper
	newgamesbin "${FILESDIR}"/${PN}-wrapper ${PN} || die

	# install docs
	dodoc README.linux *.txt || die

	# create symlinks for several directories we want to have 
	# in a different place
	dosym "${GAMES_SYSCONFDIR}"/${PN} "${gamesdir}"/data/init || die
	dosym "${GAMES_STATEDIR}"/${PN}/save "${gamesdir}"/data/save || die
	dosym "${GAMES_STATEDIR}"/${PN}/movies "${gamesdir}"/data/movies || die
	dosym "${GAMES_STATEDIR}"/${PN}/objects "${gamesdir}"/data/objects || die

	prepgamesdirs

	# fix a few permissions
	fperms 0755 \
		"${gamesdir}"/libs/{Dwarf_Fortress,libgcc_s.so.1,libgraphics.so,libstdc++.so.6} || die
	fperms -R g+w "${GAMES_STATEDIR}"/${PN} || die
	fperms g+w "${gamesdir}"/data/index || die
	fperms -R g+w "${gamesdir}"/data/{announcement,dipscript,help} || die
}
