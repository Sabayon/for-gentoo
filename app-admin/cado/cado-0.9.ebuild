# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils autotools

DESCRIPTION="Capability DO (like a sudo providing users with just the capabilities they need)"
HOMEPAGE="https://github.com/rd235/cado"

if [[ ${PV} = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/rd235/${PN}"
	KEYWORDS=""
else
	SRC_URI="https://github.com/rd235/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~arm"
fi

SLOT="0"
LICENSE="GPL-2"

COMMON_DEPEND="
	sys-libs/glibc:2.2
	sys-libs/pam
	sys-libs/libcap"
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}"

src_prepare() {
	eapply_user
	eautoreconf
}

src_install() {
	dobin ${PN}
	dobin caprint
	doman *.1
}
