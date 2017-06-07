# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit cmake-utils mercurial flag-o-matic
#inherit cmake-utils flag-o-matic

DESCRIPTION="Library to accelerate the ray intersection process by using GPUs \
(this pkg provides only CPU support atm)"
HOMEPAGE="http://www.luxrender.net"
EHG_REPO_URI="https://bitbucket.org/luxrender/luxrays"
#EHG_REVISION="29e1c03a4ae3"
#SRC_URI="https://bitbucket.org/luxrender/luxrays/get/${EHG_REVISION}.tar.bz2"

#S="${WORKDIR}/luxrender-luxrays-${EHG_REVISION}/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND=">=dev-libs/boost-1.43
	media-libs/freeimage
	virtual/opengl"

CMAKE_IN_SOURCE_BUILD=1

src_configure() {
	append-flags "-fPIC -DLUXRAYS_DISABLE_OPENCL"
	use debug && append-flags -ggdb

	mycmakeargs=( -DLUXRAYS_DISABLE_OPENCL=ON -Wno-dev )
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_make luxrays
}

src_install() {
	dodoc AUTHORS.txt

	insinto /usr/include
	doins -r include/luxrays

	dolib.a lib/libluxrays.a
}
