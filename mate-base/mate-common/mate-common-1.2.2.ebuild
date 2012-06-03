# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

EAPI=4

inherit autotools base mate-desktop.org

DESCRIPTION="Common files for development of MATE packages"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-3"
SLOT="3"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

src_prepare() {
	eautoreconf
}

src_install() {
	base_src_install
	mv doc-build/README README.doc-build || die "renaming doc-build/README failed"
	dodoc ChangeLog README* doc/usage.txt || die "dodoc failed"
}
