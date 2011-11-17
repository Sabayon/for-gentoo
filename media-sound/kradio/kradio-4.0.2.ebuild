# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/kradio/kradio-4.0.2.ebuild,v 1.5 2011/10/28 23:34:35 abcd Exp $

EAPI=4

KDE_LINGUAS="cs de es is pl pt pt_BR ru uk"
inherit kde4-base

MY_P=${PN}4-${PV/_/-}

DESCRIPTION="kradio is a radio tuner application for KDE"
HOMEPAGE="http://kradio.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE="alsa debug encode ffmpeg lirc +mp3 +vorbis v4l"

DEPEND="
	media-libs/libsndfile
	alsa? ( media-libs/alsa-lib )
	lirc? ( app-misc/lirc )
	mp3? ( media-sound/lame )
	vorbis? (
		media-libs/libvorbis
		media-libs/libogg
	)
	ffmpeg? (
		>=media-libs/libmms-0.4
		virtual/ffmpeg
	)
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-libav.patch" )

S=${WORKDIR}/${MY_P}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with alsa ALSA)
		$(cmake-utils_use_with mp3 LAME)
		$(cmake-utils_use_with vorbis OGG_VORBIS)
		$(cmake-utils_use_with lirc LIRC)
		$(cmake-utils_use_with ffmpeg FFMPEG)
		$(cmake-utils_use_with v4l V4L2)
		)

	kde4-base_src_configure
}
