# Copyright 1999-2011 Klaralvdalens Datakonsult AB 
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit cmake-utils

DESCRIPTION="Charm time tracking application"
HOMEPAGE="http://github.com/KDAB/Charm"
SRC_URI="mirror://sabayon/${CATEGORY}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="debug idledetection timesheettools"

DEPEND=">=x11-libs/qt-core-4.6.0
	>=x11-libs/qt-gui-4.6.0
	>=x11-libs/qt-sql-4.6.0
	idledetection? ( x11-libs/libXScrnSaver )
	timesheettools? ( dev-db/mysql dev-db/mysql-connector-c++ )
"

PATCHES="${FILESDIR}/alternatefilename.patch"

src_unpack() {
	# Damn Github
	unpack ${A}
	mv *-Charm-* "${S}"
}

src_configure() {
	cmake-utils_use timesheettools CHARM_TIMESHEET_TOOLS
	cmake-utils_use idledetection CHARM_IDLE_DETECTION

	MYCMAKEARGS="-DCharm_VERSION=${PV}"
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	dodoc ReadMe.txt
}
