# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
inherit eutils

DESCRIPTION="Perl Audio Converter is a tool for converting multiple audio types from one format to another"
HOMEPAGE="http://pacpl.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="amarok dolphin konqueror"

DEPEND="dev-lang/perl"

RDEPEND="${DEPEND}
	amarok? ( media-sound/amarok )
	dolphin? ( kde-base/dolphin )
	konqueror? ( kde-base/konqueror )
	dev-perl/Audio-Musepack
	dev-perl/Audio-WMA
	dev-perl/Audio-FLAC-Header
	dev-perl/MP4-Info
	dev-perl/MP3-Tag
	dev-perl/ogg-vorbis-header
	dev-perl/CDDB_get"

OPT="media-sound/lame
	media-sound/toolame
	media-sound/bladeenc
	media-sound/vorbis-tools
	media-libs/speex
	media-libs/flac
	media-sound/mac
	media-sound/shorten
	media-sound/sox
	media-libs/faac
	media-libs/faad2
	virtual/libav
	media-video/mplayer
	media-sound/ttaenc
	media-sound/wavpack"

src_prepare() {
	sed -i -e 's/\(ac_perl_modules="\)Switch/\1strict/' configure || die
	epatch "${FILESDIR}/45_case-independent-flac-tags.patch"
	epatch "${FILESDIR}/switch-to-given-when.patch"
}

src_configure() {
	econf \
		--without-d3lphin \
		$(use_with amarok) \
		$(use_with dolphin) \
		$(use_with konqueror konq) \
		|| die "configure failed"
}

src_install() {
	emake DESTDIR="${D}" DOC_DIR="${D}usr/share/doc/${PF}" install
}

pkg_postinst() {
	elog "below is the list of additional packages that can be useful:"
	# display it in a nice 3-column rows
	local opts=( ${OPT} )
	local cnt=0
	local row
	local i
	while (( cnt < ${#opts[@]} )); do
		row=""
		for i in {1..3}; do
			row+="${opts[$cnt]} "
			let cnt++
		done
		elog "$(printf "%25s %25s %25s" ${row})"
	done

}
