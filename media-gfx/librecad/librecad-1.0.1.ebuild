# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils qt4-r2

DESCRIPTION="free Open Source personal 2D CAD application"
HOMEPAGE="http://www.librecad.org/"
SRC_URI="https://nodeload.github.com/LibreCAD/LibreCAD/tarball/v${PV} -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc"

RDEPEND="
	x11-libs/qt-gui[qt3support]
	x11-libs/qt-assistant:4
	x11-libs/qt-qt3support:4"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	mv * ${P}
}

src_prepare() {
	sed -i -e "s:\\\$\+system(git describe --tags):1.0.0:" "${PN}.pro"
}

src_install() {
	dobin unix/librecad || die
	insinto /usr/share/"${PN}"
	doins -r unix/resources/* || die
	use doc && dohtml -r support/doc/*
	doicon res/main/"${PN}".png
	make_desktop_entry "${PN}" LibreCAD "${PN}.png" Graphics
}
