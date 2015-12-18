# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="Raspberry Pi userspace tools and libraries"
HOMEPAGE="https://github.com/raspberrypi/userland"
BUILD="cfa3df1"

SRC_URI="https://github.com/raspberrypi/userland/tarball/${BUILD} -> ${P}.tar.gz"
KEYWORDS="~arm"
RESTRICT="mirror"

LICENSE="BSD"
SLOT="0"

S="${WORKDIR}/raspberrypi-userland-${BUILD}"

pkg_setup() {
	append-ldflags $(no-as-needed)
}

src_prepare() {
	#epatch "${FILESDIR}"/${PN}-9999-gentoo.patch
	epatch "${FILESDIR}"/${PN}-pid.patch
}

src_install() {
	cmake-utils_src_install
	doenvd "${FILESDIR}"/04${PN}

	# enable dynamic switching of the GL implementation
	dodir /usr/lib/opengl
	dosym ../../../opt/vc /usr/lib/opengl/${PN}

	# tell eselect opengl that we do not have libGL
	touch "${ED}"/opt/vc/.gles-only
}
