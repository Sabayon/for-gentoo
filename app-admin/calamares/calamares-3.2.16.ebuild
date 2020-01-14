# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )
inherit ecm python-r1

DESCRIPTION="Distribution-independent installer framework"
HOMEPAGE="https://calamares.io"
if [[ ${KDE_BUILD_TYPE} == live ]] ; then
	EGIT_REPO_URI="https://github.com/${PN}/${PN}"
else
	SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="~amd64"
fi
SLOT=5
LICENSE="GPL-3"
IUSE="+networkmanager +upower +fat jfs reiserfs xfs ntfs pythonqt"

DEPEND="${PYTHON_DEPS}
	dev-qt/linguist-tools:5
	dev-qt/qtconcurrent:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsvg:5
	dev-qt/qtwebengine:5[widgets]
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	kde-frameworks/kconfig:5
	kde-frameworks/kcoreaddons:5
	kde-frameworks/kcrash:5
	kde-frameworks/kpackage:5
	kde-frameworks/kparts:5
	kde-frameworks/kservice:5
	dev-cpp/yaml-cpp:=
	>=dev-libs/boost-1.55:=[${PYTHON_USEDEP}]
	dev-libs/libpwquality[${PYTHON_USEDEP}]
	sys-apps/dbus
	sys-apps/dmidecode
	sys-auth/polkit-qt
	>=sys-libs/kpmcore-4.0.0:5=
	pythonqt? ( >=dev-python/PythonQt-3.1:=[${PYTHON_USEDEP}] )
"

RDEPEND="${DEPEND}
	app-admin/sudo
	dev-libs/libatasmart
	net-misc/rsync
	>=sys-block/parted-3.0
	|| ( sys-boot/grub:2 sys-boot/systemd-boot )
	sys-boot/os-prober
	sys-fs/squashfs-tools
	sys-libs/timezone-data
	virtual/udev
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
	ecm_src_prepare
	python_setup
	export PYTHON_INCLUDE_DIRS="$(python_get_includedir)" \
		PYTHON_INCLUDE_PATH="$(python_get_library_path)" \
		PYTHON_CFLAGS="$(python_get_CFLAGS)" \
		PYTHON_LIBS="$(python_get_LIBS)"

	sed -i -e 's:pkexec /usr/bin/calamares:calamares-pkexec:' \
		calamares.desktop || die
	sed -i -e 's:Icon=calamares:Icon=drive-harddisk:' \
		calamares.desktop || die
}

src_configure() {
	local mycmakeargs=(
		-DWEBVIEW_FORCE_WEBKIT=OFF
		-DCMAKE_DISABLE_FIND_PACKAGE_LIBPARTED=ON
		-DWITH_PYTHONQT=$(usex pythonqt)
	)

	ecm_src_configure
}

src_install() {
	ecm_src_install
	dobin "${FILESDIR}"/calamares-pkexec
}
