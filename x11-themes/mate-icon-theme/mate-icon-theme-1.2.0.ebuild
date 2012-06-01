# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

EAPI="4"
GCONF_DEBUG="no"

inherit autotools gnome2 mate-desktop.org

DESCRIPTION="MATE default icon themes"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND=">=x11-themes/hicolor-icon-theme-0.10"

DEPEND="${RDEPEND}
	>=x11-misc/icon-naming-utils-0.8.7
	virtual/pkgconfig
	>=dev-util/intltool-0.40
	sys-devel/gettext"

# Upstream didn't give us a ChangeLog with 2.30
DOCS="AUTHORS NEWS TODO"

# This ebuild does not install any binaries
RESTRICT="binchecks strip"

# FIXME: double check potential LINGUAS problem
src_prepare() {
	eautoreconf
	gnome2_src_prepare
}

pkg_setup() {
	G2CONF="${G2CONF} --enable-icon-mapping"
}
