# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

PYTHON_DEPEND="2"

inherit distutils

DESCRIPTION="Python bindings for libsmbclient"
HOMEPAGE="https://fedorahosted.org/pysmbc"
SRC_URI="http://cyberelk.net/tim/data/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

pkg_setup() {
	python_set_active_version 2
}