# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )

inherit eutils python-r1

MY_PN="RigoDaemon"
DESCRIPTION="Entropy Client DBus Services, aka RigoDaemon"
HOMEPAGE="http://www.sabayon.org"
LICENSE="GPL-3"

SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""
SRC_URI="mirror://sabayon/sys-apps/entropy-${PV}.tar.bz2"

S="${WORKDIR}/entropy-${PV}/rigo/${MY_PN}"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${PYTHON_DEPS}
	dev-python/dbus-python
	dev-python/pygobject:3
	~sys-apps/entropy-${PV}[${PYTHON_USEDEP}]
	sys-auth/polkit[introspection]
	sys-devel/gettext"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_install() {
	installation() {
		emake DESTDIR="${D}" PYTHON_SITEDIR="$(python_get_sitedir)" install
		python_optimize
	}
	python_foreach_impl installation
	python_replicate_script "${ED}usr/libexec/RigoDaemon_app.py"
}
