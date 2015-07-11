# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{3_3,3_4} )
inherit eutils cmake-utils python-r1

MY_AUTHOR="calamares"
DESCRIPTION="A Distribution-independent installer framework."
HOMEPAGE="http://${MY_AUTHOR}.io"
if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	SRC_URI=""
	EGIT_REPO_URI="git://github.com/${MY_AUTHOR}/${PN}.git
		       https://github.com/${MY_AUTHOR}/${PN}.git"
	KEYWORDS=""
else
	inherit git-r3
	SRC_URI=""
	EGIT_REPO_URI="git://github.com/${MY_AUTHOR}/${PN}.git
		       https://github.com/${MY_AUTHOR}/${PN}.git"
	EGIT_COMMIT=
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="+networkmanager +upower"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
DEPEND="${PYTHON_DEPS}
	sys-apps/dbus
	>=dev-qt/qtquick1-5.4.0:5
	>=dev-qt/linguist-tools-5.4.0:5
	>=dev-qt/qtconcurrent-5.4.0:5
	>=dev-qt/qtcore-5.4.0:5
	>=dev-qt/qtdbus-5.4.0:5
	>=dev-qt/qtgui-5.4.0:5
	>=dev-qt/qtsvg-5.4.0:5
	>=dev-qt/qtwidgets-5.4.0:5
	sys-auth/polkit-qt[qt5]
	>=dev-cpp/yaml-cpp-0.5.1
	>=dev-libs/boost-1.55[${PYTHON_USEDEP}]
	>=kde-frameworks/extra-cmake-modules-5.10.0:5
	sys-apps/dmidecode"

RDEPEND="${DEPEND}
	>=dev-libs/libatasmart-0.19
	>=kde-frameworks/kconfig-5.10.0:5
	>=kde-frameworks/ki18n-5.10.0:5
	>=kde-frameworks/kcoreaddons-5.10.0:5
	>=kde-frameworks/solid-5.10.0:5
	>=sys-block/parted-3.0
	>=sys-apps/gptfdisk-0.8.10
	sys-fs/udisks:2[systemd]
	virtual/udev[systemd]
	|| ( sys-boot/grub:2 sys-boot/gummiboot )
	sys-fs/squashfs-tools
	networkmanager? ( net-misc/networkmanager )
	upower? ( sys-power/upower )
	net-misc/rsync
	app-admin/sudo
	sys-boot/os-prober"

src_prepare() {
	python_setup
	export PYTHON_INCLUDE_DIRS="$(python_get_includedir)" \
	       PYTHON_INCLUDE_PATH="$(python_get_library_path)"\
	       PYTHON_CFLAGS="$(python_get_CFLAGS)"\
	       PYTHON_LIBS="$(python_get_LIBS)"
	export QT_SELECT=qt5
}

src_configure() {
	local mycmakeargs=( "-DWITH_PARTITIONMANAGER=1" )
	cmake-utils_src_configure
	sed -i -e 's:pkexec /usr/bin/calamares:calamares-pkexec:' "${S}"/calamares.desktop
	sed -i -e 's:Icon=calamares:Icon=drive-harddisk:' "${S}"/calamares.desktop
}

src_install() {
	cmake-utils_src_install
	dobin "${FILESDIR}"/calamares-pkexec
}
