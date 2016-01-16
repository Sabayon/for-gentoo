# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools
MY_AUTHOR="snwh"
DESCRIPTION="the Paper theme official icons."
HOMEPAGE="https://github.com/${MY_AUTHOR}/${PN}"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${MY_AUTHOR}/${PN}.git"
	KEYWORDS=""
else
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${MY_AUTHOR}/${PN}.git"
	EGIT_COMMIT="cd0e7988f6a838698d3f1a8ac48e63dd351e4ba0"
	KEYWORDS="~amd64 ~arm ~x86"
fi

LICENSE="CC-BY-SA-4.0"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install
}
