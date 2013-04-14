# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_DEPEND="2"

inherit python

DESCRIPTION="Python2 bindings for Edje"
HOMEPAGE="http://www.enlightenment.org/"
SRC_URI="http://download.enlightenment.org/releases/BINDINGS/python/${P}.tar.bz2"

LICENSE="LGPL2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=media-libs/edje-1.7.4
	=dev-python/python-evas-${PV}"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-python/cython"

S="${WORKDIR}/${P}"

pkg_setup() {
	python_set_active_version 2
}
