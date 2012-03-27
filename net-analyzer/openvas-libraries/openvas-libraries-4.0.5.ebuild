# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/openvas-libraries/openvas-libraries-4.0.5.ebuild,v 1.1 2011/10/09 17:13:53 hanno Exp $

EAPI=4

inherit cmake-utils

DESCRIPTION="A remote security scanner for Linux (openvas-libraries)"
HOMEPAGE="http://www.openvas.org/"
SRC_URI="http://wald.intevation.org/frs/download.php/872/${P}.tar.gz"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.12
	net-libs/gnutls
	net-libs/libpcap
	app-crypt/gpgme
	!net-analyzer/openvas-libnasl"
DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex
	dev-util/pkgconfig
	dev-util/cmake"

# Workaround for upstream bug, it doesn't like out-of-tree builds.
CMAKE_BUILD_DIR="${S}"

src_configure() {
	local mycmakeargs="-DIGNORE_UNPROTOTYPED_CALLS=1 -DLOCALSTATEDIR=/var -DSYSCONFDIR=/etc"
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	dodoc ChangeLog CHANGES README || die "dodoc failed"
	keepdir /var/cache/openvas/
}
