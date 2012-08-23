# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/kmod/kmod-9-r3.ebuild,v 1.3 2012/07/22 17:24:06 armin76 Exp $

EAPI=4

EGIT_REPO_URI="git://git.kernel.org/pub/scm/utils/kernel/${PN}/${PN}.git"

[[ ${PV} == 9999 ]] && vcs=git-2
inherit ${vcs} autotools eutils toolchain-funcs libtool
unset vcs

if [[ ${PV} != 9999 ]] ; then
	SRC_URI="mirror://kernel/linux/utils/kernel/kmod/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
fi

DESCRIPTION="library and tools for managing linux kernel modules"
HOMEPAGE="http://git.kernel.org/?p=utils/kernel/kmod/kmod.git"

LICENSE="LGPL-2"
SLOT="0"
IUSE="+compat debug doc lzma static-libs +rootfs-install +tools zlib"

REQUIRED_USE="compat? ( tools )"

RDEPEND="tools? (
		!sys-apps/module-init-tools
		!sys-apps/modutils
	)
	lzma? ( app-arch/xz-utils )
	zlib? ( >=sys-libs/zlib-1.2.6 )" #427130
DEPEND="${RDEPEND}
	doc? ( dev-util/gtk-doc )
	lzma? ( virtual/pkgconfig )
	zlib? ( virtual/pkgconfig )"

# Upstream does not support running the test suite with custom configure flags.
# I was also told that the test suite is intended for kmod developers.
# So we have to restrict it.
# See bug #408915.
RESTRICT="test"

src_prepare()
{
	epatch ${FILESDIR}/${PN}-3-install-binaries-to-sbin.patch

	if [ ! -e configure ]; then
		if use doc; then
			gtkdocize --copy --docdir libkmod/docs || die
		else
			touch libkmod/docs/gtk-doc.make
		fi
	fi

	eautoreconf
}

src_configure()
{
	econf \
		$(use rootfs-install && echo --exec-prefix=/) \
		$(use_enable static-libs static) \
		$(use_enable tools) \
		$(use_enable debug) \
		$(use_enable doc gtk-doc) \
		$(use_with lzma xz) \
		$(use_with zlib)
}

src_install()
{
	default

	find "${D}" -name libkmod.la -delete

	if use rootfs-install ; then
		dodir /usr/$(get_libdir)
		# move pkg-config file and static libs to /usr
		if use static-libs ; then
			mv "${D}"/$(get_libdir)/*.a "${D}"/usr/$(get_libdir)/ || die
			gen_usr_ldscript libkmod.so
			sed -i -e 's:/lib:/usr/lib:' \
				"${D}"/$(get_libdir)/pkgconfig/*.pc || die
		fi
		mv "${D}"/$(get_libdir)/pkgconfig "${D}"/usr/$(get_libdir)/ || die
	fi

	# If the tools are installed, add compatibility symbolic links
	local prefix=/usr
	if use compat && use tools ; then
		use rootfs-install && prefix=
		dodir ${prefix}/bin
		dosym ../sbin/kmod ${prefix}/bin/lsmod
		local cmd
		for cmd in depmod insmod modinfo modprobe rmmod; do
			dosym kmod ${prefix}/sbin/$cmd
		done
	fi
}
