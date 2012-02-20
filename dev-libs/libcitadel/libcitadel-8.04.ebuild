# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit flag-o-matic

DESCRIPTION="Code shared across all the components of a Citadel system"
HOMEPAGE="http://citadel.org/"
SRC_URI="http://easyinstall.citadel.org/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/expat
	dev-libs/libical
	net-misc/curl
	mail-filter/libsieve
	sys-libs/db
	sys-libs/zlib"
RDEPEND="${DEPEND}"

src_configure() {
	filter-flags -finline-functions
	replace-flags -O3 -O2
	default
}
