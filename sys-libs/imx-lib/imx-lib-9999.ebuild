# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

EGIT_REPO_URI="git://github.com/genesi/imx-lib.git"
inherit toolchain-funcs git-2

DESCRIPTION="IMX{31,51} System library"
HOMEPAGE="https://github.com/genesi/imx-lib"
SRC_URI=""

LICENSE="Freescale GPL-2"
SLOT="0"
KEYWORDS="~arm"
IUSE=""

DEPEND=""
RDEPEND=""

src_compile() {
	# XXX: This expects to find efikamx-sources at /usr/src/linux
	emake -j1 CC=$(tc-getCC) CXX=$(tc-getCXX) \
		INCLUDE="-I${ROOT}/usr/src/linux/include \
				 -I${ROOT}/usr/src/linux/drivers/mxc/security/rng/include \
				 -I${ROOT}/usr/src/linux/drivers/mxc/security/sahara2/include" \
		LIB_VERSION_MAJOR=2 LIB_VERSION_MINOR=0 \
		PLATFORM="IMX51" all || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" PLATFORM=IMX51 LIB_VERSION_MAJOR=2 \
		LIB_VERSION_MINOR=0 install || die "emake install failed"
}
