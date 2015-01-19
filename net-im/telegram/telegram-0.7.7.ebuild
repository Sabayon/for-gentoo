# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

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

QA_PREBUILT="opt/bin/${PN}"

src_unpack() {
	unpack ${A}
	mkdir -p "${S}"
	mv "${WORKDIR}"/Telegram/* "${S}" || die
	rmdir Telegram
}

src_install() {
	exeinto "/opt/${PN}"
	doexe Telegram
	dodir /opt/bin
	dosym ../telegram/Telegram /opt/bin/Telegram || die
}
