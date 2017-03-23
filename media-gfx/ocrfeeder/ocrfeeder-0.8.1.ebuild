# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit versionator

DESCRIPTION="Document layout analysis and optical character recognition system"
HOMEPAGE="http://live.gnome.org/OCRFeeder"
SRC_URI="http://ftp.gnome.org/pub/GNOME/sources/${PN}/$(get_version_component_range 1-2)/${P}.tar.xz"

LICENSE="GPL3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="+unpaper tesseract gocr"

# TODO python
DEPEND="
	app-text/gtkspell:3
	dev-python/pillow[scanner]
	dev-python/pyenchant
	x11-libs/goocanvas[introspection]
	app-text/gnome-doc-utils
	dev-python/reportlab

	gocr? ( app-text/gocr )
	unpaper? ( app-text/unpaper )
	tesseract? ( app-text/tesseract )
	"
RDEPEND="${DEPEND}"
