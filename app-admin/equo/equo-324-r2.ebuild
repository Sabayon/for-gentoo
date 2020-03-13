# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )

inherit eutils python-r1 bash-completion-r1

DESCRIPTION="Entropy Package Manager text-based client"
HOMEPAGE="http://www.sabayon.org"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""
SRC_URI="mirror://sabayon/sys-apps/entropy-${PV}.tar.bz2"

S="${WORKDIR}/entropy-${PV}/client"
MISC_DIR="${WORKDIR}/entropy-${PV}/misc"

COMMON_DEPEND="${PYTHON_DEPS}
	~sys-apps/entropy-${PV}[${PYTHON_USEDEP}]"
DEPEND="${COMMON_DEPEND}
	dev-util/intltool
	app-text/asciidoc"
RDEPEND="${COMMON_DEPEND}
	sys-apps/file[${PYTHON_USEDEP},python]"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

PATCHES=(
	"${FILESDIR}/${P}-py3.patch"
)

src_install() {
	installation() {
		emake DESTDIR="${D}" LIBDIR="usr/lib" PYTHON_SITEDIR="$(python_get_sitedir)" install
		python_optimize
	}
	python_foreach_impl installation
	python_replicate_script "${ED}usr/bin/equo" "${ED}usr/bin/kernel-switcher"
	newbashcomp "${MISC_DIR}/equo-completion.bash" equo
}
