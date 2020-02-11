# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit eutils python-r1

DESCRIPTION="Entropy Package Manager notification applet GTK2 frontend"
HOMEPAGE="http://www.sabayon.org"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

SRC_URI="mirror://sabayon/sys-apps/entropy-${PV}.tar.bz2"
S="${WORKDIR}/entropy-${PV}/magneto"

# Make it depend on x11-misc/magneto-gtk3 (with any Python) so that it's more a
# transition package until magneto-gtk is removed after some time.
# Note: app-misc/magneto-loader has fallback that it tries both gtk and gtk3
# in case of an import problem.

# Addition of this dependency solves the problem that magneto (from
# app-misc/magneto-loader) when used with python 3 tries to import magneto-gtk
# (if configured so etc.) which only works with Python 2 and that would fail.
# Now gtk3 would be used as a fallback.
# (app-misc/magneto-loader does not depend on any magneto-gtk* etc. so no
# PYTHON_USEDEP enforcement can be made. Anyway, dev-python/pygtk is planned to
# be removed from Gentoo.)
DEPEND="${PYTHON_DEPS}"
RDEPEND="~app-misc/magneto-loader-${PV}[${PYTHON_USEDEP}]
	dev-python/notify-python[${PYTHON_USEDEP}]
	dev-python/pygtk:2[${PYTHON_USEDEP}]
	x11-misc/magneto-gtk3
	${DEPEND}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_install() {
	installation() {
		emake DESTDIR="${D}" LIBDIR="usr/lib" PYTHON_SITEDIR="$(python_get_sitedir)" \
			magneto-gtk-install
		python_optimize
	}
	python_foreach_impl installation
}
