# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/bombono-dvd/bombono-dvd-1.0.2.ebuild,v 1.1 2011/04/25 17:09:57 dilfridge Exp $

EAPI=4

inherit base scons-utils toolchain-funcs flag-o-matic

DESCRIPTION="GUI DVD authoring program"
HOMEPAGE="http://www.bombono.org/"
SRC_URI="mirror://sourceforge/bombono/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~x86"

IUSE=""

RDEPEND="
	app-i18n/enca
	app-cdr/dvd+rw-tools
	dev-cpp/gtkmm:2.4
	dev-cpp/libxmlpp:2.6
	dev-libs/boost
	media-libs/libdvdread
	media-sound/twolame
	media-video/dvdauthor
	virtual/ffmpeg
	>=media-video/mjpegtools-1.8.0
	x11-libs/gtk+:2
"

DEPEND=">=dev-util/scons-0.96.1
	${RDEPEND}"

PATCHES=( "${FILESDIR}/${PN}-1.0.1-cflags.patch"
	  "${FILESDIR}/${P}-libav.patch" )

src_compile() {
	append-flags -DBOOST_FILESYSTEM_VERSION=2

	tc-export CC CXX

	nonfatal escons CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" LDFLAGS="${LDFLAGS}" \
		DESTDIR="${D}" PREFIX="/usr" \
		CPPFLAGS='-UBOOST_SYSTEM_NO_DEPRECATED' USE_EXT_BOOST=1 \
		|| die 'Please add "${S}/config.opts" when filing bugs reports!'
}

src_install() {
	nonfatal escons install || die 'Please add "${S}/config.opts" when filing bugs reports!'
}
