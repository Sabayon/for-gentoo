# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

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
    	SRC_URI="https://github.com/${MY_AUTHOR}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
        KEYWORDS="~amd64 ~x86"
fi

LICENSE="CC-BY-SA-4.0"
SLOT="0"

DEPEND="app-misc/fdupes
	x11-themes/hicolor-icon-theme
	>=x11-misc/icon-naming-utils-0.8.7"
RDEPEND=""

src_prepare() {
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install
}
