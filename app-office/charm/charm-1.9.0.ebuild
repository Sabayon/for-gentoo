# Copyright 1999-2011 Klaralvdalens Datakonsult AB 
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit cmake-utils

DESCRIPTION="Charm time tracking application"
HOMEPAGE="http://github.com/KDAB/Charm"
SRC_URI="https://github.com/KDAB/Charm/tarball/$PV -> $P.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="debug idledetection timesheettools"

DEPEND=">=dev-qt/qtcore-4.6.0
	>=dev-qt/qtgui-4.6.0
	>=dev-qt/qtsql-4.6.0
	idledetection? ( x11-libs/libXScrnSaver )
	timesheettools? ( dev-db/mysql dev-db/mysql-connector-c++ )
"

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
