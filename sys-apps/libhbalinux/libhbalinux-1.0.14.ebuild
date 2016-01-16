# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils autotools

DESCRIPTION="SNIA HBAAPI vendor library built on top of the scsi_transport_fc interfaces."
HOMEPAGE="http://www.open-fcoe.org"
SRC_URI="mirror://sabayon/${CATEGORY}/${P}.tar.gz"

LICENSE="SNIA"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="sys-apps/hbaapi
	x11-libs/libpciaccess"

src_prepare() {
	epatch "${FILESDIR}/${PN}-1.0.13-conf.patch"
	epatch "${FILESDIR}/${P}-archiver.patch"
	eautoreconf
}

src_configure() {
	econf --disable-static || die
}

src_install() {
	emake DESTDIR="${D}" install
}
