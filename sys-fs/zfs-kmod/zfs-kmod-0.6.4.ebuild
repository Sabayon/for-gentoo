# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

AT_M4DIR="config"
AUTOTOOLS_AUTORECONF="1"
AUTOTOOLS_IN_SOURCE_BUILD="1"

inherit bash-completion-r1 flag-o-matic linux-info linux-mod toolchain-funcs autotools-utils

if [ ${PV} == "9999" ] ; then
	inherit git-2
	MY_PV=9999
	EGIT_REPO_URI="git://github.com/zfsonlinux/zfs.git git://github.com/zfsonlinux/spl.git"
else
	inherit eutils versionator
	MY_PV=$(replace_version_separator 3 '-')
	SRC_URI="https://github.com/zfsonlinux/zfs/archive/zfs-${MY_PV}.tar.gz
		https://github.com/zfsonlinux/spl/archive/spl-${MY_PV}.tar.gz"
	S="${WORKDIR}"
	ZFS_S="${WORKDIR}/zfs-zfs-${MY_PV}"
	SPL_S="${WORKDIR}/spl-spl-${MY_PV}"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Solaris Porting Layer and Linux ZFS kernel modules"
HOMEPAGE="http://zfsonlinux.org/"

LICENSE="CDDL debug? ( GPL-2+ )"
SLOT="0"
IUSE="custom-cflags debug debug-log +rootfs"
RESTRICT="debug? ( strip ) test"

DEPEND="dev-lang/perl
	virtual/awk
"

RDEPEND="${DEPEND}
	!sys-fs/zfs-fuse
	!sys-kernel/spl
"

pkg_setup() {
	linux-info_pkg_setup
	CONFIG_CHECK="!DEBUG_LOCK_ALLOC
		!GRKERNSEC_HIDESYM
		BLK_DEV_LOOP
		EFI_PARTITION
		IOSCHED_NOOP
		KALLSYMS
		MODULES
		!PAX_KERNEXEC_PLUGIN_METHOD_OR
		!PAX_USERCOPY_SLABS
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
			DEVTMPFS"

	kernel_is ge 2 6 26 || die "Linux 2.6.26 or newer required"

	[ ${PV} != "9999" ] && \
		{ kernel_is le 4 0 || die "Linux 4.0 is the latest supported version."; }

	check_extra_config
}

src_prepare() {
	# Remove GPLv2-licensed ZPIOS unless we are debugging
	use debug || sed -e 's/^subdir-m += zpios$//' -i "${S}/module/Makefile.in"
	# Workaround for hard coded path
	sed -i "s|/sbin/lsmod|/bin/lsmod|" "${SPL_S}"/scripts/check.sh || die

	# splat is unnecessary unless we are debugging
	use debug || sed -e 's/^subdir-m += splat$//' -i "${SPL_S}/module/Makefile.in"

	local d
	for d in "${ZFS_S}" "${SPL_S}"; do
		pushd "${d}"
		S="${d}" BUILD_DIR="${d}" autotools-utils_src_prepare
		unset AUTOTOOLS_BUILD_DIR
		popd
	done
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
		$(use_enable debug-log)
	)
	pushd "${SPL_S}"
	BUILD_DIR="${SPL_S}" ECONF_SOURCE="${SPL_S}" autotools-utils_src_configure
	unset AUTOTOOLS_BUILD_DIR
	popd

	einfo "Configuring ZFS..."
	local myeconfargs=(
		--bindir="${EPREFIX}/bin"
		--sbindir="${EPREFIX}/sbin"
		--with-config=kernel
		--with-linux="${KV_DIR}"
		--with-linux-obj="${KV_OUT_DIR}"
		--with-spl="${SPL_S}"
#		--with-spl-obj="${KV_OUT_DIR}"
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
	pushd "${SPL_S}"
	BUILD_DIR="${SPL_S}" ECONF_SOURCE="${SPL_S}" autotools-utils_src_install
	unset AUTOTOOLS_BUILD_DIR
	popd

	pushd "${ZFS_S}"
	BUILD_DIR="${ZFS_S}" ECONF_SOURCE="${ZFS_S}" autotools-utils_src_install
	unset AUTOTOOLS_BUILD_DIR
	dodoc "${ZFS_S}"/AUTHORS "${ZFS_S}"/COPYRIGHT "${ZFS_S}"/DISCLAIMER "${ZFS_S}"/README.markdown
	popd
}

pkg_postinst() {
	linux-mod_pkg_postinst

	if use x86 || use arm
	then
		ewarn "32-bit kernels will likely require increasing vmalloc to"
		ewarn "at least 256M and decreasing zfs_arc_max to some value less than that."
	fi

	ewarn "This version of ZFSOnLinux includes support for features flags."
	ewarn "If you upgrade your pools to make use of feature flags, you will lose"
	ewarn "the ability to import them using older versions of ZFSOnLinux."
	ewarn "Any new pools will be created with feature flag support and will"
	ewarn "not be compatible with older versions of ZFSOnLinux. To create a new"
	ewarn "pool that is backward compatible, use zpool create -o version=28 ..."
}
