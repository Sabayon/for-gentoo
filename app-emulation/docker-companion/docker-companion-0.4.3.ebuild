# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/mudler/${PN}"
S="${WORKDIR}/${P}/src/${EGO_PN}"

inherit golang-vcs-snapshot git-r3

EGIT_REPO_URI="https://${EGO_PN}"
EGIT_COMMIT="v${PV}"
EGIT_CHECKOUT_DIR="${S}"
DESCRIPTION="A mix of tools for Docker"
HOMEPAGE="https://${EGO_PN}"
RESTRICT="mirror"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm"

src_compile() {
	GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" \
	go build
}

src_install() {
	dobin docker-companion
}
