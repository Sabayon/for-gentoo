# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

QT_MINIMAL="5.6.0"
PYTHON_COMPAT=( python{3_4,3_5} )
inherit kde5 python-r1 eutils

DESCRIPTION="Distribution-independent installer framework"
HOMEPAGE="http://calamares.io"
if [[ ${KDE_BUILD_TYPE} == live ]] ; then
	EGIT_REPO_URI="git://github.com/${PN}/${PN}"
	KEYWORDS=""
else
	SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3"
IUSE="+networkmanager +upower +fat jfs reiserfs xfs ntfs"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep solid)
	$(add_frameworks_dep extra-cmake-modules)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kservice)
	$(add_qt_dep linguist-tools)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtquick1)
	$(add_qt_dep qtsvg)
	$(add_qt_dep qtwebengine 'widgets')
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtconcurrent)
	$(add_qt_dep qtwebkit)
	>=dev-cpp/yaml-cpp-0.5.1
	>=dev-libs/boost-1.55:=[${PYTHON_USEDEP}]
	sys-apps/dbus
	sys-apps/dmidecode
	sys-auth/polkit-qt[qt5]
	>=sys-libs/kpmcore-2.1.0:5
"

RDEPEND="${DEPEND}
	app-admin/sudo
	dev-libs/libatasmart
	net-misc/rsync
	>=sys-apps/gptfdisk-1.0.1
	>=sys-block/parted-3.0
	sys-boot/grub:2
	sys-boot/os-prober
	sys-fs/squashfs-tools
	sys-fs/udisks:2[systemd]
	virtual/udev[systemd]
	>=sys-fs/e2fsprogs-1.42.13
	networkmanager? ( net-misc/networkmanager )
	upower? ( sys-power/upower )
	fat? ( sys-fs/dosfstools )
	jfs? ( sys-fs/jfsutils )
	reiserfs? ( sys-fs/reiserfsprogs )
	xfs? (
	       sys-fs/xfsprogs
	       sys-fs/xfsdump
	)
	ntfs? ( sys-fs/ntfs3g[ntfsprogs] )
"

src_prepare() {
	python_setup
	export PYTHON_INCLUDE_DIRS="$(python_get_includedir)" \
	       PYTHON_INCLUDE_PATH="$(python_get_library_path)"\
	       PYTHON_CFLAGS="$(python_get_CFLAGS)"\
	       PYTHON_LIBS="$(python_get_LIBS)"

	eapply_user
	export QT_SELECT=qt5
}

src_configure() {
	local mycmakeargs=( "-DWITH_PARTITIONMANAGER=1" )
	kde5_src_configure
	sed -i -e 's:pkexec /usr/bin/calamares:calamares-pkexec:' "${S}"/calamares.desktop
	sed -i -e 's:Icon=calamares:Icon=drive-harddisk:' "${S}"/calamares.desktop
}

src_install() {
	kde5_src_install
	dobin "${FILESDIR}"/calamares-pkexec
}
