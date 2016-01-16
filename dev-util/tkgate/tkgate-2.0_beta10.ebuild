# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: $
EAPI="5"

inherit eutils


MY_PV="${PV/_beta/-b}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="A Tcl/Tk based digital circuit editor and simulator"
HOMEPAGE="http://www.tkgate.org"
SRC_URI="http://www.tkgate.org/downloads/${MY_P}.tgz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"

IUSE=""

DEPEND="=dev-lang/tcl-8*
	=dev-lang/tk-8*"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}/tkgate-install-symlink.patch" || die
}

src_install() {
	make DESTDIR="${D}" install
}
