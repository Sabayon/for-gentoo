# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
PYTHON_DEPEND="2:2.5"

inherit base distutils python

DESCRIPTION="A graphical translation tool"
HOMEPAGE="http://translate.sourceforge.net/wiki/virtaal/index"
SRC_URI="mirror://sourceforge/translate/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="psyco spell tinytm"

DEPEND="dev-python/translate-toolkit"

RDEPEND="${DEPEND}
	app-text/iso-codes
	|| ( =dev-lang/python-2*[sqlite] >=dev-python/pysqlite-2 )
	dev-python/lxml
	psyco? ( dev-python/psyco )
	tinytm? ( dev-python/psycopg )
	dev-python/pycurl
	spell? ( dev-python/pyenchant dev-python/gtkspell-python )
	dev-python/pygtk
	dev-python/python-levenshtein
	dev-python/simplejson"
