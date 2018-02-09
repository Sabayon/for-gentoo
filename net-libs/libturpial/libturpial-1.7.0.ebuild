# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: $

EAPI=5

MY_AUTHOR="satanas"
PYTHON_COMPAT=( python{2_6,2_7} )

inherit distutils-r1

DESCRIPTION="A powerful microblogging library written in Python"
HOMEPAGE="http://turpial.org.ve/"
if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/${MY_AUTHOR}/${PN}.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/${MY_AUTHOR}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
fi

SLOT="0"
LICENSE="GPL-3"
IUSE=""

RDEPEND="
	dev-python/oauth[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/simplejson[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}/docs.patch"
	epatch "${FILESDIR}/${PV}-test.patch"
}

python_test() {
	nosetest || die
}

src_install() {
	distutils-r1_src_install
	dodoc ChangeLog AUTHORS
}
