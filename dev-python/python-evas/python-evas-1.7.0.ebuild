# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_DEPEND="2"

inherit python

DESCRIPTION="Python bindings for Evas"
HOMEPAGE="http://www.enlightenment.org/"
SRC_URI="http://download.enlightenment.org/releases/BINDINGS/python/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=media-libs/evas-1.7.6[eet]
	>=dev-libs/eina-1.7.4"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-python/cython"

S="${WORKDIR}/${P}"

pkg_setup() {
	python_set_active_version 2
}
