# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

SRC_URI=""
KEYWORDS="~amd64 ~arm ~x86"

DESCRIPTION="Eselect module for making easy to switch between LightDM greeters"
HOMEPAGE="http://www.sabayon.org"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

S="${WORKDIR}"

RDEPEND="app-admin/eselect"
DEPEND="${RDEPEND}"

src_install() {
	insinto /usr/share/eselect/modules
	newins "${FILESDIR}/lightdm-${PV}.eselect" lightdm.eselect
}
