# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/btrfs-progs/btrfs-progs-9999.ebuild,v 1.15 2011/10/29 05:17:45 slyfox Exp $

EAPI="4"

inherit eutils git-2

DESCRIPTION="Btrfs filesystem utilities"
HOMEPAGE="http://btrfs.wiki.kernel.org/"
SRC_URI=""


LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc64 ~x86"
IUSE="acl debug-utils"

DEPEND="debug-utils? ( dev-python/matplotlib )
	acl? (
			sys-apps/acl
			sys-fs/e2fsprogs
	)"
RDEPEND="${DEPEND}"

EGIT_REPO_URI="git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git"
EGIT_COMMIT="1957076ab4fefa47b6efed3da541bc974c83eed7"

src_unpack() {
	git-2_src_unpack
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-Modify-Makefile-to-allow-optional-ACL-dependency.patch

	# See Sabayon ML -- DO NOT DROP THIS !!!!!!!!!!!!!!!!!!
	# DO NOT DROP THIS !!!!!!!!!!!!!!
	# DO NOT DROP THIS !!!!!!!!!!!!!!
	# DO NOT DROP THIS !!!!!!!!!!!!!!
	# DO NOT DROP THIS !!!!!!!!!!!!!!
	# http://lists.sabayon.org/pipermail/devel/2011-October/007155.html
	epatch "${FILESDIR}"/0002-btrfs-progs-ignore-unavailable-loop-device-source-files.patch
	# DO NOT DROP THIS !!!!!!!!!!!!!!
	# DO NOT DROP THIS !!!!!!!!!!!!!!
	# DO NOT DROP THIS !!!!!!!!!!!!!!
	# DO NOT DROP THIS !!!!!!!!!!!!!!

	# Fix hardcoded "gcc" and "make"
	sed -i -e 's:gcc $(CFLAGS):$(CC) $(CFLAGS):' Makefile
	sed -i -e 's:make:$(MAKE):' Makefile
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" \
		all || die
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" \
		btrfs-image || die
	if use acl; then
		emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" \
			btrfs-convert || die
	fi
}

src_install() {
	emake mandir="/usr/share/man" bindir="/sbin" install DESTDIR="${D}"

	# fsck will segfault if invoked at boot, so do not make this link
	#dosym btrfsck /sbin/fsck.btrfs

	# newsbin mkfs.btrfs mkbtrfs

	dosym mkfs.btrfs /sbin/mkbtrfs
	if ! use acl; then
		ewarn "Note: btrfs-convert not built/installed (requires acl USE flag)"
	fi

	into /usr
	newbin bcp btrfs-bcp

	if use debug-utils; then
		newbin show-blocks btrfs-show-blocks
	else
		ewarn "Note: btrfs-show-blocks not installed (requires debug-utils USE flag)"
	fi

	dodoc INSTALL
	# emake prefix="${D}/usr/share" install-man
}

pkg_postinst() {
	ewarn "WARNING: This version of btrfs-progs uses the latest unstable code,"
	ewarn "         and care should be taken that it is compatible with the"
	ewarn "         version of btrfs in your kernel!"
}
