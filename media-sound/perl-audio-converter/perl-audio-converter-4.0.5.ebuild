# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="Perl Audio Converter is a tool for converting multiple audio types from one format to another."
HOMEPAGE="http://pacpl.sourceforge.net"
SRC_URI="mirror://sourceforge/pacpl/pacpl-${PV}.tar.gz"
RESTRICT="mirror"
KEYWORDS="~x86 ~amd64"
SLOT="0"
LICENSE="GPL-3"
IUSE="amarok bladeenc dolphin faac faad flac ffmpeg konqueror lame mac mplayer toolame tta ogg shorten speex wavpack"

DEPEND="dev-lang/perl"

RDEPEND="${DEPEND}
                 amarok? ( media-sound/amarok )
                 dolphin? ( kde-base/dolphin )
                 konqueror? ( kde-base/konqueror )
                 lame? ( media-sound/lame )
                 toolame? ( media-sound/toolame )
                 bladeenc? ( media-sound/bladeenc )
                 ogg? ( media-sound/vorbis-tools )
                 speex? ( media-libs/speex )
                 flac? ( media-libs/flac )
                 mac? ( media-sound/mac )
                 shorten? ( media-sound/shorten )
                 sox? ( media-sound/sox )
                 faac? ( media-libs/faac )
                 faad? ( media-libs/faad2 )
                 ffmpeg? ( media-video/ffmpeg )
                 mplayer? ( media-video/mplayer )
                 tta? ( media-sound/ttaenc )
                 wavpack? ( media-sound/wavpack )
                 dev-perl/Parse-RecDescent
                 dev-perl/Inline
                 dev-perl/Devel-Symdump
                 dev-perl/Pod-Coverage
                 dev-perl/Test-Pod-Coverage
                 dev-perl/MP3-Info
                 dev-perl/Audio-Musepack
                 dev-perl/Audio-WMA
                 dev-perl/Audio-FLAC-Header
                 dev-perl/MP4-Info
                 dev-perl/MP3-Tag
                 dev-perl/ogg-vorbis-header
                 dev-perl/IO-String
                 dev-perl/CDDB_get"
                 
S="${WORKDIR}/pacpl-${PV}"
                 
src_configure() {
        econf \
        --without-d3lphin \
        $(use_with amarok) \
        $(use_with dolphin) \
        $(use_with konqueror konq) \
        || die "configure failed"
}

src_install() {
         emake DESTDIR="${D}" install || die "Install failed"
}
