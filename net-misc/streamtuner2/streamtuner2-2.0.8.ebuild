# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils

DESCRIPTION="Internet radio browser"
HOMEPAGE="http://sourceforge.net/projects/streamtuner2/"
SRC_URI="mirror://sourceforge/${PN}/${P}.src.tgz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	=dev-lang/python-2*
	dev-libs/keybinder:0[python]
	virtual/python-imaging
	dev-python/pygtk:2
	dev-python/pyquery"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

src_prepare() {
	epatch "${FILESDIR}"/${P}-fix-python-path.patch \
		"${FILESDIR}"/${P}-desktop-file.patch
}

src_install() {
	cd "${PN}"
	newbin st2.py streamtuner2
	rm -f st2.py

	insinto /usr/share/pixmaps
	doins streamtuner2.png

	insinto /usr/share/applications
	doins streamtuner2.desktop
	rm -f streamtuner2.desktop

	dodir /usr/share/${PN}
	cp -R . "${D}"usr/share/${PN}
}
