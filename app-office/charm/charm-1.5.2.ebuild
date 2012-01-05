# Copyright 1999-2011 Klaralvdalens Datakonsult AB 
# Distributed under the terms of the GNU General Public License v2
# $Header: $


EAPI=3
inherit cmake-utils git-2

#General information
LICENSE="GPL2"
DESCRIPTION="Charm time tracking application"
IUSE="idledetection package timesheettools debug norename"
HOMEPAGE="http://github.com/KDAB/Charm"
KEYWORDS="amd64 x86 ~arm ~ppc ~ia64"
LICENSE="GPL-2"

#Source location
SRC_URI="mirror://sabayon/${CATEGORY}/${PN}/${P}.tar.gz"

#These make creating new ebuilds much easier
MIN_QT_VERSION="4.6.3"
MIN_CMAKE_VERSION_BUILD="2.6"
#Creating distributable packages requires a new cmake
MIN_CMAKE_VERSION_PACKAGE="2.8.4"

#Setup CMake
WANT_CMAKE="${WANT_CMAKE:-always}"
CMAKE_MIN_VERSION=${MIN_CMAKE_VERSION_BUILD}
if use package ; then
	CMAKE_MIN_VERSION=${MIN_CMAKE_VERSION_PACKAGE}
fi
CMAKE_BUILD_DIR="${WORKDIR}/${P}/build"
CMAKE_IN_SOURCE_BUILD="disable"

RDEPEND=">=x11-libs/qt-core-${MIN_QT_VERSION}
	>=x11-libs/qt-gui-${MIN_QT_VERSION}
	>=x11-libs/qt-sql-${MIN_QT_VERSION}
	idledetection? ( x11-libs/libXScrnSaver )
	timesheettools? ( dev-db/mysql dev-db/mysql-connector-c++ )
	norename? ( !net-misc/charm )
	"
DEPEND="${DEPEND}
	>=dev-util/cmake-${CMAKE_MIN_VERSION}
	"

src_prepare() {
	if use !norename ; then
		epatch "${FILESDIR}/alternatefilename.patch"
	fi
}

src_configure() {

	if use debug ; then
		CMAKE_BUILD_TYPE="Debug"
	else
		CMAKE_BUILD_TYPE="Release"
	fi

	cmake-utils_use timesheettools CHARM_TIMESHEET_TOOLS
	cmake-utils_use idledetection CHARM_IDLE_DETECTION

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
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
