# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

MY_PN=${PN/-bin/}
inherit unpacker eutils

DESCRIPTION="Packer is a tool for creating machine and container images for multiple platforms from a single source configuration"
HOMEPAGE="https://packer.io/"

SRC_URI_AMD64="https://dl.bintray.com/mitchellh/${MY_PN}/${MY_PN}_${PV}_linux_amd64.zip"
SRC_URI_X86="https://dl.bintray.com/mitchellh/${MY_PN}/${MY_PN}_${PV}_linux_386.zip"
SRC_URI="
    amd64? ( ${SRC_URI_AMD64} )
    x86? ( ${SRC_URI_X86} )
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

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
