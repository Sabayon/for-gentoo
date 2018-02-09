# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Sabayon LXD image builder from Docker images"
HOMEPAGE="https://github.com/Sabayon/sabayon-lxd-imagebuilder"
SRC_URI="https://github.com/Sabayon/sabayon-lxd-imagebuilder/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"
IUSE=""
RESTRICT="mirror"

DEPEND="
	app-emulation/docker-companion
	app-emulation/docker
	app-emulation/lxd
"
RDEPEND="${DEPEND}"

src_install() {
	exeinto /usr/bin
	doexe ${S}/sabayon-lxd-imagebuilder || die "Error on install sabayon-lxd-imagebuilder"

	dodoc ${S}/README.md
}
