# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils versionator

MY_PV=$(replace_version_separator 3 '-')
MY_PN="davmail"

DESCRIPTION="POP/IMAP/SMTP/Caldav/Carddav/LDAP Exchange Gateway"
HOMEPAGE="http://davmail.sourceforge.net/"
SRC_URI="x86? ( mirror://sourceforge/${MY_PN}/${MY_PN}-linux-x86-${MY_PV}.tgz )
	 amd64? ( mirror://sourceforge/${MY_PN}/${MY_PN}-linux-x86_64-${MY_PV}.tgz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

DEPEND=">=virtual/jre-1.6"
RDEPEND="${DEPEND}
	dev-java/swt
"

use x86 && S="${WORKDIR}/${MY_PN}-linux-x86-${MY_PV}"
use amd64 && S="${WORKDIR}/${MY_PN}-linux-x86_64-${MY_PV}"

src_install() {
	cd "${S}"

	# Fix the script BASE=
	sed -i -e "s@BASE=.*@BASE=/opt/davmail@" davmail.sh

	dodir "/opt/${PN}"
	cp -a * "${D}/opt/${PN}"

	dodir "/opt/bin"
	dosym "/opt/${PN}/davmail.sh" "/opt/bin/davmail.sh"

	domenu "${FILESDIR}"/davmail.desktop
	doicon "${FILESDIR}"/davmail.png
}
