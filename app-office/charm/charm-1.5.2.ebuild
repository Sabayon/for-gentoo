# Copyright 1999-2011 Klaralvdalens Datakonsult AB 
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit cmake-utils

LICENSE="GPL2"
DESCRIPTION="Charm time tracking application"
IUSE="idledetection package timesheettools debug norename"
HOMEPAGE="http://github.com/KDAB/Charm"
KEYWORDS="amd64 x86 ~arm ~ppc ~ia64"
LICENSE="GPL-2"
PATCHES="${FILESDIR}/alternatefilename.patch"

#Source location
SRC_URI="mirror://sabayon/${CATEGORY}/${PN}/${P}.tar.gz"

SLOT="0"

#Creating distributable packages requires a new cmake
CMAKE_MIN_VERSION="2.8.4"

RDEPEND=">=x11-libs/qt-core-4.6.3
	>=x11-libs/qt-gui-4.6.3
	>=x11-libs/qt-sql-4.6.3
	idledetection? ( x11-libs/libXScrnSaver )
	timesheettools? ( dev-db/mysql dev-db/mysql-connector-c++ )
	norename? ( !net-misc/charm )
	"
DEPEND="${DEPEND}
	>=dev-util/cmake-${CMAKE_MIN_VERSION}
	"

src_configure() {

	if use debug ; then
		CMAKE_BUILD_TYPE="Debug"
	fi

	cmake-utils_use timesheettools CHARM_TIMESHEET_TOOLS
	cmake-utils_use idledetection CHARM_IDLE_DETECTION

	cmake-utils_src_configure
}

src_test() {
	cmake-utils_src_test
}

src_install() {
	cmake-utils_src_install
	dodoc License.txt ReadMe.txt
	doicon ../Charm/Icons/Charm-256x256.png
	domenu ../Charm/Charm.desktop
}
