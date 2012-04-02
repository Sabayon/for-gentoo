# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
PYTHON_DEPEND="2"
inherit eutils gnome2-utils fdo-mime python

DESCRIPTION="Rigo, the Sabayon Application Browser"
HOMEPAGE="http://www.sabayon.org"
LICENSE="GPL-3"

SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

SRC_URI="mirror://sabayon/sys-apps/entropy-${PV}.tar.bz2"
S="${WORKDIR}/entropy-${PV}/rigo"

RDEPEND="
	~sys-apps/entropy-${PV}
	~sys-apps/rigo-daemon-${PV}
	x11-libs/gtk+:3
	x11-libs/vte:2.90
	sys-devel/gettext"
DEPEND=""

src_compile() {
	emake || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
}

pkg_postinst() {
	python_mod_optimize "/usr/lib/rigo/${PN}"
}

pkg_postrm() {
	python_mod_cleanup "/usr/lib/rigo/${PN}"
}
