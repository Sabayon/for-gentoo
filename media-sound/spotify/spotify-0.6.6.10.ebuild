# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Spotify is a social music platform"
HOMEPAGE="https://www.spotify.com/ch-de/download/previews/"

MY_PV="${PV}.gbd39032.58-1"
MY_P="${PN}-client-qt_${MY_PV}"
SRC_BASE="http://repository.spotify.com/pool/non-free/${PN:0:1}/${PN}/"
SRC_URI="
	x86?   ( ${SRC_BASE}${MY_P}_i386.deb )
	amd64? ( ${SRC_BASE}${MY_P}_amd64.deb )
	"
LICENSE="Spotify"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="sys-devel/binutils
		app-arch/tar
		dev-util/bsdiff"
RDEPEND="${DEPEND}
		x11-libs/libX11
		x11-libs/libSM
		x11-libs/libICE
		x11-libs/libXrender
		x11-libs/libXrandr
		x11-libs/libXinerama
		x11-libs/libXext
		x11-libs/libxcb
		x11-libs/libXau
		x11-libs/libXdmcp
		x11-libs/qt-core:4
		x11-libs/qt-gui:4
		x11-libs/qt-webkit:4
		x11-libs/qt-dbus:4
		x11-libs/libXScrnSaver
		media-libs/freetype
		media-libs/fontconfig
		media-libs/alsa-lib
		media-libs/phonon
		dev-libs/openssl
		dev-libs/glib:2
		>media-libs/libpng-1.5
		dev-db/sqlite:3
		sys-libs/zlib
		app-arch/bzip2
		sys-apps/dbus
		sys-apps/util-linux
		dev-libs/expat"

RESTRICT="mirror strip"

src_unpack() {
	ar x "${DISTDIR}/${A}" 
	mkdir "${P}"
	cd "${P}"
	tar xzf ../data.tar.gz
	# Binary patch removes the version information for OPENSSL_0.9.8
	# from the ELF .gnu_version* sections. They are relics from
	# a build on Debian and Gentoo has no version info in openssl.
	# This fixes a false positive in revdep-rebuild due to ldd
	# errors.
	# See http://www.odi.ch/weblog/posting.php?posting=645
	# for how to create the binary patch.
	if use amd64 ; then
		BPATCH=${P}-openssl-ver-amd64.bpatch
	else
		BPATCH=${P}-openssl-ver-x86.bpatch
	fi
	bspatch usr/bin/spotify spotify ${FILESDIR}/${BPATCH} || die "could not
	patch"

	# link against openssl-1.0.0 as it crashes with 0.9.8
	sed -i -e 's/\(lib\(ssl\|crypto\).so\).0.9.8/\1.1.0.0/g' spotify
}

src_install() {
	# install the PATCHED binary
	dobin spotify
	dodoc usr/share/doc/spotify-client-qt/changelog.Debian.gz
	dodoc usr/share/doc/spotify-client-qt/copyright
	insinto /usr/share/applications
	doins usr/share/applications/*.desktop
	insinto /usr/share/pixmaps
	doins usr/share/pixmaps/*.png
	dodir /usr/share/spotify
	insinto /usr/share/spotify
	doins -r usr/share/spotify/*
}
