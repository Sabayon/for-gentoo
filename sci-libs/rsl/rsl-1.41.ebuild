# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils autotools

MY_P="${PN}-v${PV}"

DESCRIPTION="Radar Software Library"
HOMEPAGE="http://trmm-fc.gsfc.nasa.gov/trmm_gv/software/rsl/index.html"
SRC_URI="ftp://trmm-fc.gsfc.nasa.gov/software/${MY_P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sci-libs/hdf
	virtual/jpeg"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-automake.patch"
	eautoreconf
}
