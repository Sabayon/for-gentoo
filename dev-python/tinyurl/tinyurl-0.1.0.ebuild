# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN=TinyUrl
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Super tiny library and command-line interface to tinyurl.com"
HOMEPAGE="https://pypi.python.org/pypi/TinyUrl"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${MY_P}"
