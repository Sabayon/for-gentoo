# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
KDE_REQUIRED="optional"
CMAKE_REQUIRED="false"

inherit eutils gnome2-utils kde4-base qt4-r2

MY_P=${P/_rc/-rc}

DESCRIPTION="Automatic subtitle downloader using Napiprojekt database"
HOMEPAGE="http://krzemin.iglu.cz/software/qnapi"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnome"

S=${WORKDIR}/${MY_P}

DEPEND="dev-qt/qtcore:4
	dev-qt/qtgui:4
	gnome? ( gnome-base/gconf )"
RDEPEND="${DEPEND}
	app-arch/p7zip"

# fix install paths, remove unneeded files, general cleanup
PATCHES=( "${FILESDIR}/${P}-gentoo.diff" )

pkg_setup() {
	use kde && kde4-base_pkg_setup # get KDEDIR for KDE4
}

src_configure() {
	local integr

	use gnome && integr="gnome_integration"
	use kde && integr="${integr} kde4_integration"
	KDE4DIR="${KDEDIR}" INTEGRATION_TARGETS="${integr}" eqmake4
}

pkg_preinst() {
	use gnome && gnome2_gconf_savelist
}

pkg_postinst() {
	use gnome && gnome2_gconf_install
	use kde && kde4-base_pkg_postinst
}

pkg_postrm() {
	use kde && kde4-base_pkg_postrm
}
