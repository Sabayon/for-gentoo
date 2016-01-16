# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs

DESCRIPTION="A flexible, cross-platform scripting library"
HOMEPAGE="http://www.angelcode.com/${PN}/"
SRC_URI="http://www.angelcode.com/${PN}/sdk/files/${PN}_${PV}.zip"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/sdk/${PN}/projects/gnuc"

src_compile() {
	emake CXX="$(tc-getCXX)" CXXFLAGS="${CXXFLAGS}" || die
}

src_install() {
	dodir /usr/lib /usr/include
	emake LOCAL="${D}/usr" install || die

	if use doc; then
		dohtml -r ../../../docs || die
	fi
}
