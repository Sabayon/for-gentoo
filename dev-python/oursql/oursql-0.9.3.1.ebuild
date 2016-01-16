# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
PYTHON_DEPEND="2"

inherit distutils python

DESCRIPTION="oursql is a set of MySQL bindings for Python with a focus on wrapping the MYSQL_STMT API"
HOMEPAGE="https://launchpad.net/oursql"
SRC_URI="https://launchpad.net/oursql/trunk/${PV}/+download/${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND=">=virtual/mysql-4.1"
DEPEND="${RDEPEND}"
