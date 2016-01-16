# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/btrfs-progs/btrfs-progs-9999.ebuild,v 1.15 2011/10/29 05:17:45 slyfox Exp $

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
EGIT_COMMIT="fdb6c0402337d9607c7a39155088eaf033742752"

src_unpack() {
	git-2_src_unpack
	cd "${S}"

	# Fix hardcoded "gcc" and "make"
	sed -i -e 's:gcc $(CFLAGS):$(CC) $(CFLAGS):' Makefile
	sed -i -e 's:make:$(MAKE):' Makefile
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" \
		all || die
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" \
		btrfstune btrfs-image || die
	if use acl; then
		emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" \
			convert || die
	fi
}

src_install() {
	into /
	dosbin btrfs-show
	dosbin btrfs-vol
	dosbin btrfsctl
	dosbin btrfsck
	dosbin btrfstune
	dosbin btrfs-image
	dosbin btrfs
	dosbin restore
	dosbin find-root
	dosbin calc-size
	dobin btrfs-debug-tree
	# fsck will segfault if invoked at boot, so do not make this link
	#dosym btrfsck /sbin/fsck.btrfs
	newsbin mkfs.btrfs mkbtrfs
	dosym mkbtrfs /sbin/mkfs.btrfs
	if use acl; then
		dosbin btrfs-convert
	else
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
	emake prefix="${D}/usr/share" install-man
}

pkg_postinst() {
	ewarn "WARNING: This version of btrfs-progs uses the latest unstable code,"
	ewarn "         and care should be taken that it is compatible with the"
	ewarn "         version of btrfs in your kernel!"
}
