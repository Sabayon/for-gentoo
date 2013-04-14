# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_DEPEND="2"

inherit python eutils

DESCRIPTION="Enlightenment ConnMan user interface"
HOMEPAGE="http://www.enlightenment.org"
SRC_URI="http://packages.profusion.mobi/${PN}/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=dev-python/python-elementary-1.7.0
	>=dev-python/python-e_dbus-1.7.0
	>=dev-python/python-edje-1.7.0
	>=dev-python/python-ecore-1.7.0
	>net-misc/connman-1.3"

DEPEND=">=media-libs/edje-1.7.4
	${RDEPEND}"

S="${WORKDIR}/${P}"

pkg_setup() {
	python_set_active_version 2
}

src_prepare() {
	epatch "${FILESDIR}"/econnman-1-python2.patch
}
