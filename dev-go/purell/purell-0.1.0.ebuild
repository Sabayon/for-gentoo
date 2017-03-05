# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
EGO_PN=github.com/PuerkitoBio/${PN}

if [[ ${PV} = *9999* ]]; then
	inherit golang-vcs
else
	KEYWORDS="~amd64 ~arm"
	SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	inherit golang-vcs-snapshot
fi
inherit golang-build

DESCRIPTION="tiny Go library to normalize URLs"
HOMEPAGE="https://github.com/PuerkitoBio/purell"
LICENSE="BSD"
SLOT="0"
IUSE=""
DEPEND=""
RDEPEND=""
