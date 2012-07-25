# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
PYTHON_DEPEND="2:2.5"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"
inherit distutils eutils

DESCRIPTION="Graphical interface for Taskwarrior"
HOMEPAGE="http://taskwarrior.org/projects/taskwarrior/wiki/Taskhelm"
SRC_URI="http://www.bryceharrington.org/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/pygobject:2
	dev-python/pygtk:2
	dev-python/jsonpickle
"
RDEPEND="${DEPEND}
	>=app-misc/task-1.9.4
"

src_prepare() {
	sed -i -e 's/Version=0\.1/Version=1.0/' data/taskhelm.desktop || die
}

pkg_postinst() {
	ewarn "This is a development version for next release."
}
