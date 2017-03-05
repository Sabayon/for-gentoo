# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit base eutils autotools

DESCRIPTION="library for manipulating and storing storage volume encryption keys"
HOMEPAGE="https://fedorahosted.org/volume_key/"
SRC_URI="https://fedorahosted.org/releases/v/o/${PN}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

COMMON_DEPEND="
	dev-libs/glib:2
	dev-libs/nss
	sys-devel/gettext
"
DEPEND="${COMMON_DEPEND}
	app-crypt/gpgme
	sys-apps/util-linux
	sys-fs/cryptsetup
	sys-devel/gettext
	sys-devel/autoconf:2.63
	"
RDEPEND="${COMMON_DEPEND}
	dev-libs/glib
	sys-apps/util-linux"

PATCHES=( "${FILESDIR}"/volume_key-0.3.9-config.h.diff )

src_prepare() {
	epatch_user
	eautoreconf
	base_src_prepare
}
