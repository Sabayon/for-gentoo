# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Dummy ebuild that prints the arch name in pkg_setup"
HOMEPAGE="http://www.sabayon.org"
LICENSE="GPL-2+"

SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""
SRC_URI=""

DEPEND=""
RDEPEND=""
PDEPEND=""

pkg_setup() {
	if use amd64; then
		echo amd64
	elif use x86; then
		echo x86
	elif use arm; then
		echo arm
	else
		echo unknown
	fi
}
