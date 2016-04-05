# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_AUTHOR="snwh"
DESCRIPTION="the Paper gtk theme by snwh"
HOMEPAGE="https://github.com/${MY_AUTHOR}/${PN}"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/${MY_AUTHOR}/${PN}.git"
	KEYWORDS=""
else
	inherit git-r3
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/${MY_AUTHOR}/${PN}.git"
	EGIT_COMMIT="02973b6e054a3b1699eebfbf3b72d940f24f72e8"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"

DEPEND=">=gnome-base/gnome-shell-3.16
	gnome-extra/gnome-shell-extensions
	x11-libs/gdk-pixbuf"
RDEPEND="${DEPEND}"

src_install() {
	insinto /usr/share/themes/
	doins -r Paper
	dodoc README.md
}
