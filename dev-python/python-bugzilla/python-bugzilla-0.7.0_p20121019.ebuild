# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
PYTHON_DEPEND="2"
inherit distutils eutils

MY_P=${P%_*}
DESCRIPTION="A Python library for Bugzilla"
HOMEPAGE="https://fedorahosted.org/python-bugzilla/"
SRC_URI="https://fedorahosted.org/releases/p/y/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}/${MY_P}

PYTHON_MODNAME="bugzilla"

src_prepare() {
	epatch "${FILESDIR}"/${MY_P}-82c2c.patch
	distutils_src_prepare
}

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

pkg_postinst() {
	distutils_pkg_postinst
	elog "Automatic detection of file type of attachments"
	elog "requires sys-apps/file compiled with USE=python."
}
