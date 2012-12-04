# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="A Microsoft-signed version of the UEFI Shim bootloader for SecureBoot"
HOMEPAGE="http://mjg59.dreamwidth.org/20303.html"
SRC_URI="mirror://sabayon/${CATEGORY}/${P}.tgz"

LICENSE="as-is"
SLOT="${PV}"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=""
DEPEND=""

S="${WORKDIR}/${PN}"

src_install() {
	local shim_dir=/usr/share/${P}
	dodir "${shim_dir}"
	insinto "${shim_dir}"
	doins -r "${S}"/*.efi
}
