# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit distutils eutils

MY_PN="${PN/python-}"
DESCRIPTION="A Python library for querying NTP servers"
HOMEPAGE="https://pypi.python.org/pypi/ntplib"
SRC_URI="https://pypi.python.org/packages/source/n/${MY_PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="LGPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/${MY_PN}-${PV}"

PYTHON_MODNAME="ntplib"
