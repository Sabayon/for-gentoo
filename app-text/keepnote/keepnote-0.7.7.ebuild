# Copyright 2010-2012 Sabayon
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
PYTHON_DEPEND="2"
PYTHON_USE_WITH="sqlite xml"

inherit distutils

DESCRIPTION="A note taking application"
HOMEPAGE="http://keepnote.org/"
SRC_URI="http://keepnote.org/download/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="spell"

DEPEND=">=dev-python/pygtk-2.12.0
	dev-python/pygobject
	dev-python/pygtksourceview
	spell? ( >=app-text/gtkspell-2.0.11-r1 )"

RDEPEND="${DEPEND}"

DOCS="CHANGES README"

src_prepare() {
	rm ${PN}/BeautifulSoup.py || die
	distutils_src_prepare
}

pkg_postinst() {
	distutils_pkg_postinst
	echo
	einfo "if you may happen to run ${PN} 0.7.4:"
	ewarn "Don't run the older 0.7.4 ${PN} if you have notebooks created with"
	ewarn "any more recent version of ${PN} (like this one) without having a backup of them."
	ewarn "0.7.4 has an issue regarding new notebook formats, described on the \"Updates\" section on the homepage."
}
