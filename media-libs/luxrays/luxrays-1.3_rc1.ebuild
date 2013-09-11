# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit cmake-utils flag-o-matic

DESCRIPTION="Library to accelerate the ray intersection process by using GPUs."
HOMEPAGE="http://www.luxrender.net"
EHG_REVISION="639b2ad09f77"
SRC_URI="http://distfiles.sabayon.org/${CATEGORY}/${PF}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND=">=dev-libs/boost-1.43
	media-libs/freeimage
	virtual/opencl
	virtual/opengl"

src_unpack() {
	unpack ${A}
	mv "${WORKDIR}/luxrender-luxrays-${EHG_REVISION}" "${WORKDIR}/${P}"
}

src_configure() {
	append-flags "-fPIC"
	use debug && append-flags -ggdb

	mycmakeargs=( -Wno-dev )
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_make luxrays
}

src_install() {
	dodoc ${S}/AUTHORS.txt

	insinto /usr/include
	doins -r ${S}/include/luxrays

	dolib.a ${BUILD_DIR}/lib/libluxrays.a
}
