# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python{3_6,3_7} )
inherit distutils-r1

DESCRIPTION="A Material Design theme for MkDocs"
HOMEPAGE="https://github.com/squidfunk/mkdocs-material"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	>=dev-python/mkdocs-1.0.1[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	>=dev-python/pymdown-extensions-4.11[${PYTHON_USEDEP}]"


