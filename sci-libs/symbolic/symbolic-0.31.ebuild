# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit autotools eutils

DESCRIPTION="a library for manipulating mathematical expressions"
HOMEPAGE="http://functy.sourceforge.net/"
SRC_URI="mirror://sourceforge/functy/Symbolic/${P}-src.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	eautoreconf
}

src_install() {
	DESTDIR="${D}" emake install
}
