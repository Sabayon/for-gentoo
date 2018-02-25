# Copyright 2004-2018 Sabayon
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Official icon theme from the Numix project"
HOMEPAGE="http://numixproject.org"

BASE_URI="https://github.com/numixproject/${PN}"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="${BASE_URI}.git"
	KEYWORDS=""
else
	SRC_URI="${BASE_URI}/archive/${PV:2:2}-${PV:4:2}-${PV:6:2}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${PV:2:2}-${PV:4:2}-${PV:6:2}"

src_install() {
	insinto /usr/share/icons
	doins -r Numix Numix-Light
	dodoc readme.md
}
