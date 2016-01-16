# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils vcs-snapshot

DESCRIPTION="A PDF to HTML converter"
HOMEPAGE="http://coolwanglu.github.com/pdf2htmlEX/"
SRC_URI="https://github.com/coolwanglu/${PN}/tarball/v${PV} -> ${P}.tar.gz"

LICENSE="GPL-2 GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=app-text/poppler-0.20[cjk,png,jpeg2k]
	media-gfx/fontforge"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
