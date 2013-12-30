# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit autotools-multilib eutils flag-o-matic multilib

DESCRIPTION="ALSA extra plugins"
HOMEPAGE="http://www.alsa-project.org/"
SRC_URI="mirror://alsaproject/plugins/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug ffmpeg jack libsamplerate pulseaudio speex"

RDEPEND=">=media-libs/alsa-lib-${PV}[${MULTILIB_USEDEP}]
	ffmpeg? ( virtual/ffmpeg[${MULTILIB_USEDEP}] )
	jack? ( >=media-sound/jack-audio-connection-kit-0.98[${MULTILIB_USEDEP}] )
	libsamplerate? ( media-libs/libsamplerate[${MULTILIB_USEDEP}] )
	pulseaudio? ( media-sound/pulseaudio[${MULTILIB_USEDEP}] )
	speex? ( media-libs/speex[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-1.0.19-missing-avutil.patch \
		"${FILESDIR}"/${PN}-1.0.23-automagic.patch \
		"${FILESDIR}"/${PN}-1.0.27-ffmpeg-version-check.patch

	# For some reasons the polyp/pulse plugin does fail with alsaplayer with a
	# failed assert. As the code works just fine with asserts disabled, for now
	# disable them waiting for a better solution.
	sed -i \
		-e '/AM_CFLAGS/s:-Wall:-DNDEBUG -Wall:' \
		pulse/Makefile.am || die

	AUTOTOOLS_AUTORECONF=yes # avoid OOT-build maintainer mode trouble
	autotools-multilib_src_prepare
}

src_configure() {
	use debug || append-cppflags -DNDEBUG

	local myspeex=no
	use speex && myspeex=lib

	autotools-multilib_src_configure \
		$(use_enable ffmpeg avcodec) \
		$(use_enable jack) \
		$(use_enable libsamplerate samplerate) \
		$(use_enable pulseaudio) \
		--with-speex=${myspeex}
}

src_install() {
	AUTOTOOLS_PRUNE_LIBTOOL_FILES=all
	autotools-multilib_src_install

	cd doc
	dodoc upmix.txt vdownmix.txt README-pcm-oss
	use jack && dodoc README-jack
	use libsamplerate && dodoc samplerate.txt
	use ffmpeg && dodoc lavcrate.txt a52.txt

	if use pulseaudio; then
		dodoc README-pulse
		# install ALSA configuration files
		# making PA to be used by alsa clients
		insinto /usr/share/alsa
		doins "${FILESDIR}"/pulse-default.conf
		insinto /usr/share/alsa/alsa.conf.d
		doins "${FILESDIR}"/51-pulseaudio-probe.conf
		# bug #410261, comment 5+
		# seems to work fine without any path
		sed -i \
			-e "s:/usr/lib/alsa-lib/::" \
			"${ED}"/usr/share/alsa/alsa.conf.d/51-pulseaudio-probe.conf || die #410261
	fi
}

pkg_postinst() {
	if use pulseaudio; then
		einfo "The PulseAudio device is now set as the default device if the"
		einfo "PulseAudio server is found to be running. Any custom"
		einfo "configuration in /etc/asound.conf or ~/.asoundrc for this"
		einfo "purpose should now be unnecessary."
	fi
}
