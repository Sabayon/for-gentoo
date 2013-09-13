# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

EAPI="4"
PYTHON_DEPEND="2:2.5"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit eutils distutils fdo-mime

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

src_prepare() {
	epatch "${WORKDIR}/${PN}-fix-PIL-imports.patch"
	distutils_src_prepare
}

src_install() {
	distutils_src_install
	# Hack...
	mv "${ED}"usr/share/locale/locale/* "${ED}"usr/share/locale || die
	rmdir "${ED}"usr/share/locale/locale || die
}

pkg_postinst() {
	distutils_pkg_postinst
	fdo-mime_mime_database_update
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	distutils_pkg_postrm
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
