# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/freerdp/freerdp-1.0_beta4.ebuild,v 1.1 2011/12/24 01:06:35 floppym Exp $

EAPI="4"

inherit cmake-utils

DESCRIPTION="Client-side implementation of the Remote Desktop Protocol"
HOMEPAGE="http://www.freerdp.com/"
SRC_URI="https://github.com/downloads/FreeRDP/FreeRDP/FreeRDP-${PV/_/-}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa cups directfb doc ffmpeg pulseaudio smartcard sse2 test X xinerama xv"

FREERDP_DEBUG="transport chanman svc dvc kbd nla nego certificate license gdi
	rfx x11 rail xv scard orders redir"
IUSE+=" $(printf 'debug-%s ' ${FREERDP_DEBUG})"

RDEPEND="
	dev-libs/openssl
	sys-libs/zlib
	alsa? ( media-libs/alsa-lib )
	cups? ( net-print/cups )
	directfb? ( dev-libs/DirectFB )
	ffmpeg? ( virtual/ffmpeg )
	pulseaudio? ( media-sound/pulseaudio )
	smartcard? ( sys-apps/pcsc-lite )
	X? (
		x11-libs/libX11
		x11-libs/libXcursor
		x11-libs/libXext
		x11-libs/libxkbfile
		xinerama? ( x11-libs/libXinerama )
		xv? ( x11-libs/libXv )
	)
"
DEPEND="${RDEPEND}
	doc? (
		X? (
			app-text/docbook-xml-dtd:4.1.2
			app-text/xmlto
		)
	)
	test? ( dev-util/cunit )
"

DOCS=( README )

# Test suite segfaults
RESTRICT="test"

src_unpack() {
	unpack ${A}
	mv FreeRDP-* "${S}" || die
}

CMAKE_VERBOSE=1

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with alsa ALSA)
		$(cmake-utils_use_with cups CUPS)
		$(cmake-utils_use_with doc MANPAGES)
		$(cmake-utils_use_with directfb DIRECTFB)
		$(cmake-utils_use_with ffmpeg FFMPEG)
		$(cmake-utils_use_with pulseaudio PULSEAUDIO)
		$(cmake-utils_use_with smartcard PCSC)
		$(cmake-utils_use_with sse2 SSE2)
		$(cmake-utils_use_with test CUNIT)
		$(cmake-utils_use_with X X11)
		$(cmake-utils_use_with X XCURSOR)
		$(cmake-utils_use_with X XEXT)
		$(cmake-utils_use_with X XKBFILE)
		$(cmake-utils_use_with xinerama XINERAMA)
		$(cmake-utils_use_with xv XV)
	)
	for i in ${FREERDP_DEBUG}; do
		mycmakeargs+=(
			$(cmake-utils_use_with debug-${i} DEBUG_$(LC_ALL=C echo ${i} | tr a-z A-Z))
		)
	done
	cmake-utils_src_configure
}
