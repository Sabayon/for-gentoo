# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit rpm

# Revision used by upstream
SRC_REV="3"

MY_P="${P}-${SRC_REV}"

DESCRIPTION="Epson Perfection V200 PHOTO scanner plugin for SANE 'epkowa' backend."
HOMEPAGE="http://www.avasys.jp/english/linux_e/dl_scan.html"
SRC_URI="
	x86?   ( http://linux.avasys.jp/drivers/scanner-plugins/GT-F670/${MY_P}.c2.i386.rpm )
	amd64? ( http://linux.avasys.jp/drivers/scanner-plugins/GT-F670/${MY_P}.c2.x86_64.rpm )"

LICENSE="AVASYS Public License"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE=""
IUSE_LINGUAS="ja"

for X in ${IUSE_LINGUAS}; do IUSE="${IUSE} linguas_${X}"; done

DEPEND=">=media-gfx/iscan-2.18.0"
RDEPEND="${DEPEND}"

MY_LIB="/usr/$(get_libdir)"

src_install() {
	# install scanner firmware
	insinto /usr/share/iscan
	doins "${WORKDIR}"/usr/share/iscan/*

	# install docs
	if use linguas_ja; then
	   dodoc usr/share/doc/"${P}"/AVASYSPL.ja.txt
	 else
	   dodoc usr/share/doc/"${P}"/AVASYSPL.en.txt
	fi

	# install scanner plugins
	insinto "${MY_LIB}"/iscan
	INSOPTIONS="-m0755"
	doins "${WORKDIR}"/usr/$(get_libdir)/iscan/*
}

pkg_postinst() {
	# Needed for scaner to work properly.
	iscan-registry --add interpreter usb 0x04b8 0x012e ${MY_LIB}/iscan/libesint7A /usr/share/iscan/esfw7A.bin
	
	elog
	elog "Firmware file esfw7A.bin for Epson Perfection V200"
	elog "PHOTO has been installed in /usr/share/iscan and"
	elog "registered for use"
	elog
}

pkg_prerm() {
	# Uninstall interpreter from iscan-registry before removal
	iscan-registry --remove interpreter usb 0x04b8 0x012e ${MY_LIB}/iscan/libesint7A /usr/share/iscan/esfw7A.bin
}
