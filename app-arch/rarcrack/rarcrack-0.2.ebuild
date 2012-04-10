# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="Password recovery for 7zip, rar and zip archives"
HOMEPAGE="http://rarcrack.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="7zip rar zip"

DEPEND=""
RDEPEND="${DEPEND}
	rar? ( app-arch/unrar )
	zip? ( app-arch/unzip )
	7zip? ( app-arch/p7zip )
"

src_install() {
	dobin ${PN}
}
