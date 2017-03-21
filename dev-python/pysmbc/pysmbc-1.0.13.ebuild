# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python bindings for libsmbclient"
HOMEPAGE="https://fedorahosted.org/pysmbc"
SRC_URI="http://cyberelk.net/tim/data/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=net-fs/samba-4.2.14"

src_prepare() {
	eapply "${FILESDIR}/${PN}-libsmbclient-fix.patch"
	eapply_user
}
