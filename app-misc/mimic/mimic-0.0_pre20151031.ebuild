# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=(python2_7 python3_4)
BUILD="f2f0441"
inherit distutils-r1

DESCRIPTION="[ab]using Unicode to create tragedy"
HOMEPAGE="https://github.com/reinderien/mimic"
SRC_URI="https://github.com/reinderien/mimic/tarball/${BUILD} -> ${P}.tar.gz"
RESTRICT="mirror"
LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/docutils
	dev-python/setuptools[${PYTHON_USEDEP}]"

DOCS=(README.md)
S="${WORKDIR}/reinderien-${PN}-${BUILD}"
python_compile() {
	distutils-r1_python_compile
}
