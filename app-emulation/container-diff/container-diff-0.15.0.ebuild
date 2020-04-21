# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/GoogleContainerTools/${PN}/..."
S="${WORKDIR}/${P}/src/${EGO_PN%/*}"

inherit golang-vcs-snapshot git-r3

DESCRIPTION="tool for analyzing and comparing container images"
HOMEPAGE="https://github.com/GoogleContainerTools/container-diff"

EGIT_REPO_URI="https://github.com/GoogleContainerTools/container-diff.git"
EGIT_COMMIT="v0.15.0"
EGIT_CHECKOUT_DIR="${S}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm"
IUSE=""

DEPEND=""

src_compile() {
	GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" \
		go build -v -x ${EGO_BUILD_FLAGS} "${EGO_PN}" ./...
}

src_install() {
	GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" \
		go install -v -x ${EGO_BUILD_FLAGS} "${EGO_PN}"
	dobin ${WORKDIR}/${P}/bin/container-diff
}
