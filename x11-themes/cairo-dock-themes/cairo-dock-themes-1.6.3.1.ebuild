# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit gnome2

MY_PN="${PN/-themes}"

DESCRIPTION="Official themes for Cairo-dock"
HOMEPAGE="http://www.cairo-dock.org"
SRC_URI="mirror://berlios/${MY_PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND=">=x11-misc/cairo-dock-${PV}"

src_prepare() {
	sed -i -e \
		"/^pkgdatadir=\`/s|.*|pkgdatadir=${EPREFIX}/usr/share/cairo-dock/themes|" \
		configure || die
		gnome2_src_prepare
}
