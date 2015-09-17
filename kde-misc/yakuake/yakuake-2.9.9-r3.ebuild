# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_LINGUAS="ca ca@valencia cs da de el en_GB es et fi fr ga gl hr hu it km ko
nb nds nl nn pa pl pt pt_BR ro ru sk sr sr@ijekavian sr@ijekavianlatin sr@latin
sv th tr uk wa zh_CN zh_TW"
inherit kde5 git-r3

DESCRIPTION="A quake-style terminal emulator based on KDE konsole technology"
HOMEPAGE="https://yakuake.kde.org/"
EGIT_REPO_URI="git://anongit.kde.org/yakuake.git"
EGIT_BRANCH="frameworks"

LICENSE="GPL-2 LGPL-2"
KEYWORDS="amd64 ~arm ppc x86"
SLOT="5"
IUSE="debug"

DEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep kglobalaccel)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep knewstuff)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep knotifyconfig)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_kdeapps_dep konsole)
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	x11-libs/libX11
"
RDEPEND="${DEPEND}
	!kde-misc/yakuake:4
"
