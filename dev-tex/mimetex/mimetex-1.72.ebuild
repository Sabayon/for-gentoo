# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
WEBAPP_MANUAL_SLOT="yes"
inherit toolchain-funcs webapp

DESCRIPTION="Lets you easily embed LaTeX math in your HTML and dynamic web pages"
HOMEPAGE="http://www.forkosh.com/mimetex.html"
# mirrored because the zip file doesn't contain version number
SRC_URI="mirror://sabayon/${CATEGORY}/${PN}/${P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="app-arch/unzip"
RDEPEND=""

S="${WORKDIR}"

src_compile() {
	$(tc-getCC) ${CFLAGS} -DAA -o ${PN}.cgi ${PN}.c gifsave.c -lm \
		|| die "compilation failed"
}

src_install() {
	use doc && dodoc ${PN}.html
	dodoc README
	exeinto "${MY_CGIBINDIR}"
	doexe ${PN}.cgi
	webapp_src_install
}
