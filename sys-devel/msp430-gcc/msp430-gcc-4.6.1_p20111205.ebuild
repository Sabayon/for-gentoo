# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

PATCH_VER="1.0"
BRANCH_UPDATE=""

inherit toolchain

DESCRIPTION="The GNU Compiler Collection for MSP430"

LICENSE="GPL-3 LGPL-3 || ( GPL-3 libgcc libstdc++ gcc-runtime-library-exception-3.1 ) FDL-1.2"
KEYWORDS="~amd64 ~x86"

RDEPEND=""
DEPEND="${RDEPEND}
	${CATEGORY}/msp430-binutils"

src_unpack() {
	toolchain_src_unpack
	epatch "${FILESDIR}"/${P}.patch
}
