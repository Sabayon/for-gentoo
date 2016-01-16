# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v3
# $Header: $

EAPI="3"

WX_GTK_VER="2.8"

inherit wxwidgets eutils games

MY_PN="zod_linux"
MY_P="${MY_PN}-${PV:0:4}-${PV:4:2}-${PV:6:2}"

DESCRIPTION="Zod Engine is a remake of the 1996 classic game by Bitmap Brothers called Z"
HOMEPAGE="http://zod.sourceforge.net/"
SRC_URI="mirror://sourceforge/zod/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=media-libs/libsdl-1.2[X]
	>=media-libs/sdl-ttf-2.0[X]
	>=media-libs/sdl-mixer-1.2[timidity]
	>=media-libs/sdl-image-1.2
	virtual/mysql
	x11-libs/wxGTK:2.8[X]"
DEPEND="${RDEPEND}"

S="${WORKDIR}/zod_engine"

src_prepare() {
	# various fixes and proper linux platform and filesystem support
	epatch "${FILESDIR}/${P}-proper-linux-support.patch"

	# fix files, this project really should provide a make install

	# remove Thumbs.db files
	find . -type f -name Thumbs.db -exec rm -f {} \; || die
	# remove GIMP .xcf files
	find . -type f -name "*.xcf" -exec rm -f {} \; || die
	# remove Windows .ico files, unused on Linux build
	find . -type f -name "*.ico" -exec rm -f {} \; || die
	# remove useless icescene file
	rm -f "assets/WebCamScene.icescene" || die
	# remove unused splash screen
	rm -f "assets/splash.png" || die
}

src_compile() {
	emake -C zod_src DATA_PATH="\"${GAMES_DATADIR}/${PN}\"" map_editor main || die
	emake -C zod_launcher_src DATA_PATH="\"${GAMES_DATADIR}/${PN}\"" || die
}

src_install() {
	# custom install procedure for Gentoo
	insinto "${GAMES_DATADIR}/${PN}"
	doins -r assets blank_maps *.map default_settings.txt *map_list.txt || die
	dogamesbin zod_launcher_src/zod_launcher || die
	dogamesbin zod_src/zod || die
	dogamesbin zod_src/zod_map_editor || die

	newicon assets/icon.png ${PN}.png || die
	make_desktop_entry zod_launcher "Zod Engine" || die

	dodoc zod_engine_help.txt map_editor_help.txt || die

	prepgamesdirs
}
