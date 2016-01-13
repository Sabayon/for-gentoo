# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

MY_AUTHOR="satanas"
PYTHON_COMPAT=( python{2_6,2_7} )

inherit distutils-r1

MY_PN="Turpial"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A light, beautiful and functional microblogging client"
HOMEPAGE="http://turpial.org.ve/"
if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/${MY_AUTHOR}/${PN}.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/${MY_AUTHOR}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
	S="${WORKDIR}/${MY_P}"
fi

SLOT="0"
LICENSE="GPL-3"
IUSE="qt4"

RDEPEND="
	>=net-libs/lib${PN}-0.8[${PYTHON_USEDEP}]
	net-libs/webkit-gtk:3[introspection]
	>=dev-python/pyinotify-0.1.1[${PYTHON_USEDEP}]
	dev-python/gst-python:0.10[${PYTHON_USEDEP}]
	>=dev-python/Babel-0.9.1[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/pygtk-2.12[${PYTHON_USEDEP}]
	>=dev-python/gtkspell-python-2.25.3[${PYTHON_USEDEP}]
	qt4? ( >=dev-python/PyQt4-2.12[${PYTHON_USEDEP},webkit]  )
"
DEPEND="${RDEPEND}"
