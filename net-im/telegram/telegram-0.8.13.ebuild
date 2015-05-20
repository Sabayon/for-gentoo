# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

MY_PN="Telegram"
inherit eutils
DESCRIPTION="Unofficial telegram protocol client"
HOMEPAGE="https://telegram.org/"
SRC_URI="
	amd64?	( https://updates.tdesktop.com/tlinux/tsetup.${PV}.tar.xz -> ${P}.tar.xz )
	x86?	( https://updates.tdesktop.com/tlinux32/tsetup32.${PV}.tar.xz -> ${PN}32-${PV}.tar.xz )"

RESTRICT="mirror"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
S="${WORKDIR}/${MY_PN}"

src_install() {
	exeinto "/opt/${PN}"
	doexe "${MY_PN}"
	make_wrapper "${PN}" "/opt/${PN}/${MY_PN}"
	make_desktop_entry "${PN}" "${MY_PN} Desktop" "/usr/share/pixmaps/${PN}.png" "" "MimeType=application/x-xdg-protocol-tg;x-scheme-handler/tg;"
	newicon "${FILESDIR}/${P}.png" "${PN}.png"
}
