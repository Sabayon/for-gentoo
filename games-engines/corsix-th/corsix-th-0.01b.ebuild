# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v3
# $Header: $

EAPI="3"

CMAKE_MIN_VERSION="2.8.3"

inherit wxwidgets cmake-utils eutils games

MY_PN="CorsixTH"
MY_P="${MY_PN}-${PV}-Source"

DESCRIPTION="A project that aims to reimplement the game engine of Theme Hospital"
HOMEPAGE="http://code.google.com/p/corsix-th/"
SRC_URI="http://corsix-th.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="opengl +truetype +sound wxwidgets"

RDEPEND="
	>=media-libs/libsdl-1.2[X]
	>=dev-lang/lua-5.1
	opengl? ( virtual/opengl )
	truetype? ( media-libs/freetype:2 )
	sound? ( >=media-libs/sdl-mixer-1.2 )
	wxwidgets? ( x11-libs/wxGTK:2.9[X] )"
DEPEND="${RDEPEND}"

BUILD_DIR="${P}_build"
S="${WORKDIR}"

src_prepare() {
	# Patch CorsixTH.lua search path to allow separating the main executable
	# from the data directory
	epatch "${FILESDIR}/${P}-fix-corsixth-lua-search-path.patch"
}

src_configure() {
	# Define files search path
	local mycmakeargs=( "-DCORSIXTH_LUA_PATH=\\\"${GAMES_DATADIR}/${PN}\\\"" )

	# USE flag consistency check, 
	# replace with REQUIRED_USE when games eclass will be EAPI 4 ready
	if use wxwidgets && ! use opengl ; then
		die "map editor can only be built with OpenGL renderer"
	fi

	# Optional WxWidgets support
	if use wxwidgets ; then
		WX_GTK_VER="2.9"
		need-wxwidgets unicode
	fi

	# Select renderer, either opengl or SDL
	if use opengl ; then
		mycmakeargs+=( "-DWITH_OPENGL=ON" ) 
		mycmakeargs+=( "-DWITH_SDL=OFF" )
	fi

	# General setup
	mycmakeargs+=(
		$(cmake-utils_use_with truetype FREETYPE2)
		$(cmake-utils_use_with sound AUDIO)
		$(cmake-utils_use_build wxwidgets ANIMVIEWER)
		$(cmake-utils_use_build wxwidgets MAPEDITOR)
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	# Rewrite install procedure to fit with the filesystem
	cd "${MY_PN}" || die "cd failed"
	newgamesbin "${WORKDIR}/${BUILD_DIR}/CorsixTH/${MY_PN}" ${PN} || die "binary install failed"

	insinto "${GAMES_DATADIR}/${PN}"
	doins -r Lua Levels Bitmap CorsixTH.lua || die "data install failed"
	newdoc README.txt README || die "README install failed"
	newdoc changelog.txt ChangeLog || die "ChangeLog install failed"
	newicon Original_Logo.svg ${PN}.svg || die "icon install failed"
	make_desktop_entry ${PN} ${MY_PN} || die "desktop icon creation failed"

	# Optional editor components, should be dev tools, so don't create
	# desktop shortcuts
	if use wxwidgets ; then
		newgamesbin "${WORKDIR}/${BUILD_DIR}/AnimView/AnimView" ${PN}-AnimView || die "animation viewer install failed"
		newgamesbin "${WORKDIR}/${BUILD_DIR}/MapEdit/MapEdit" ${PN}-MapEdit || die "map editor install failed"
	fi

	prepgamesdirs
}

