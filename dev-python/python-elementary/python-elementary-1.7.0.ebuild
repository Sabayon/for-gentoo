# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_DEPEND="2"

inherit python

DESCRIPTION="bindings for Elementary"
HOMEPAGE="http://www.enlightenment.org/"
SRC_URI="http://download.enlightenment.org/releases/BINDINGS/python/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=media-libs/elementary-1.7.5
	>=dev-python/python-evas-${PV}"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-python/cython"

S="${WORKDIR}/${P}"

pkg_setup() {
	python_set_active_version 2
}
