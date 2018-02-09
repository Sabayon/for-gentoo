# Copyright 1999-2012 Sabayon Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="2"

DESCRIPTION="OpenBroadcom Firmware"
HOMEPAGE="http://www.ing.unibs.it/openfwwf/"
SRC_URI="http://www.ing.unibs.it/openfwwf/firmware/openfwwf-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
DEPEND="net-wireless/b43-asm"
S="${WORKDIR}/openfwwf-${PV}"

src_install() {
	emake PREFIX="${D}"/lib/firmware/b43-open install || die "emake failed"
}
