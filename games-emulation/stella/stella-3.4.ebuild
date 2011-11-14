# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/stella/stella-3.4.ebuild,v 1.4 2011/11/10 16:39:06 mr_bones_ Exp $

EAPI=2
inherit eutils games

DESCRIPTION="Stella Atari 2600 VCS Emulator"
HOMEPAGE="http://stella.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="joystick opengl"

DEPEND="media-libs/libsdl[joystick?,video]
	x11-libs/libX11
	media-libs/libpng
	sys-libs/zlib
	opengl? ( virtual/opengl )"

src_prepare() {
	sed -i \
		-e '/INSTALL/s/-s //' \
		-e '/STRIP/d' \
		-e "/icons/d" \
		-e '/INSTALL.*DOCDIR/d' \
		-e '/INSTALL.*\/applications/d' \
		Makefile \
		|| die "sed failed"
	# build with newer zlib (bug #390093)
	sed -i -e '60i#define OF(x) x' src/emucore/unzip.h || die

	epatch "${FILESDIR}/${P}-zlib.patch"
}

src_configure() {
	# not an autoconf script
	./configure \
		--prefix="/usr" \
		--bindir="${GAMES_BINDIR}" \
		--docdir="/usr/share/doc/${PF}" \
		--datadir="${GAMES_DATADIR}" \
		$(use_enable opengl gl) \
		$(use_enable joystick) \
		|| die
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	doicon src/common/stella.png
	make_desktop_entry stella Stella
	dohtml -r docs/*
	dodoc Announce.txt Changes.txt Copyright.txt README-SDL.txt Readme.txt Todo.txt
	prepgamesdirs
}
