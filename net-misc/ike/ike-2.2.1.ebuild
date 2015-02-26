# Copyright 1999-2010 Gentoo Foundation
# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

CMAKE_IN_SOURCE_BUILD="1"
inherit cmake-utils linux-info systemd

DESCRIPTION="Shrew soft VPN Client"
HOMEPAGE="http://www.shrew.net/"
SRC_URI="http://www.shrew.net/download/${PN}/${P}-release.tbz2"

LICENSE="shrew"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ldap nat qt4 systemd"

COMMON_DEPEND="dev-libs/libedit
	dev-libs/openssl
	qt4? ( dev-qt/qtcore )
	ldap? ( net-nds/openldap )"

DEPEND="${COMMON_DEPEND}
	dev-util/cmake
	>=sys-devel/bison-2.3
	sys-devel/flex"

RDEPEND="${COMMON_DEPEND}"

#DOCS="CONTRIB.TXT README.TXT TODO.TXT"

CONFIG_CHECK="NET_KEY INET_XFRM_MODE_TRANSPORT INET_XFRM_MODE_TUNNEL"

S="${WORKDIR}/${PN}"

src_configure(){
	mycmakeargs+=( $(cmake-utils_use ldap LDAP)
		$(cmake-utils_use nat NATT)
		$(cmake-utils_use qt4 QTGUI)
		"-DMANDIR=/usr/share/man"
		"-DETCDIR=/etc/ike"
		)

	cmake-utils_src_configure
}

src_install(){
	if use systemd ; then
		systemd_dounit ${FILESDIR}/iked.service || die
	fi
}

pkg_postinst() {
        elog "a default configuration for the IKE Daemon"
        elog "is stored in /etc/iked.conf.sample"
}
