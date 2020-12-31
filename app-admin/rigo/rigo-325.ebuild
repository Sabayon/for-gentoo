# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 python3_7 python3_8 )

inherit eutils gnome2-utils python-r1 git-r3 xdg-utils

DESCRIPTION="Rigo, the Sabayon Application Browser"
HOMEPAGE="http://www.sabayon.org"
LICENSE="GPL-3"

EGIT_REPO_URI=https://github.com/Sabayon/entropy.git
EGIT_COMMIT=${PV}

SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+passwordless-upgrade"

S="${WORKDIR}/${P}/rigo"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${PYTHON_DEPS}
	|| (
		dev-python/pygobject-cairo:3[${PYTHON_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP},cairo]
	)
	~sys-apps/entropy-${PV}[${PYTHON_USEDEP}]
	~sys-apps/rigo-daemon-${PV}[${PYTHON_USEDEP}]
	sys-devel/gettext
	x11-libs/gtk+:3
	x11-libs/vte:2.91
	>=x11-misc/xdg-utils-1.1.0_rc1_p20120319"
PDEPEND="passwordless-upgrade? ( app-misc/passwordless-upgrade )"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

PATCHES=()

src_install() {
	installation() {
		emake DESTDIR="${D}" PYTHON_SITEDIR="$(python_get_sitedir)" install
		python_optimize
	}
	python_foreach_impl installation
	python_replicate_script "${ED}usr/bin/rigo"
}

pkg_postinst() {
	xdg_mimeinfo_database_update
        xdg_desktop_database_update
}

pkg_postrm() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}
