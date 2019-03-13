# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6} )

inherit eutils python-single-r1 bash-completion-r1 git-r3

DESCRIPTION="Entropy Package Manager server-side tools"
HOMEPAGE="http://www.sabayon.org"
LICENSE="GPL-2"

EGIT_REPO_URI="https://github.com/Sabayon/entropy.git"

SLOT="0"
KEYWORDS=""
IUSE="+matter"

S="${WORKDIR}/${P}/server"

RDEPEND="sys-apps/entropy[${PYTHON_USEDEP}]
	matter? ( app-admin/matter[entropy] )
	${PYTHON_DEPS}
	"
DEPEND="app-text/asciidoc"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_prepare() {
	default
	python_fix_shebang "${S}"
}

src_install() {
	emake DESTDIR="${D}" PYTHON_SITEDIR="$(python_get_sitedir)" install
	newbashcomp "${S}/eit-completion.bash" eit
	python_optimize
}
