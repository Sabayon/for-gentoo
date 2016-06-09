# Copyright 2004-2016 Sabayon
# Distributed under the terms of the GNU General Public License v2
# $

EAPI=5
inherit autotools eutils

DESCRIPTION="Implements a standardized interface for manipulating and administering user and group accounts"
HOMEPAGE="https://fedorahosted.org/libuser"
SRC_URI="https://fedorahosted.org/releases/l/i/${PN}/${P}.tar.xz"
RESTRICT=nomirror

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="ldap +popt sasl selinux"
COMMON_DEPEND="dev-libs/glib:2
	ldap? ( net-nds/openldap )
	popt? ( dev-libs/popt )
	sasl? ( dev-libs/cyrus-sasl )
	selinux? ( sys-libs/libselinux )"
DEPEND="app-text/linuxdoc-tools
	sys-devel/bison
	sys-devel/gettext
	${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

src_prepare() {
	mv apps/{,libuser-}lid.1 || die
	sed -i 's: apps/lid\.1 : apps/libuser-lid.1 :' \
		Makefile.am || die
	eautoreconf
}

src_configure() {
	econf $(use_with ldap) $(use_with popt) $(use_with sasl) \
		$(use_with selinux) --with-python
}
