# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )

inherit eutils python-r1 bash-completion-r1

DESCRIPTION="Entropy Package Manager server-side tools"
HOMEPAGE="http://www.sabayon.org"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+matter"

SRC_URI="mirror://sabayon/sys-apps/entropy-${PV}.tar.bz2"

S="${WORKDIR}/entropy-${PV}/server"

RDEPEND="~sys-apps/entropy-${PV}[${PYTHON_USEDEP}]
	matter? ( ~app-admin/matter-${PV}[${PYTHON_USEDEP},entropy] )
	${PYTHON_DEPS}
	"
DEPEND="app-text/asciidoc"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_install() {
	installation() {
		emake DESTDIR="${D}" PYTHON_SITEDIR="$(python_get_sitedir)" install
		python_optimize
	}
	python_foreach_impl installation
	python_replicate_script "${ED}usr/bin/eit"
	newbashcomp "${S}/eit-completion.bash" eit
}
