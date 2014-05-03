# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
SUPPORT_PYTHON_ABIS="1"

inherit eutils distutils

DESCRIPTION="langtable is used to guess reasonable defaults for locale, keyboard layout, etc."
HOMEPAGE="https://github.com/mike-fabian/langtable"
SRC_URI="http://mfabian.fedorapeople.org/langtable/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_install() {
	distutils_src_install --install-data=/usr/share/langtable
	gzip --force --best "${D}/usr/share/langtable/"*.xml || die
}
