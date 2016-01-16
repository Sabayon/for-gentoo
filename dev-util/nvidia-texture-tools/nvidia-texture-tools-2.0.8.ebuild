# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit cmake-utils eutils

DESCRIPTION="a set of cuda-enabled texture tools and compressors"
HOMEPAGE="http://developer.nvidia.com/object/texture_tools.html"
SRC_URI="http://nvidia-texture-tools.googlecode.com/files/${P}-1.tar.gz"
LICENSE="MIT"

SLOT="0"

KEYWORDS="~amd64 ~x86"

IUSE="debug"

DEPEND="x11-libs/libX11
	virtual/jpeg
	media-libs/libpng
	media-libs/tiff"
#	optional:
#	media-libs/glew
#	media-gfx/nvidia-cg-toolkit
#	dev-util/nvidia-cuda-toolkit
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_configure() {
	mycmakeargs=(
		"--prefix=/usr"
		)

	if use debug; then
		mycmakeargs+=(
			"--debug"
			)
	else
		mycmakeargs+=(
			"--release"
			)
	fi

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_make
}

src_install() {
	cmake-utils_src_install
}
