# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 fdo-mime

DESCRIPTION="Simple to use cross-platform GUI Photo Batch Processor"
HOMEPAGE="http://photobatch.stani.be/"

SRC_URI="mirror://sabayon/${CATEGORY}/${PN}/${P}.tar.xz
	mirror://sabayon/${CATEGORY}/${PN}/${PN}-fix-PIL-imports.patch.gz"

# last tarball released by upstream was versioned 0.2.7.1
# but the .1 isn't mentioned in their VCS log or sources
# so I get it as -r1 equivalent

# thus, 0.2.7, VCS revision 1943 isn't meant to be older than that

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND="dev-python/wxpython:2.8
	virtual/python-imaging
"
DEPEND="${CDEPEND}
	app-arch/xz-utils
"
RDEPEND="${CDEPEND}
	sys-apps/mlocate
"

PATCHES=( "${WORKDIR}/${PN}-fix-PIL-imports.patch" )

python_install_all() {
	distutils-r1_python_install_all
	# Hack...
	mv "${ED}"usr/share/locale/locale/* "${ED}"usr/share/locale || die
	rmdir "${ED}"usr/share/locale/locale || die
}

pkg_postinst() {
	fdo-mime_mime_database_update
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
