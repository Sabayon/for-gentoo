# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 )
inherit autotools-utils python-single-r1

RESTRICT="mirror"
DESCRIPTION="IDJC has two media players, jingles player, crossfader, VoIP and streaming"
HOMEPAGE="http://idjc.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE="doc ffmpeg flac mad mpg123 mysql nls opus speex twolame"

RDEPEND="dev-python/eyeD3[${PYTHON_USEDEP}]
	dev-python/pygtk[${PYTHON_USEDEP}]
	media-libs/libsamplerate
	>=media-libs/libshout-idjc-2.3.1[speex?]
	media-libs/libsndfile
	media-libs/libvorbis
	media-libs/mutagen[${PYTHON_USEDEP}]
	>=media-sound/jack-audio-connection-kit-0.116.0
	ffmpeg? ( virtual/ffmpeg )
	flac? ( media-libs/flac )
	mad? ( media-sound/lame )
	mpg123? ( media-sound/mpg123 )
	mysql? ( dev-python/mysql-python[${PYTHON_USEDEP}] )
	nls? ( sys-devel/gettext )
	opus? ( media-libs/opus )
	speex? ( media-libs/speex )
	twolame? ( media-sound/twolame )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	# Make QA happy by removing unsupported and empty keys from the desktop
	# entry file.
	sed -i \
		-e 's/^TerminalOptions=//' \
		-e 's/^Path=//' \
		idjc.desktop.in.in || die "Sed failed!"
}

src_configure() {
	local myeconfargs=(
		$(use_enable ffmpeg libav)
		$(use_enable flac)
		$(use_enable mad lame)
		$(use_enable mpg123)
		$(use_enable nls)
		$(use_enable opus)
		$(use_enable speex)
		$(use_enable twolame)
	)
	autotools-utils_src_configure
}

src_install() {
	use doc && HTML_DOCS=( doc/ )
	autotools-utils_src_install
}

pkg_postinst()
{
	einfo "IDJC needs a working JACK Audio Connection Kit daemon. For details,"
	einfo "refer to http://idjc.sourceforge.net/install_first_run.html"
}
