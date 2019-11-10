# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5,6,7} )

inherit distutils-r1

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ValvePython/vdf.git"
	KEYWORDS=""
else
	KEYWORDS="~amd64"
	EGIT_COMMIT="v${PV}"
	SRC_URI="https://github.com/ValvePython/vdf/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="Package for working with Valve's text and binary KeyValue format"
HOMEPAGE="https://github.com/ValvePython/vdf"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
  dev-python/mock[${PYTHON_USEDEP}]
	dev-python/pytest-cov[${PYTHON_USEDEP}]
"
DEPEND="
  ${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"
