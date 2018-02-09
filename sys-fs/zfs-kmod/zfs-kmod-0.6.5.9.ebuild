# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

if [ ${PV} == "9999" ]; then
	AUTOTOOLS_AUTORECONF="1"
	EGIT_REPO_URI="https://github.com/zfsonlinux/zfs.git git://github.com/zfsonlinux/spl.git"
	inherit git-r3
else
	inherit eutils versionator
	MY_PV=$(replace_version_separator 4 '-')
	SRC_URI="https://github.com/zfsonlinux/zfs/releases/download/zfs-${PV}/zfs-${PV}.tar.gz
		 https://github.com/zfsonlinux/spl/archive/spl-${MY_PV}.tar.gz"
	S="${WORKDIR}"
	ZFS_S="${WORKDIR}/zfs-${MY_PV}"
	SPL_S="${WORKDIR}/spl-${MY_PV}"
	KEYWORDS="~amd64"
fi

inherit flag-o-matic linux-info linux-mod toolchain-funcs autotools-utils

DESCRIPTION="Linux ZFS kernel module for sys-fs/zfs"
HOMEPAGE="http://zfsonlinux.org/"

LICENSE="CDDL debug? ( GPL-2+ )"
SLOT="0"
IUSE="custom-cflags debug +rootfs"
RESTRICT="debug? ( strip ) test"

DEPEND="
	dev-lang/perl
	virtual/awk
"

RDEPEND="${DEPEND}
	!sys-fs/zfs-fuse
	!sys-kernel/spl
"

AT_M4DIR="config"
AUTOTOOLS_IN_SOURCE_BUILD="1"

pkg_setup() {
	linux-info_pkg_setup
	CONFIG_CHECK="!DEBUG_LOCK_ALLOC
		EFI_PARTITION
		IOSCHED_NOOP
		MODULES
		!PAX_KERNEXEC_PLUGIN_METHOD_OR
		ZLIB_DEFLATE
		ZLIB_INFLATE
	"

	use debug && CONFIG_CHECK="${CONFIG_CHECK}
		FRAME_POINTER
		DEBUG_INFO
		!DEBUG_INFO_REDUCED
	"

	use rootfs && \
		CONFIG_CHECK="${CONFIG_CHECK}
			BLK_DEV_INITRD
			DEVTMPFS
	"

	kernel_is ge 2 6 32 || die "Linux 2.6.32 or newer required"

	[ ${PV} != "9999" ] && \
		{ kernel_is le 4 9 || die "Linux 4.9 is the latest supported version."; }

	check_extra_config
}

src_prepare() {
	# Remove GPLv2-licensed ZPIOS unless we are debugging
	use debug || sed -e 's/^subdir-m += zpios$//' -i "${ZFS_S}/module/Makefile.in"

	local d
	for d in "${ZFS_S}" "${SPL_S}"; do
		pushd "${d}"
		S="${d}" BUILD_DIR="${d}" autotools-utils_src_prepare
		unset AUTOTOOLS_BUILD_DIR
		popd
	done
	# Set module revision number
	[ ${PV} != "9999" ] && \
		{ sed -i "s/\(Release:\)\(.*\)1/\1\2${PR}-gentoo/" "${ZFS_S}/META" || die "Could not set Gentoo release"; }

	autotools-utils_src_prepare
}

src_configure() {
	use custom-cflags || strip-flags
	filter-ldflags -Wl,*

	set_arch_to_kernel

	einfo "Configuring SPL..."
	local myeconfargs=(
		--bindir="${EPREFIX}/bin"
		--sbindir="${EPREFIX}/sbin"
		--with-config=all
		--with-linux="${KV_DIR}"
		--with-linux-obj="${KV_OUT_DIR}"
		$(use_enable debug)
	)
	pushd "${SPL_S}"
	BUILD_DIR="${SPL_S}" ECONF_SOURCE="${SPL_S}" autotools-utils_src_configure
	unset AUTOTOOLS_BUILD_DIR
	popd

	einfo "Configuring ZFS..."

	local myeconfargs=(${myeconfargs}
		--bindir="${EPREFIX}/bin"
		--sbindir="${EPREFIX}/sbin"
		--with-config=kernel
		--with-linux="${KV_DIR}"
		--with-linux-obj="${KV_OUT_DIR}"
		--with-spl="${SPL_S}"
		$(use_enable debug)
	)
	pushd "${ZFS_S}"
	BUILD_DIR="${ZFS_S}" ECONF_SOURCE="${ZFS_S}" autotools-utils_src_configure
	unset AUTOTOOLS_BUILD_DIR
	popd
}

src_compile() {
	einfo "Compiling SPL..."
	pushd "${SPL_S}"
	BUILD_DIR="${SPL_S}" ECONF_SOURCE="${SPL_S}" autotools-utils_src_compile
	unset AUTOTOOLS_BUILD_DIR
	popd

	einfo "Compiling ZFS..."
	pushd "${ZFS_S}"
	BUILD_DIR="${ZFS_S}" ECONF_SOURCE="${ZFS_S}" autotools-utils_src_compile
	unset AUTOTOOLS_BUILD_DIR
	popd
}

src_install() {
	DOCS=( AUTHORS DISCLAIMER )
	pushd "${SPL_S}"
	BUILD_DIR="${SPL_S}" ECONF_SOURCE="${SPL_S}" autotools-utils_src_install INSTALL_MOD_PATH="${INSTALL_MOD_PATH:-$EROOT}"
	unset AUTOTOOLS_BUILD_DIR
	unset DOCS
	popd

	DOCS=( AUTHORS COPYRIGHT DISCLAIMER README.markdown )
	pushd "${ZFS_S}"
	BUILD_DIR="${ZFS_S}" ECONF_SOURCE="${ZFS_S}" autotools-utils_src_install INSTALL_MOD_PATH="${INSTALL_MOD_PATH:-$EROOT}"
	unset AUTOTOOLS_BUILD_DIR
	unset DOCS
	popd
}

pkg_postinst() {
	linux-mod_pkg_postinst

	# Remove old modules
	if [ -d "${EROOT}lib/modules/${KV_FULL}/addon/zfs" ]
	then
		ewarn "${PN} now installs modules in ${EROOT}lib/modules/${KV_FULL}/extra/zfs"
		ewarn "Old modules were detected in ${EROOT}lib/modules/${KV_FULL}/addon/zfs"
		ewarn "Automatically removing old modules to avoid problems."
		rm -r "${EROOT}lib/modules/${KV_FULL}/addon/zfs" || die "Cannot remove modules"
		rmdir --ignore-fail-on-non-empty "${EROOT}lib/modules/${KV_FULL}/addon"
	fi

	if use x86 || use arm
	then
		ewarn "32-bit kernels will likely require increasing vmalloc to"
		ewarn "at least 256M and decreasing zfs_arc_max to some value less than that."
	fi

	ewarn "This version of ZFSOnLinux includes support for new feature flags"
	ewarn "that are incompatible with previous versions. GRUB2 support for"
	ewarn "/boot with the new feature flags is not yet available."
	ewarn "Do *NOT* upgrade root pools to use the new feature flags."
	ewarn "Any new pools will be created with the new feature flags by default"
	ewarn "and will not be compatible with older versions of ZFSOnLinux. To"
	ewarn "create a newpool that is backward compatible wih GRUB2, use "
	ewarn
	ewarn "zpool create -d -o feature@async_destroy=enabled "
	ewarn "	-o feature@empty_bpobj=enabled -o feature@lz4_compress=enabled"
	ewarn "	-o feature@spacemap_histogram=enabled"
	ewarn "	-o feature@enabled_txg=enabled "
	ewarn "	-o feature@extensible_dataset=enabled -o feature@bookmarks=enabled"
	ewarn "	..."
	ewarn
	ewarn "GRUB2 support will be updated as soon as either the GRUB2"
	ewarn "developers do a tag or the Gentoo developers find time to backport"
	ewarn "support from GRUB2 HEAD."
}
