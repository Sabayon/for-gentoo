# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

MY_P="${PN}_${PV}"

inherit cmake-utils fdo-mime flag-o-matic games

DESCRIPTION="A 3D multiplayer real-time strategy game engine"
HOMEPAGE="http://springrts.com"
SRC_URI="mirror://sourceforge/springrts/${MY_P}_src.tar.lzma"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+ai +java +default multithreaded headless dedicated test-ai debug custom-cflags"

GUI_DEPEND="
	media-libs/devil[jpeg,png,opengl]
	media-libs/freetype:2
	>=media-libs/glew-1.4
	>=media-libs/libsdl-1.2.0[X,opengl]
	media-libs/openal
	media-libs/libvorbis
	media-libs/libogg
	virtual/glu
	virtual/opengl
	x11-libs/libXcursor
"

RDEPEND="
	>=dev-libs/boost-1.35
	>=sys-libs/zlib-1.2.5.1[minizip]
	media-libs/devil[jpeg,png]
	java? ( virtual/jdk )
	default? ( ${GUI_DEPEND} )
	multithreaded? ( ${GUI_DEPEND} )
"

DEPEND="${RDEPEND}
	>=sys-devel/gcc-4.2
	app-arch/xz-utils
"

# EAPI4 only, which isn't supported by games eclass
# REQUIRED_USE="
# 	java? ( ai )
# 	test-ai? ( ai )
# "

S="${WORKDIR}/${MY_P}"

src_test() {
	cmake-utils_src_test
}

src_configure() {
	local mycmakeargs=()

	# Custom cflags may break online play
	if ! use custom-cflags ; then
		strip-flags
	else
		mycmakeargs+=( "-DMARCH_FLAG=$(get-flag march)" )
	fi

	# AI
	if use ai; then
		use java || mycmakeargs+=( "-DAI_TYPES=NATIVE" )
		use test-ai || mycmakeargs+=( "-DAI_EXCLUDE_REGEX=\"Null|Test\"" )
	else
		mycmakeargs+=( "-DAI_TYPES=NONE" )
	fi

	# Selectively enable/disable build targets
	local build_type
	for build_type in default multithreaded headless dedicated ; do
		mycmakeargs+=( $(cmake-utils_use ${build_type} BUILD_spring-${build_type}) )
	done

	# Set common dirs
	local LIBDIR="$(games_get_libdir)"
	local VERSION_DATADIR="${GAMES_DATADIR}/${PN}"
	mycmakeargs+=(
		"-DBINDIR=${GAMES_BINDIR#/usr/}"
		"-DLIBDIR=${LIBDIR#/usr/}"
		"-DDATADIR=${VERSION_DATADIR#/usr/}"
	)

	# Configure
	cmake-utils_src_configure
}

src_compile () {
	cmake-utils_src_compile
}

src_install () {
	cmake-utils_src_install

	prepgamesdirs

	if use custom-cflags ; then
		ewarn "You decided to use custom CFLAGS. This may be safe, or it may cause your computer to desync more or less often."
		ewarn "If you experience desyncs, disable it before doing any bugreport."
		ewarn "If you don't know what you are doing, *disable custom-cflags*."
	fi
}

pkg_postinst() {
	fdo-mime_mime_database_update
	games_pkg_postinst
}
