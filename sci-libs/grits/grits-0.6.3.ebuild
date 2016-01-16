# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit gnome2

DESCRIPTION="Virtual Globe library"
HOMEPAGE="http://lug.rose-hulman.edu/wiki/Grits"
SRC_URI="http://lug.rose-hulman.edu/proj/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND=">=net-libs/libsoup-2.26
	dev-libs/glib:2
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}"

DOCS="ChangeLog README TODO"
