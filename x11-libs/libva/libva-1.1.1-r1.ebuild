# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

SCM=""
if [ "${PV%9999}" != "${PV}" ] ; then # Live ebuild
	SCM=git-2
	EGIT_BRANCH=master
	EGIT_REPO_URI="git://anongit.freedesktop.org/vaapi/libva"
fi

inherit autotools-multilib ${SCM} multilib

DESCRIPTION="Video Acceleration (VA) API for Linux"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/vaapi"
if [ "${PV%9999}" != "${PV}" ] ; then # Live ebuild
	SRC_URI=""
	S="${WORKDIR}/${PN}"
else
	SRC_URI="http://www.freedesktop.org/software/vaapi/releases/libva/${P}.tar.bz2"
fi

LICENSE="MIT"
SLOT="0"
if [ "${PV%9999}" = "${PV}" ] ; then
	KEYWORDS="~amd64"
else
	KEYWORDS=""
fi
IUSE="+drm egl opengl vdpau wayland X"
REQUIRED_USE="|| ( drm wayland X )"

VIDEO_CARDS="dummy nvidia intel fglrx"
for x in ${VIDEO_CARDS}; do
	IUSE+=" video_cards_${x}"
done

RDEPEND=">=x11-libs/libdrm-2.4[${MULTILIB_USEDEP}]
	X? (
		x11-libs/libX11[${MULTILIB_USEDEP}]
		x11-libs/libXext[${MULTILIB_USEDEP}]
		x11-libs/libXfixes[${MULTILIB_USEDEP}]
	)
	egl? ( media-libs/mesa[egl,${MULTILIB_USEDEP}] )
	opengl? ( virtual/opengl[${MULTILIB_USEDEP}] )
	wayland? ( >=dev-libs/wayland-1[${MULTILIB_USEDEP}] )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"
PDEPEND="video_cards_nvidia? ( x11-libs/libva-vdpau-driver )
	vdpau? ( x11-libs/libva-vdpau-driver )
	video_cards_fglrx? ( x11-libs/xvba-video )
	video_cards_intel? ( >=x11-libs/libva-intel-driver-1.0.18 )
	"

REQUIRED_USE="opengl? ( X )"

AUTOTOOLS_AUTORECONF=yes
AUTOTOOLS_PRUNE_LIBTOOL_FILES=all
DOCS=( NEWS )


multilib_src_configure() {
	autotools-utils_src_configure \
		--disable-silent-rules \
		--with-drivers-path="${EPREFIX}/usr/$(get_libdir)/va/drivers" \
		$(use_enable video_cards_dummy dummy-driver) \
		$(use_enable opengl glx) \
		$(use_enable X x11) \
		$(use_enable wayland) \
		$(use_enable egl) \
		$(use_enable drm)
}

