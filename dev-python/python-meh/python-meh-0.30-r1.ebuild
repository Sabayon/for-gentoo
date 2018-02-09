# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils

DESCRIPTION="Python exception handling library"
HOMEPAGE="https://github.com/rhinstaller/python-meh"
SRC_URI="https://github.com/rhinstaller/${PN}/archive/r${PV}-1.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk"

COMMON_DEPEND="
	dev-python/dbus-python
	sys-devel/gettext
	"
DEPEND="${COMMON_DEPEND}
	dev-util/intltool
"

RDEPEND="${COMMON_DEPEND}
	dev-libs/newt
	gtk? (
		x11-libs/gtk+:3
		dev-python/pygobject:3
	)
	>=dev-libs/libreport-2.0.18
	net-misc/openssh"

S="${WORKDIR}/${PN}-r${PV}-1"

src_prepare() {
	epatch "${FILESDIR}/${PN}-keep_exc_win_above.patch"
	distutils-r1_src_prepare
}
