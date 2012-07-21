# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

SRC_URI=""
KEYWORDS="~amd64 ~x86"

DESCRIPTION="Eselect module for making easy to switch between x86/x86_64 Linux kernels"
HOMEPAGE="http://www.sabayon.org"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

S="${WORKDIR}"

RDEPEND=">=app-admin/eselect-1.2.3
	sys-apps/file"
DEPEND="${RDEPEND}"

src_install() {
	insinto /usr/share/eselect/modules
	newins "${FILESDIR}/bzimage-${PV}.eselect" bzimage.eselect
}
