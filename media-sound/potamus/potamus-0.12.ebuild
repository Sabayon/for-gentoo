# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils gnome2

DESCRIPTION="a lightweight audio player with a simple interface and an emphasis on high audio quality."
HOMEPAGE="http://offog.org/code/potamus.html"
SRC_URI="http://offog.org/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2
	>=gnome-base/libglade-2
	media-libs/libao
	media-libs/libsamplerate
	media-libs/libvorbis
	media-libs/libmad
	media-libs/audiofile
	media-libs/libmodplug
	virtual/ffmpeg
	media-libs/flac
	media-sound/jack-audio-connection-kit"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}/${P}-libav.patch"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc NEWS README TODO
}
