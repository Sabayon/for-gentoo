# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

# Build type
BUILD="autotools"

inherit eutils flag-o-matic toolchain-funcs mysql-v2

SRC_URI="mirror://sabayon/dev-db/${P}.tar.gz"

# only to make repoman happy. it is really set in the eclass
IUSE="$IUSE"

# REMEMBER: also update eclass/mysql*.eclass before committing!
KEYWORDS="~amd64 ~x86"

# When MY_EXTRAS is bumped, the index should be revised to exclude these.
# This is often broken still
EPATCH_EXCLUDE=''

# Most of these are in the eclass
DEPEND="|| ( >=sys-devel/gcc-3.4.6 >=sys-devel/gcc-apple-4.0 )
		>=sys-devel/libtool-2.2.10"
RDEPEND="${RDEPEND}"

# TODO:
# - unbundle google-perftools (XXX broken build system?)
# - merge mysql-autotools eclass upstream (ping mysql herd)
# - merge google-mysql upstream

# Please do not add a naive src_unpack to this ebuild
# If you want to add a single patch, copy the ebuild to an overlay
# and create your own mysql-extras tarball, looking at 000_index.txt
src_prepare() {
	# fix braindamaged eclass, _mysql_test_patch_ver_pn
	mkdir -p "${WORKDIR}/mysql-extras" || die

	sed -i \
		-e '/^noinst_PROGRAMS/s/basic-t//g' \
		"${S}"/unittest/mytap/t/Makefile.am

	# Filter out -fomit-frame-pointer, we need frame pointers
	filter-flags -fomit-frame-pointer
	append-flags -fno-omit-frame-pointer  # required

	# Fix compilation without USE=static, upstreamed
	epatch "${FILESDIR}/google-mysql-dynlink-fixes.patch"
	# Fix system google-perftools header detection
	# our google-perftools are installed in /usr/include/gperftools
	epatch "${FILESDIR}/google-mysql-fix-gperftools-includedir.patch"
	rm "${S}"/google-perftools || die
	rm -r "${S}"/google-perftools-1.8.3 || die

	# XXX Upstream autoconf stuff is broken (lzo, ncurses)
	# execute eautoreconf only for the top level dir
	AT_NO_RECURSIVE=1 eautoreconf
}
