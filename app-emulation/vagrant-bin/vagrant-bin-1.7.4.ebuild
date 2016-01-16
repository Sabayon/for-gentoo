# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

MY_PN=${PN/-bin/}
inherit unpacker eutils

DESCRIPTION="Tool for building and distributing virtual machines"
HOMEPAGE="http://vagrantup.com/"

SRC_URI_BASE="https://dl.bintray.com/mitchellh/${MY_PN}/${MY_PN}_${PV}"
SRC_URI="
	amd64? ( ${SRC_URI_BASE}_x86_64.deb )
	x86? ( ${SRC_URI_BASE}_i686.deb )"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/opt/${MY_PN}"

DEPEND=""
RDEPEND="${DEPEND}
	app-arch/libarchive
	net-misc/curl
	!app-emulation/vagrant
"

RESTRICT="mirror"

src_unpack() {
	unpack_deb ${A}
}

src_install() {
	local dir="/opt/${MY_PN}"
	dodir ${dir}
	cp -ar ./* "${ED}${dir}" || die "copy files failed"

	make_wrapper "${MY_PN}" "${dir}/bin/${MY_PN}"
}
