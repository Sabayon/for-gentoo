# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-sports/vdrift/vdrift-20111022.ebuild,v 1.5 2012/07/24 16:52:50 mr_bones_ Exp $

EAPI=4
inherit eutils scons-utils games

MY_P=${PN}-${PV:0:4}-${PV:4:2}-${PV:6:2}
DESCRIPTION="A driving simulation made with drift racing in mind"
HOMEPAGE="http://vdrift.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-3 ZLIB"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=app-arch/libarchive-2.8.3
	>=media-libs/glew-1.5.7
	>=media-libs/libsdl-1.2.14[opengl,video]
	>=media-libs/sdl-gfx-2.0.16
	>=media-libs/sdl-image-1.2.10[png]
	>=media-libs/libvorbis-1.2.0
	>=net-misc/curl-7.21.6
	>=sci-physics/bullet-2.78[-double-precision]
	virtual/opengl
	virtual/glu"
DEPEND="${RDEPEND}
	dev-cpp/asio
	dev-libs/boost
	virtual/pkgconfig"

S=${WORKDIR}/"VDrift"

src_prepare() {
	epatch "${FILESDIR}/${MY_P}c.patch"

	if has_version ">=sci-physics/bullet-2.81"; then
		epatch "${FILESDIR}/vdrift-2012-07-22c_bullet281.patch"
	fi

	epatch "${FILESDIR}/vdrift-2012-07-22c-SDL-header.patch"
}

src_compile() {
	escons \
		force_feedback=1 \
		extbullet=1 \
		destdir="${D}" \
		bindir="${GAMES_BINDIR}" \
		datadir="${GAMES_DATADIR}"/${PN} \
		prefix= \
		use_binreloc=0 \
		release=1 \
		os_cc=1 \
		os_cxx=1 \
		os_cxxflags=1
}

src_install() {
	dogamesbin build/vdrift || die
	insinto "${GAMES_DATADIR}/${PN}"
	doins -r data/* || die
	newicon data/textures/icons/vdrift-64x64.png ${PN}.png
	make_desktop_entry ${PN} VDrift
	find "${D}" -name "SCon*" -exec rm \{\} +
	cd "${D}"
	keepdir $(find "${GAMES_DATADIR/\//}/${PN}" -type d -empty)
	prepgamesdirs
}
