# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=1

inherit eutils multilib
RESTRICT="mirror"

DESCRIPTION="Successor for freebob: Library for accessing BeBoB IEEE1394 devices"
HOMEPAGE="http://www.ffado.org"
SRC_URI="http://www.ffado.org/files/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="debug optimization qt4"

RDEPEND=">=media-libs/alsa-lib-1.0.0
	>=dev-cpp/libxmlpp-2.13.0
	>=sys-libs/libraw1394-1.3.0
	>=media-libs/libiec61883-1.1.0
	>=sys-libs/libavc1394-0.5.3
	>=sys-apps/dbus-1.0
	qt4? (
		dev-python/dbus-python
		dev-python/PyQt4
		dev-qt/qtcore
		dev-qt/qtgui )"

DEPEND="${RDEPEND}
	dev-util/scons"

src_compile () {
	local myconf="DEBUG=$(usex debug True False)"
	use debug \
		&& myconf+=" ENABLE_OPTIMIZATIONS=False" \
		|| myconf+=" ENABLE_OPTIMIZATIONS=$(usex optimization True False)"

	scons \
		PREFIX=/usr \
		LIBDIR=/usr/$(get_libdir) \
		${myconf} || die
}

src_install () {
	scons DESTDIR="${D}" WILL_DEAL_WITH_XDG_MYSELF="True" install || die
	dodoc AUTHORS ChangeLog README

	if use qt4; then
		newicon "support/xdg/hi64-apps-ffado.png" "ffado.png"
		newmenu "support/xdg/ffado.org-ffadomixer.desktop" "ffado-mixer.desktop"
	fi
}

pkg_postinst() {
	ewarn "Important: This version of FFADO works on the new firewire-stack,"
	ewarn "and no longer needs the raw1394/ohci1394/ieee1394 modules."
}
