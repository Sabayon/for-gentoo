# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/spidermonkey/spidermonkey-1.8.5-r1.ebuild,v 1.2 2011/11/26 04:49:25 dirtyepic Exp $

EAPI="3"

WANT_AUTOCONF="2.1"
inherit autotools eutils toolchain-funcs multilib python versionator pax-utils

MY_PN="js"
TARBALL_PV="$(replace_all_version_separators '' $(get_version_component_range 1-3))"
MY_P="${MY_PN}-${PV}"
TARBALL_P="${MY_PN}${TARBALL_PV}-1.0.0"
DESCRIPTION="Stand-alone JavaScript C library"
HOMEPAGE="http://www.mozilla.org/js/spidermonkey/"
SRC_URI="https://ftp.mozilla.org/pub/mozilla.org/js/${TARBALL_P}.tar.gz"

LICENSE="NPL-1.1"
SLOT="0"
KEYWORDS="~arm"
IUSE="debug static-libs test"

S="${WORKDIR}/${MY_P}"
BUILDDIR="${S}/js/src"

RDEPEND=">=dev-libs/nspr-4.7.0"
DEPEND="${RDEPEND}
	app-arch/zip
	=dev-lang/python-2*[threads]
	dev-util/pkgconfig"

pkg_setup(){
	python_set_active_version 2

	export LC_ALL="C"
}

src_prepare() {
	# https://bugzilla.mozilla.org/show_bug.cgi?id=628723#c43
	epatch "${FILESDIR}/${P}-fix-install-symlinks.patch"
	# https://bugzilla.mozilla.org/show_bug.cgi?id=638056#c9
	epatch "${FILESDIR}/${P}-fix-ppc64.patch"

	# Sabayon: armv7 fixes
	# reconf due to fix-arm-crap.patch (this rebuilds Makefile.in
	# and allows for proper patching it [hack, determine why
	# if forces "arm" instead of "arm%" on:
	#   ifeq (,$(filter arm %86 x86_64,$(TARGET_CPU)))
	# ])
	cd "${BUILDDIR}" && eautoreconf
	# Fix compilation on ARMv7, causes configure to fail due to -mfloat-abi=softfp
	# being there when it shouldn't be. Similar to pixman issue:
	# https://bugzilla.mozilla.org/show_bug.cgi?id=618570
	# Fix build system arm if conditions, TARGET_CPU is something like "armv7a" and
	# not just "arm".
	epatch "${FILESDIR}/${P}-fix-arm-crap.patch"

	epatch_user

	if [[ ${CHOST} == *-freebsd* ]]; then
		# Don't try to be smart, this does not work in cross-compile anyway
		ln -sfn "${BUILDDIR}/config/Linux_All.mk" "${S}/config/$(uname -s)$(uname -r).mk"
	fi

	# reconf due to fix-arm-crap.patch
	cd "${BUILDDIR}" && eautoreconf
}

src_configure() {
	cd "${BUILDDIR}"

	CC="$(tc-getCC)" CXX="$(tc-getCXX)" LD="$(tc-getLD)" PYTHON="$(PYTHON)" \
	econf \
		${myopts} \
		--enable-jemalloc \
		--enable-readline \
		--enable-threadsafe \
		--with-system-nspr \
		$(use_enable debug) \
		$(use_enable static-libs static) \
		$(use_enable test tests)
}

src_compile() {
	cd "${BUILDDIR}"
	emake || die
}

src_test() {
	cd "${BUILDDIR}/jsapi-tests"
	emake check || die
}

src_install() {
	cd "${BUILDDIR}"
	emake DESTDIR="${D}" install || die
	dobin shell/js ||die
	pax-mark m "${ED}/usr/bin/js"
	dodoc ../../README || die
	dohtml README.html || die

	if ! use static-libs; then
		# We can't actually disable building of static libraries
		# They're used by the tests and in a few other places
		find "${D}" -iname '*.a' -delete || die
	fi
}
