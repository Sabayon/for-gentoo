# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/ultrastar-deluxe/ultrastar-deluxe-9999.ebuild,v 1.1 2010/06/14 22:47:02 frostwork Exp $

EAPI="2"

inherit eutils games flag-o-matic subversion

ESVN_REPO_URI="https://${PN}.svn.sourceforge.net/svnroot/${PN}/trunk"

DESCRIPTION="A free and open source karaoke game"
HOMEPAGE="http://ultrastardx.sourceforge.net/"
#SRC_URI="http://switch.dl.sourceforge.net/sourceforge/ultrastardx/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+projectm"

RDEPEND="media-libs/sdl-image
	media-libs/libsdl[opengl]
	media-libs/sdl-mixer
	media-libs/sdl-ttf
	projectm? ( media-libs/libprojectm )
	=media-libs/portaudio-19*
	virtual/ffmpeg
	dev-db/sqlite
	virtual/glu"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=dev-lang/fpc-2.2.0"

src_unpack() {
	subversion_src_unpack
}

src_prepare(){
	sed -i -e "s:libpng12:libpng:" -i configure
}

src_compile() {
	egamesconf \
		$(use_with libprojectM) \
		|| die "Configure failed!"
	emake \
	LDFLAGS="" \
	|| die "emake failed"
}

src_install() {
	dogamesbin game/ultrastardx
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r game/covers  game/fonts game/languages game/playlists game/plugins game/resources game/sounds game/themes || die
	keepdir "${GAMES_DATADIR}"/${PN}/covers
	keepdir "${GAMES_DATADIR}"/${PN}/songs
	newicon icons/ultrastardx-icon.svg ultrastardx.svg
	make_desktop_entry ${PN} "Ultrastar Deluxe"
	dodoc README*
	prepgamesdirs
}
