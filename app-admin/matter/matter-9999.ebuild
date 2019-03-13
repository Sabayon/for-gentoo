# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6} )

inherit eutils python-single-r1 bash-completion-r1 git-r3

DESCRIPTION="Automated Packages Builder for Portage and Entropy"
HOMEPAGE="http://www.sabayon.org"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS=""
IUSE="+entropy"
EGIT_REPO_URI="https://github.com/Sabayon/entropy.git"

S="${WORKDIR}/${P}/${PN}"

DEPEND=""
RDEPEND="entropy? ( sys-apps/entropy[${PYTHON_USEDEP}] )
	sys-apps/file[python]
	${PYTHON_DEPS}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_prepare() {
	default
	python_fix_shebang "${S}"
}

src_install() {
	emake DESTDIR="${D}" PYTHON_SITEDIR="$(python_get_sitedir)" install
	emake DESTDIR="${D}" PYTHON_SITEDIR="$(python_get_sitedir)" base-install
	if use entropy; then
		emake DESTDIR="${D}" PYTHON_SITEDIR="$(python_get_sitedir)" entropysrv-install
	fi

	python_optimize
}
