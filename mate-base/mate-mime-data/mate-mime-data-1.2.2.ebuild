# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $
EAPI="4"
inherit autotools gnome2 mate-desktop.org

DESCRIPTION="MIME data for MATE"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND=""
DEPEND="virtual/pkgconfig
		>=dev-util/intltool-0.35"

DOCS="AUTHORS ChangeLog README"

src_prepare() {
	eautoreconf
        intltoolize --force || die "intltoolize failed"
	gnome2_src_unpack
}
