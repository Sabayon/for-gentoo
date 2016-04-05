# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
	EGIT_COMMIT="ae82c98cc8c4248d940fdd27870f146c70cdf228"
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
