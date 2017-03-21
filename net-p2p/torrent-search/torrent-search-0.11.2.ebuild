# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A torrent searching application"
HOMEPAGE="http://torrent-search.sourceforge.net/"
SRC_URI="mirror://sourceforge/torrent-search/${PN}_${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"

DEPEND=""
RDEPEND=">=dev-python/httplib2-0.6.0
	dev-python/pygtk:2
	>=dev-python/dbus-python-0.83
	>=dev-libs/libxml2-2.7.6[python]"
S="${WORKDIR}/${PN}"

src_install() {
	distutils-r1_src_install
}
