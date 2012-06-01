# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

EAPI="3"
GCONF_DEBUG="no"

inherit autotools gnome2 mate-desktop.org

DESCRIPTION="A set of backgrounds packaged with the MATE desktop"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND=""
DEPEND="sys-devel/gettext
	>=dev-util/intltool-0.35"

DOCS="AUTHORS ChangeLog NEWS README"

src_prepare() {
	eautoreconf
	gnome2_src_prepare
}
