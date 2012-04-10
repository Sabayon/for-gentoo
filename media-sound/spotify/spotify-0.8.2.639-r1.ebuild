# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Spotify is a social music platform"
HOMEPAGE="https://www.spotify.com/ch-de/download/previews/"

MY_PV="${PV}.g79d339d.504-1"
MY_P="${PN}-client_${MY_PV}"
SRC_BASE="http://repository.spotify.com/pool/non-free/${PN:0:1}/${PN}/"
#SRC_BASE="http://download.spotify.com/preview/"
SRC_URI="
	x86?   ( ${SRC_BASE}${MY_P}_i386.deb )
	amd64? ( ${SRC_BASE}${MY_P}_amd64.deb )
	"
LICENSE="Spotify"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="pulseaudio"

DEPEND=""
RDEPEND="${DEPEND}
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXfixes
		x11-libs/libXi
		x11-libs/libXrender
		x11-libs/libXScrnSaver
		x11-libs/gdk-pixbuf
		x11-libs/qt-core:4
		x11-libs/qt-gui:4
		x11-libs/qt-webkit:4
		x11-libs/qt-dbus:4
		x11-libs/gtk+:2
		x11-libs/cairo
		x11-libs/pango
		dev-libs/atk
		dev-libs/libgcrypt
		dev-libs/glib:2
		dev-libs/nspr
		dev-libs/nss
		dev-libs/openssl
		gnome-base/gconf:2
		media-libs/alsa-lib
		media-libs/freetype
		media-libs/fontconfig
		media-libs/libpng:1.2
		net-print/cups
		sys-apps/dbus
		sys-libs/zlib
		pulseaudio? ( >=media-sound/pulseaudio-0.9.21 )"

RESTRICT="mirror strip"

src_unpack() {
	mkdir "${P}"
	cd "${P}"
	unpack ${A}
	unpack ./data.tar.gz
}

src_prepare() {
	# link against openssl-1.0.0 as it crashes with 0.9.8
	sed -i \
		-e 's/\(lib\(ssl\|crypto\).so\).0.9.8/\1.1.0.0/g' \
		usr/share/spotify/spotify || die "sed failed"
	# different NSPR / NSS library names for some reason
	sed -i \
		-e 's/\(lib\(nss3\|nssutil3\|smime3\).so\).1d/\1.12/g' \
		-e 's/\(lib\(plc4\|nspr4\).so\).0d\(.\)/\1.9\3\3/g' \
		usr/share/spotify/libcef.so || die "sed failed"
}

src_install() {
	dodoc usr/share/doc/spotify-client/changelog.Debian.gz
	dodoc usr/share/doc/spotify-client/copyright
	insinto /usr/share/applications
	doins usr/share/applications/*.desktop
	insinto /usr/share/pixmaps
	doins usr/share/pixmaps/*.png

	# install in /opt/spotify
	SPOTIFY_HOME=/opt/spotify
	dodir ${SPOTIFY_HOME}
	insinto ${SPOTIFY_HOME}
	doins -r usr/share/spotify/*
	fperms +x ${SPOTIFY_HOME}/spotify
	dodir /usr/bin
	dosym ../share/spotify/spotify /usr/bin/spotify
	dodir /usr/share
	dosym ${SPOTIFY_HOME} /usr/share/spotify

	# revdep-rebuild produces a false positive because of symbol versioning
	dodir /etc/revdep-rebuild
	cat <<-EOF >"${D}"/etc/revdep-rebuild/10${PN}
		SEARCH_DIRS_MASK="${SPOTIFY_HOME}"
	EOF
}

pkg_postinst() {
	ewarn "If Spotify crashes after an upgrade its cache may be corrupt."
	ewarn "To remove the cache:"
	ewarn "rm -rf ~/.cache/spotify"
}
