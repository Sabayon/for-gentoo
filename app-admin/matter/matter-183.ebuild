# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
PYTHON_DEPEND="2"
inherit eutils python bash-completion-r1

DESCRIPTION="Automated Packages Builder for Portage and Entropy"
HOMEPAGE="http://www.sabayon.org"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+entropy"
SRC_URI="mirror://sabayon/sys-apps/entropy-${PV}.tar.bz2"

S="${WORKDIR}/entropy-${PV}/${PN}"

DEPEND=""
RDEPEND="entropy? ( ~sys-apps/entropy-${PV} )
	sys-apps/file[python]"

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	emake DESTDIR="${D}" base-install || die "make base-install failed"
	if use entropy; then
		emake DESTDIR="${D}" entropysrv-install || die "make base-install failed"
	fi
}

pkg_postinst() {
	python_mod_optimize "/usr/lib/matter"
}

pkg_postrm() {
	python_mod_cleanup "/usr/lib/matter"
}
