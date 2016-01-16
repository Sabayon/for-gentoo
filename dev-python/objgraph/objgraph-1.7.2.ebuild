# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/icalendar/icalendar-2.2.ebuild,v 1.5 2012/03/09 10:32:19 phajdan.jr Exp $

EAPI="5"
SUPPORT_PYTHON_ABIS="1"
PYTHON_DEPEND="2"

inherit distutils

DESCRIPTION="Draws Python object reference graphs with graphviz"
HOMEPAGE="http://mg.pov.lt/objgraph/"
SRC_URI="https://pypi.python.org/packages/source/o/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-fbsd"
IUSE=""
RESTRICT="test"

RDEPEND=""
DEPEND="dev-python/setuptools"

RESTRICT_PYTHON_ABIS="3.*"
