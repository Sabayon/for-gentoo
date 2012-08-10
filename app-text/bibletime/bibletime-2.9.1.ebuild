# Copyright 1999-2009 Gentoo Foundation
# Copyright 2010-2011 The BibleTime team
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit cmake-utils

DESCRIPTION="Qt4 Bible study application using the SWORD library."
HOMEPAGE="http://www.bibletime.info/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE="debug"

RDEPEND=">=app-text/sword-1.6.0
	>=dev-cpp/clucene-0.9.16a
	x11-libs/qt-dbus:4
	x11-libs/qt-gui:4
	x11-libs/qt-webkit:4"
DEPEND="${RDEPEND}
	x11-libs/qt-test:4"

DOCS="ChangeLog README"

src_configure() {
	mycmakeargs="${mycmakeargs} -DUSE_QT_WEBKIT=ON"
	cmake-utils_src_configure
}
