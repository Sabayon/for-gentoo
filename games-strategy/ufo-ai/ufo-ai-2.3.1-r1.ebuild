# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/ufo-ai/ufo-ai-2.3.1-r1.ebuild,v 1.6 2011/08/20 08:08:34 aballier Exp $

EAPI=2
inherit eutils flag-o-matic games

MY_P="${P/o-a/oa}"

DESCRIPTION="UFO: Alien Invasion - X-COM inspired strategy game"
HOMEPAGE="http://ufoai.sourceforge.net/"
SRC_URI="mirror://sourceforge/ufoai/${MY_P}-source.tar.bz2
	mirror://sourceforge/ufoai/${MY_P}-data.tar
	http://mattn.ninex.info/1maps.pk3"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE="debug dedicated doc editor"

# Dependencies and more instructions can be found here:
# http://ufoai.ninex.info/wiki/index.php/Compile_for_Linux
RDEPEND="!dedicated? (
		virtual/opengl
		virtual/glu
		media-libs/libsdl
		media-libs/sdl-image[jpeg,png]
		media-libs/sdl-ttf
		media-libs/sdl-mixer
		virtual/jpeg
		media-libs/libpng
		media-libs/libogg
		media-libs/libvorbis
		x11-proto/xf86vidmodeproto
	)
	net-misc/curl
	sys-devel/gettext
	sys-libs/zlib
	editor? (
		dev-libs/libxml2:2
		virtual/jpeg
		media-libs/openal
		x11-libs/gtkglext
		x11-libs/gtksourceview:2.0
	)"

DEPEND="${RDEPEND}
	doc? (
		virtual/latex-base
		dev-texlive/texlive-latexextra
	)"

S=${WORKDIR}/${MY_P}-source

src_prepare() {
	epatch "${FILESDIR}"/${P}-libpng15.patch
	epatch "${FILESDIR}"/${P}-damn-gentoo-zlib.patch
	cp "${DISTDIR}"/1maps.pk3 "${WORKDIR}"/base/ || die
	mv "${WORKDIR}"/base/ "${S}"/ || die "Moving data failed"
}

src_configure() {
	strip-flags # bug #330381
	egamesconf \
		$(use_enable !debug release) \
		$(use_enable editor ufo2map) \
		$(use_enable editor uforadiant) \
		--enable-dedicated \
		$(use_enable !dedicated client) \
		--bindir="${GAMES_BINDIR}" \
		--datarootdir="${GAMES_DATADIR_BASE}" \
		--datadir="${GAMES_DATADIR}" \
		--localedir="${GAMES_DATADIR}/${PN/-}/base/i18n/"
}

src_compile() {
	if use doc ; then
		emake pdf-manual || die "emake pdf-manual failed"
	fi

	emake || die "emake failed"
	emake lang || die "emake lang failed"

	if use editor; then
		emake uforadiant || die "emake uforadiant failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install_exec || die

	newicon src/ports/linux/ufo.png ${PN}.png || die
	make_desktop_entry ufoded "UFO: Alien Invasion Server" ${PN}
	if ! use dedicated ; then
		make_desktop_entry ufo "UFO: Alien Invasion" ${PN}
	fi

	# install data
	insinto "${GAMES_DATADIR}"/${PN/-}/base/
	doins base/*.pk3 || die

	if use doc ; then
		dodoc src/docs/tex/ufo-manual_EN.pdf || die
	fi

	# move translations where they belong
	dodir "${GAMES_DATADIR_BASE}/locale" || die
	mv "${D}/${GAMES_DATADIR}/${PN/-}/base/i18n/"* \
		"${D}/${GAMES_DATADIR_BASE}/locale/" || die
	rm -rf "${D}/${GAMES_DATADIR}/${PN/-}/base/i18n/" || die
	dosym "${GAMES_DATADIR_BASE}/locale/" "${GAMES_DATADIR}/${PN/-}/base/i18n" || die

	prepgamesdirs
}
