# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils linux-info multilib toolchain-funcs

MY_PN="pgl"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Privacy oriented firewall application"
HOMEPAGE="http://methlabs.org/"
SRC_URI="mirror://sourceforge/peerguardian/${MY_P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="dbus debug networkmanager qt4"

COMMON_DEPEND="
	net-libs/libnetfilter_queue
	net-libs/libnfnetlink
	dbus? ( sys-apps/dbus )
	sys-libs/zlib
	qt4? ( x11-libs/qt-core
		x11-libs/qt-dbus
		x11-libs/qt-gui )"
DEPEND="${COMMON_DEPEND}
	dev-util/pkgconfig"
RDEPEND="${COMMON_DEPEND}
	net-firewall/iptables
	networkmanager? ( net-misc/networkmanager )"

CONFIG_CHECK="~NETFILTER_NETLINK_QUEUE"

S=${WORKDIR}/${MY_P}

src_prepare() {
	# various makefile patches
	epatch "${FILESDIR}"/${MY_P}-makefile.patch

	# multilib support
	sed -i -e "s#@LIB@#$(get_libdir)#" \
		pgl-gui/Makefile || die
}

src_configure() {
	# set build-time options
	use dbus && DBUS=yes || DBUS=no
	use qt4 && QT4=yes || QT4=no
	use debug && DEBUG=yes || DEBUG=no
}

src_compile() {
	# make pglinux
	emake CC=$(tc-getCC) CXX=$(tc-getCXX) \
		LIBDIR=/usr/$(get_libdir)/${MY_PN} TMPDIR=/tmp \
		DBUS=${DBUS} MAKE_PGLGUI=${QT4} DEBUG=${DEBUG}
}

src_install() {
	# install pglinux
	emake DESTDIR="${D}" LIBDIR=usr/$(get_libdir)/${MY_PN} \
		PLUGINDIR=usr/$(get_libdir)/${MY_PN} \
		DBUS=${DBUS} MAKE_PGLGUI=${QT4} DEBUG=${DEBUG} install

	# install docs and manpage
	dodoc ChangeLog docs/{README*,BUGS,AUTHORS}
	newman docs/pgld.1 pglinux.1
	dosym pglinux.1 /usr/share/man/man1/pgl.1

	# optional networkmanager support 
	if ! use networkmanager ; then
		rm -r "${D}"/etc/NetworkManager || die
	fi
}
