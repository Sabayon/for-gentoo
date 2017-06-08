# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_6 python2_7 )
inherit eutils fdo-mime distutils-r1

DESCRIPTION="Openbox Key Editor"
HOMEPAGE="http://code.google.com/p/obkey/"
SRC_URI="https://github.com/nsf/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-python/pygobject:2
	dev-python/pygtk:2
	x11-wm/openbox
"

python_prepare_all() {
	local PATCHES=( "${FILESDIR}"/${P}-nextwindow-fix.patch )
	# Not everyone has x11-misc/obconf with its icon.
	sed -i -e s/Icon=obconf/Icon=openbox/ misc/${PN}.desktop || die
	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all
	domenu misc/${PN}.desktop || die
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
