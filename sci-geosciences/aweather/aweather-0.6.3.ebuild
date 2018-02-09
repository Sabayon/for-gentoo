# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4
inherit gnome2

DESCRIPTION="A weather monitoring program"
HOMEPAGE="http://lug.rose-hulman.edu/proj/aweather"
SRC_URI="http://lug.rose-hulman.edu/proj/${PN}/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="=sci-libs/grits-${PV}
	x11-libs/gtk+:2
	sci-libs/rsl"
DEPEND="${RDEPEND}"

DOCS="ChangeLog README TODO"
