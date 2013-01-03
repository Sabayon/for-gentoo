# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit multilib qt4-r2

MY_PN="RetroShare"
MY_P="${MY_PN}-v${PV}"

DESCRIPTION="P2P private sharing application"
HOMEPAGE="http://retroshare.sourceforge.net"
SRC_URI="mirror://sourceforge/retroshare/${MY_P}.tar.gz"

LICENSE="GPL-2 Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cli X links-cloud voip"

RDEPEND="
	dev-libs/openssl:0
	gnome-base/libgnome-keyring
	net-libs/libupnp
	x11-libs/qt-core:4
	X? (
		x11-libs/libXScrnSaver
		x11-libs/qt-gui:4
	)
	voip? (
		media-libs/speex
		x11-libs/qt-mobility[multimedia]
		x11-libs/qt-multimedia
	)"
DEPEND="${RDEPEND}"

REQUIRED_USE="|| ( cli X ) links-cloud? ( X ) voip? ( X )"

S="${WORKDIR}/trunk"

src_prepare()
{
	sed -i -e \
		"s|/usr/lib/retroshare/extensions/|/usr/$(get_libdir)/${PN}/extensions/|" \
		libretroshare/src/rsserver/rsinit.cc \
		|| die "sed failed"

	rs_src_dirs="libbitdht/src openpgpsdk/src libretroshare/src"
	use cli && rs_src_dirs="${rs_src_dirs} retroshare-nogui/src"
	use X && rs_src_dirs="${rs_src_dirs} retroshare-gui/src"
	use links-cloud && rs_src_dirs="${rs_src_dirs} plugins/LinksCloud"

	if use voip
	then
		rs_src_dirs="${rs_src_dirs} plugins/VOIP"
		echo "QT += multimedia mobility" >> "plugins/VOIP/VOIP.pro" || die
	fi

	local dir
	for dir in ${rs_src_dirs}
	do
		cd "${S}/${dir}" || die
		eqmake4
	done
}

src_compile()
{
	local dir
	for dir in ${rs_src_dirs}
	do
		einfo "entering ${dir}..."
		cd "${S}/${dir}" || die
		emake
	done
}

src_install()
{
	use cli && dobin retroshare-nogui/src/retroshare-nogui
	use X && dobin retroshare-gui/src/RetroShare

	local extension_dir="/usr/$(get_libdir)/${PN}/extensions/"
	if use links-cloud ; then
		mkdir -p "${D}${extension_dir}" || die
		cp -pP "${S}"/plugins/LinksCloud/*.so* "${D}${extension_dir}" || die
	fi
	if use voip ; then
		mkdir -p "${D}${extension_dir}" || die
		cp -pP "${S}"/plugins/VOIP/*.so* "${D}${extension_dir}" || die
	fi

	insinto /usr/share/${PN}
	doins "${S}/libbitdht/src/bitdht/bdboot.txt"
}

pkg_postinst()
{
	use X && einfo "The GUI executable name is: RetroShare"
	use cli && einfo "The console executable name is: retroshare-cli"
	# elog "$(shasum ${extension_dir}/*.so)"
}
