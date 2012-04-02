# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
PYTHON_DEPEND="2"
inherit eutils python

DESCRIPTION="Entropy Client DBus Services, aka RigoDaemon"
HOMEPAGE="http://www.sabayon.org"
LICENSE="GPL-3"

SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""
SRC_URI="mirror://sabayon/sys-apps/entropy-${PV}.tar.bz2"

S="${WORKDIR}/entropy-${PV}/rigo/RigoDaemon"

DEPEND=""
RDEPEND="dev-python/dbus-python
	dev-python/pygobject:3
	~sys-apps/entropy-${PV}
	sys-auth/polkit[introspection]
	sys-devel/gettext"

src_compile() {
	emake || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
}

pkg_preinst() {
	# ask RigoDaemon to shutdown, if running
	# TODO: this will be removed in future
	local shutdown_exec=${EROOT}/usr/lib/rigo/RigoDaemon/shutdown.py
	[[ -x "${shutdown_exec}" ]] && "${shutdown_exec}"
}

pkg_postinst() {
	python_mod_optimize "/usr/lib/rigo/${PN}"
}

pkg_postrm() {
	python_mod_cleanup "/usr/lib/rigo/${PN}"
}
