# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit games

MY_P=${P//-/_}
# They have a typo in their filename:
MY_P=${MY_P/community/comunity}

DESCRIPTION="Community Map Pack for the Warsow multiplayer FPS"
HOMEPAGE="http://www.warsow.net/"
SRC_URI="http://www.warsow.net/release/${MY_P}.zip"

LICENSE="GPL-2 warsow"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="games-fps/warsow"

S="${WORKDIR}"

src_install() {
	insinto "${GAMES_DATADIR}"/warsow
	doins -r "${WORKDIR}"/basewsw || die
	doins -r "${WORKDIR}"/previews || die

	dodoc "${WORKDIR}"/Readme.rtf || die

	prepgamesdirs
}
