# Copyright 1999-2012 Sabayon
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils versionator

DESCRIPTION="Sabayon (Gentoo compatible) Locale configuration tool"
HOMEPAGE="http://www.sabayon.org/"
SRC_URI=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ppc ppc64 sparc x86"
IUSE=""

RDEPEND="sys-apps/sed
	sys-apps/baselayout"

DEPEND="${RDEPEND}"
S="${WORKDIR}"

src_unpack () {
	cd "${S}"
        cp "${FILESDIR}"/${PV}/* . -p
}

src_install () {
	exeinto /sbin/
	doexe language-setup
}
