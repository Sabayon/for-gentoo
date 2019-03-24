# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN=${PN/-bin/}
inherit unpacker eutils

DESCRIPTION="Packer is a tool for creating machine and container images for multiple platforms"
HOMEPAGE="https://packer.io/"

SRC_URI_AMD64="https://releases.hashicorp.com/${MY_PN}/${PV}/${MY_PN}_${PV}_linux_amd64.zip"
SRC_URI_X86="https://releases.hashicorp.com/${MY_PN}/${PV}/${MY_PN}_${PV}_linux_386.zip"
SRC_URI_ARM="https://releases.hashicorp.com/${MY_PN}/${PV}/${MY_PN}_${PV}_linux_arm.zip"
SRC_URI="
	amd64? ( ${SRC_URI_AMD64} )
	x86? ( ${SRC_URI_X86} )
	arm? ( ${SRC_URI_ARM} )
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm"
IUSE=""
RESTRICT="nomirror"

S=$WORKDIR

DEPEND=""
RDEPEND=""

RESTRICT="mirror"

src_install() {
	local dir="/opt/${MY_PN}"
	dodir ${dir}
	cp -ar ./* "${ED}${dir}" || die "copy files failed"

	make_wrapper "${MY_PN}" "${dir}/${MY_PN}"
}
