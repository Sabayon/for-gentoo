# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Dynamic menu generator for Openbox"
HOMEPAGE="http://mimasgpc.free.fr/openbox-menu_en.html"
SRC_URI="http://mimarchlinux.googlecode.com/files/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/glib:2
	lxde-base/menu-cache
	x11-libs/gtk+:2
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	sed -i -e '/^CFLAGS/s/ -g//' Makefile || die
}

src_install() {
	dodoc AUTHORS ChangeLog
	dobin ${PN}
}

pkg_postinst() {
	einfo "Information how to configure ${PN} can be found"
	einfo "at ${HOMEPAGE}"
	elog "If generated menu is empty you may need to install a package"
	elog "like lxde-base/lxmenu-data (it provides menu definition structure)."
	if has 0.3.6.6 ${REPLACING_VERSIONS}; then
		echo
		ewarn "In ${PN}-0.3.6.7 --noicons option is gone."
		ewarn "You need to remove it from arguments in your menu"
		ewarn "configuration. Otherwise ${PN} won't work."
	fi
}
