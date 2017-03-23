# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

AUTOTOOLS_AUTORECONF=1
inherit autotools-utils

DESCRIPTION="Adds 'Resize Images' and 'Rotate Images' items to context menu for images"
HOMEPAGE="http://www.bitron.ch/software/nautilus-image-converter.php"
SRC_URI="mirror://sabayon/${CATEGORY}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEPEND="
	dev-libs/glib:2
	>=gnome-base/nautilus-3
	x11-libs/gtk+:3
"
DEPEND="${COMMON_DEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
	gnome-base/gnome-common:3
"
RDEPEND="${COMMON_DEPEND}
	|| ( media-gfx/imagemagick media-gfx/graphicsmagick[imagemagick] )
"

src_install() {
	autotools-utils_src_install
	remove_libtool_files all
}
