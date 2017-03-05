# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit python-single-r1 python-utils-r1 autotools


DESCRIPTION="A library for manipulating block devices."
HOMEPAGE="https://github.com/rhinstaller/libblockdev"
SRC_URI="https://github.com/rhinstaller/${PN}/archive/${P}-1.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${P}-1"
KEYWORDS="~amd64"

LICENSE="LGPL-2.1+"
SLOT="1"
IUSE="+introspection"

COMMON_DEPEND="dev-libs/glib:2
	dev-libs/nss
	>=dev-libs/volume_key-0.3.9
	sys-fs/cryptsetup
	sys-fs/lvm2
	sys-fs/dmraid
	virtual/libudev"
DEPEND="${COMMON_DEPEND}
	introspection? ( dev-libs/gobject-introspection )
	dev-util/scons"

RDEPEND="${COMMON_DEPEND}
	virtual/libudev"

src_compile() {
	LDFLAGS="" emake || die
}

src_install() {
	emake PREFIX="${D}" SITEDIRS="${D}$(python_get_sitedir)" install || die
}
