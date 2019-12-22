# Copyright 2016-2017 Redcore Linux Project
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kde5

DESCRIPTION="Pure Qt NetworkManager front-end residing in panels"
HOMEPAGE="https://github.com/palinek/nm-tray"
SRC_URI="https://github.com/palinek/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep networkmanager-qt)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep linguist-tools)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtwidgets)"
RDEPEND="${DEPEND}
	x11-terms/xterm"

src_install() {
	cmake-utils_src_install
	mv ${D}/usr/etc ${D}/etc
}
