# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

EAPI="4"

inherit versionator

DESCRIPTION="Caja video thumbnailer for MATE"
HOMEPAGE="http://mate-desktop.org"
SRC_URI="http://pub.mate-desktop.org/releases/$(get_version_component_range 1-2)/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND="media-video/ffmpegthumbnailer
	>=mate-base/mate-file-manager-1.2.2"

DEPEND="app-arch/xz-utils"

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS README
}
