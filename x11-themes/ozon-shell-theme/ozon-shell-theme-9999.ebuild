# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Ozon Gnome shell theme"
HOMEPAGE="https://github.com/ozonos/ozon-shell-theme"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/ozonos/${PN}.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/ozonos/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

DEPEND=">=gnome-base/gnome-shell-3.12
	gnome-extra/gnome-shell-extensions"
RDEPEND="${DEPEND}"

src_install() {
	insinto /usr/share/themes/Ozon
	doins -r gnome-shell
	dodoc README.md
}
