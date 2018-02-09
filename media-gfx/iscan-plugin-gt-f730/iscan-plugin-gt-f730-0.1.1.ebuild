# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="2"

inherit rpm

# Revision used by upstream
SRC_REV="2"

MY_P="esci-interpreter-perfection-v330-${PV}"

DESCRIPTION="Epson Perfection V330 PHOTO scanner plugin for SANE 'epkowa' backend."
HOMEPAGE="http://www.avasys.jp/english/linux_e/dl_scan.html"
SRC_URI="
	x86? ( http://linux.avasys.jp/drivers/iscan-plugins/esci-interpreter-perfection-v330/${PV}/${MY_P}-${SRC_REV}.i386.rpm )
	amd64? ( http://linux.avasys.jp/drivers/iscan-plugins/esci-interpreter-perfection-v330/${PV}/${MY_P}-${SRC_REV}.x86_64.rpm )"

LICENSE="AVASYS"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE=""
IUSE_LINGUAS="ja"

for X in ${IUSE_LINGUAS}; do IUSE="${IUSE} linguas_${X}"; done

DEPEND=">=media-gfx/iscan-2.21.0"
RDEPEND="${DEPEND}"

src_install() {
	local MY_LIB="/usr/$(get_libdir)"

	# install scanner firmware
	insinto /usr/share/esci
	doins "${WORKDIR}/usr/share/esci/"*

	# install docs
	if use linguas_ja; then
		dodoc "usr/share/doc/${MY_P}/AVASYSPL.ja.txt"
	 else
		dodoc "usr/share/doc/${MY_P}/AVASYSPL.en.txt"
	fi

	# install scanner plugins
	insinto "${MY_LIB}/esci"
	INSOPTIONS="-m0755"
	doins "${WORKDIR}/usr/$(get_libdir)/esci/"*
}

pkg_postinst() {
	local MY_LIB="/usr/$(get_libdir)"

	# Needed for scaner to work properly.
	iscan-registry --add interpreter usb 0x04b8 0x0142 "${MY_LIB}/esci/libesci-interpreter-perfection-v330 /usr/share/esci/esfwad.bin"
	elog
	elog "Firmware file esfw8b.bin for Epson Perfection V330 PHOTO"
	elog "has been installed in /usr/share/esci and registered for use."
	elog
}

pkg_prerm() {
	local MY_LIB="/usr/$(get_libdir)"

	iscan-registry --remove interpreter usb 0x04b8 0x0142 "${MY_LIB}/esci/libesci-interpreter-perfection-v330 /usr/share/esci/esfwad.bin"
}
 
