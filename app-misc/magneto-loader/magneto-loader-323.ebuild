# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )

inherit eutils python-r1

DESCRIPTION="Official Sabayon Linux Entropy Notification Applet Loader"
HOMEPAGE="http://www.sabayon.org"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

SRC_URI="mirror://sabayon/sys-apps/entropy-${PV}.tar.bz2"
S="${WORKDIR}/entropy-${PV}/magneto"

DEPEND="${PYTHON_DEPS}
	~sys-apps/magneto-core-${PV}[${PYTHON_USEDEP}]
	~app-admin/rigo-${PV}[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_install() {
	installation() {
		emake DESTDIR="${D}" LIBDIR="usr/lib" magneto-loader-install || die "make install failed"
	}
	python_foreach_impl installation
	python_replicate_script "${ED}usr/bin/magneto"
}
