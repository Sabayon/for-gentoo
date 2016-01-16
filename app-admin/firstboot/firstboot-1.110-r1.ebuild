# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_6 python2_7 )

inherit python-r1 distutils-r1 rpm

# Revision of the RPM. Shouldn't affect us, as we're just grabbing the source
# tarball out of it
RPMREV="1"

DESCRIPTION="Initial system configuration utility"
HOMEPAGE="http://fedoraproject.org/wiki/FirstBoot"
SRC_URI="mirror://sabayon/${CATEGORY}/${P}-${RPMREV}.fc13.src.rpm"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="gtk"
RDEPEND="
	gtk? ( =dev-python/pygtk-2* )
	dev-python/rhpl
	app-admin/system-config-users
	app-admin/system-config-date
	sys-libs/libuser
	dev-python/python-ethtool"
DEPEND="${RDEPEND}
	sys-devel/gettext"
PDEPEND="app-admin/system-config-keyboard"

src_install() {
	distutils-r1_src_install
	# remove fedorish init script completely
	rm -r "${ED}"/etc/rc.d || die
}

pkg_postrm() {
	python_mod_cleanup /usr/share/${PN}
}

