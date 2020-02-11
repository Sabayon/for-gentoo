# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )

inherit eutils python-r1 bash-completion-r1

DESCRIPTION="Automated Packages Builder for Portage and Entropy"
HOMEPAGE="http://www.sabayon.org"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+entropy"
SRC_URI="mirror://sabayon/sys-apps/entropy-${PV}.tar.bz2"

S="${WORKDIR}/entropy-${PV}/${PN}"

DEPEND=""
RDEPEND="entropy? ( ~sys-apps/entropy-${PV}[${PYTHON_USEDEP}] )
	sys-apps/file[${PYTHON_USEDEP},python]
	${PYTHON_DEPS}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_install() {
	installation() {
		emake DESTDIR="${D}" PYTHON_SITEDIR="$(python_get_sitedir)" install
		emake DESTDIR="${D}" PYTHON_SITEDIR="$(python_get_sitedir)" base-install
		if use entropy; then
			emake DESTDIR="${D}" PYTHON_SITEDIR="$(python_get_sitedir)" entropysrv-install
		fi
		python_optimize
	}
	python_foreach_impl installation
	python_replicate_script "${ED}usr/sbin/antimatter" "${ED}usr/sbin/matter"
}
