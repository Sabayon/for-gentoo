# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
EGIT_REPO_URI="git://github.com/Baughn/Dwarf-Fortress--libgraphics-.git"
inherit games eutils git multilib

DESCRIPTION="Dwarf Fortress is a single-player fantasy game. You can control a dwarven outpost or an adventurer in a randomly generated, persistent world."
HOMEPAGE="http://www.bay12games.com/dwarves"
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="
	amd64? (
		media-libs/fmod[multilib]
		app-emulation/emul-linux-x86-soundlibs
		app-emulation/emul-linux-x86-sdl
		app-emulation/emul-linux-x86-baselibs
		app-emulation/emul-linux-x86-xlibs
	)
	!amd64? (
		media-libs/fmod
	)
	media-libs/libsndfile
	media-libs/openal
	virtual/glu
	dev-libs/boost
	media-libs/sdl-image
	media-libs/libsdl
	sys-libs/zlib
	sys-libs/ncurses
	dev-util/scons"
RDEPEND="${DEPEND}
	sys-libs/glibc
	amd64? (
		app-emulation/emul-linux-x86-gtklibs
	)
	!amd64? (
		x11-libs/gtk+:2
		dev-libs/atk
		x11-libs/pango
		dev-libs/glib
		x11-libs/cairo
		media-libs/freetype
		virtual/opengl
		x11-libs/libXinerama
		x11-libs/libXi
		x11-libs/libXrandr
		x11-libs/libXcursor
		x11-libs/libXcomposite
		x11-libs/libXext
		x11-libs/libXdamage
		x11-libs/libXfixes
		x11-libs/pixman
		media-libs/libpng
		x11-libs/libXrender
		x11-libs/libX11
		x11-libs/libxcb
		x11-libs/libXau
		x11-libs/libXdmcp
		dev-libs/expat
		x11-libs/libXxf86vm
		x11-libs/libdrm
	)"

pkg_setup() {
	if use amd64; then
		if ! has_multilib_profile; then
			eerror "You must be on a multilib profile to use dwarf fortress!"
			die "No multilib profile"
		fi
		multilib_toolchain_setup x86
	fi
}

src_prepare() {
	epatch "${FILESDIR}/${P}_gentoo.patch"
}

src_compile() {
	scons || die
}

src_install() {
	insinto "${GAMES_SYSCONFDIR}"
	mv data/init dwarfort || die
	doins -r dwarfort || die
	rm -r dwarfort || die

	keepdir "${GAMES_STATEDIR}"/dwarfort/save "${GAMES_STATEDIR}"/dwarfort/movies "${GAMES_STATEDIR}"/dwarfort/objects || die

	local dir="${GAMES_PREFIX_OPT}/${PN}"
	insinto "$dir"
	doins -r raw data || die
	exeinto "$dir"
	doexe dwarfort.exe || die

	into "${GAMES_PREFIX}"
	dolib libs/libgraphics.so libs/libboost_regex.so.1.35.0 || die
	dodoc README.linux *.txt || die

	dosym "${GAMES_SYSCONFDIR}"/dwarfort "$dir"/data/init || die
	dosym "${GAMES_STATEDIR}"/dwarfort/save "$dir"/data/save || die
	dosym "${GAMES_STATEDIR}"/dwarfort/movies "$dir"/data/movies || die
	dosym "${GAMES_STATEDIR}"/dwarfort/objects "$dir"/data/objects || die

	games_make_wrapper dwarfort "$dir"/dwarfort.exe "$dir"

	prepgamesdirs

	chmod -R g+w "${D}/${GAMES_STATEDIR}"/dwarfort || die
	chmod g+w "${D}/${dir}/data/index" || die
	chmod -R g+w "${D}/${dir}/data"/{announcement,dipscript,help} || die
}