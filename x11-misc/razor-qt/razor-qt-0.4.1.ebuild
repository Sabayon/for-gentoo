# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils cmake-utils

MY_P="${P/-qt/qt}"
DESCRIPTION="Razor-qt is easy-to-use and fast desktop environment based on Qt technologies."
HOMEPAGE="http://razor-qt.org/"
SRC_URI="http://razor-qt.org/downloads/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="handbook"

RDEPEND="sys-auth/polkit-qt
         x11-base/xorg-server
         x11-libs/libXcomposite
         sys-fs/udev
         x11-libs/qt-core:4
         x11-libs/qt-dbus:4
         x11-libs/qt-declarative:4
         x11-libs/qt-gui:4
         x11-libs/qt-multimedia:4
         x11-libs/qt-opengl:4
         x11-libs/qt-qt3support:4
         x11-libs/qt-script:4
         x11-libs/qt-sql:4
         x11-libs/qt-svg:4
         x11-libs/qt-test:4
         x11-libs/qt-webkit:4
         x11-libs/qt-xmlpatterns:4
         || ( x11-wm/openbox kde-base/kwin )"
DEPEND="${RDEPEND}
         dev-util/cmake
         sys-devel/gcc
         handbook? ( app-doc/doxygen )"

S="${WORKDIR}/${MY_P}"

src_compile() {
	cmake-utils_src_make

	# build developer documentation using Doxygen
	if use handbook ; then
		emake -C "${CMAKE_BUILD_DIR}" docs || die "Creating developer documentation failed"
	fi
}

src_install() {
	cmake-utils_src_install

	# install developer documentation to
	# /usr/share/doc/razor-qt-VERSION/developer-documentation
	if use handbook ; then
		mkdir -p "${D}"/usr/share/doc/${P}/ || die "Cannot create directory for documentation"
		cp -rp "${CMAKE_BUILD_DIR}/docs" "${D}"/usr/share/doc/${P}/developer-documentation \
		    || die "Installing developer documentation failed"
	fi
}
