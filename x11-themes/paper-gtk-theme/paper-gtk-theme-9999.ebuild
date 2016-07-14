# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_AUTHOR="snwh"
inherit autotools
DESCRIPTION="the Paper gtk theme by snwh"
HOMEPAGE="https://github.com/${MY_AUTHOR}/${PN}"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/${MY_AUTHOR}/${PN}.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/${MY_AUTHOR}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"

DEPEND="x11-themes/gtk-engines
	x11-libs/gdk-pixbuf"
RDEPEND="${DEPEND}"

src_prepare() {
	eautoreconf
}

src_install() {
	insinto /usr/share/themes/
	doins -r Paper
	dodoc README.md
}
