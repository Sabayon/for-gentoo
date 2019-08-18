# Copyright 2004-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

DESCRIPTION="a python library that is used for reading and writing kickstart files."
HOMEPAGE="http://fedoraproject.org/wiki/Pykickstart"
SRC_URI="https://github.com/rhinstaller/${PN}/archive/r${PV}-1.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"

DEPEND="app-i18n/transifex-client
	sys-devel/gettext"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-r${PV}-1"
