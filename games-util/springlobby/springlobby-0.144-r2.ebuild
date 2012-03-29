# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit cmake-utils eutils flag-o-matic games

DESCRIPTION="Lobby client for Spring RTS engine"
HOMEPAGE="http://springlobby.info"
SRC_URI="http://www.springlobby.info/tarballs/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+torrent +sound debug libnotify gstreamer"

RDEPEND="
	games-engines/spring
        >=dev-libs/boost-1.35
	x11-libs/wxGTK:2.8[X]
	net-misc/curl
	libnotify? ( x11-libs/libnotify )
	sound? ( 
		  media-libs/openal
		  media-libs/libvorbis
		  media-libs/flac
		  media-sound/mpg123
	)
	gstreamer? ( media-libs/gstreamer )
	torrent? ( >=net-libs/rb_libtorrent-0.14 )
"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=dev-util/cmake-2.6.0
"

src_configure() {
	local mycmakeargs=()

	if use torrent ; then
		CFLAGS="$CFLAGS $(pkg-config --cflags libtorrent-rasterbar)"
		CXXFLAGS="$CXXFLAGS $(pkg-config --cflags libtorrent-rasterbar)"
		LDFLAGS="$LDFLAGS,$(pkg-config --libs libtorrent-rasterbar)"
	else
		mycmakeargs+=( "-DOPTION_TORRENT_SYSTEM=OFF" )
	fi
	if ! use sound ; then
		mycmakeargs+=( "-DOPTION_SOUND=OFF" )
	fi
	if use gstreamer ; then
		mycmakeargs+=( "-DGSTREAMER=ON" )
	fi

	mycmakeargs+=( 
		"-DAUX_VERSION=(Gentoo,$ARCH)"
		"-DCMAKE_INSTALL_PREFIX=/usr/games/"
	)

	cmake-utils_src_configure
}

src_compile () {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install

	prepgamesdirs

	doicon "${D}usr/games/share/icons/hicolor/scalable/apps/springlobby.svg" || die
	rm "${D}/usr/share/games/pixmaps/" -fr || die
	domenu "${D}usr/games/share/applications/springlobby.desktop" || die
	rm "${D}/usr/games/share/applications/" -fr || die
}
