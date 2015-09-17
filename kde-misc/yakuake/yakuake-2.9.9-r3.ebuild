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

RDEPEND="
	$(add_kdeapps_dep konsole)
	x11-libs/libX11
"
DEPEND="${RDEPEND}
	sys-devel/gettext
"

DOCS=( AUTHORS ChangeLog KDE4FAQ NEWS README TODO )

