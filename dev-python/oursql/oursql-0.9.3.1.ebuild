# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="a set of MySQL bindings for Python with a focus on wrapping the MYSQL_STMT API"
HOMEPAGE="https://launchpad.net/oursql"
SRC_URI="https://launchpad.net/oursql/trunk/${PV}/+download/${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND=">=virtual/mysql-4.1"
DEPEND="${RDEPEND}"
