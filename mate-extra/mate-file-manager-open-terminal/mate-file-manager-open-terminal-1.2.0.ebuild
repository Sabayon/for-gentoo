# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
GCONF_DEBUG="no"

inherit autotools mate

DESCRIPTION="Caja plugin for opening terminals"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND=">=mate-base/mate-file-manager-1.2.2"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig
	>=dev-util/intltool-0.35"

DOCS="AUTHORS ChangeLog NEWS README TODO"

pkg_setup() {
	G2CONF="${G2CONF} --disable-static"
}

src_prepare() {
	eautoreconf
	mate_src_prepare
}

src_install() {
	mate_src_install
	find "${D}" -name "*.la" -delete || die "remove of *.la files failed"
}
