# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )

inherit eutils python-r1

DESCRIPTION="Entropy Package Manager notification applet GTK3 frontend"
HOMEPAGE="http://www.sabayon.org"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

SRC_URI="mirror://sabayon/sys-apps/entropy-${PV}.tar.bz2"
S="${WORKDIR}/entropy-${PV}/magneto"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	~app-misc/magneto-loader-${PV}[${PYTHON_USEDEP}]
	dev-libs/gobject-introspection
	x11-libs/gdk-pixbuf[introspection]
	x11-libs/gtk+:3[introspection]
	x11-libs/libnotify[introspection]"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_install() {
	installation() {
		emake DESTDIR="${D}" LIBDIR="usr/lib" PYTHON_SITEDIR="$(python_get_sitedir)" \
			magneto-gtk3-install
		python_optimize
	}
	python_foreach_impl installation
}
