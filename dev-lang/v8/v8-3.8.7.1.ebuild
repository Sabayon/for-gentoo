# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/v8/v8-3.8.7.1.ebuild,v 1.1 2012/01/22 22:21:03 floppym Exp $

EAPI="4"

PYTHON_DEPEND="2:2.6"

inherit flag-o-matic eutils multilib pax-utils python toolchain-funcs

DESCRIPTION="Google's open source JavaScript engine"
HOMEPAGE="http://code.google.com/p/v8"
SRC_URI="http://commondatastorage.googleapis.com/chromium-browser-official/${P}.tar.bz2"
LICENSE="BSD"

SLOT="0"
KEYWORDS="~arm"
IUSE=""

pkg_pretend() {
	local gccver=$(gcc-fullversion)
	if [[ ${gccver} = 4.5.2 ]]; then
		eerror "The currently selected version of gcc is known to segfault when building this"
		eerror "version of V8. Please use at least gcc-4.5.3."
		die "gcc-${gccver} detected."
	fi
}

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/v8-fix-arm-target.patch
	if is-flagq -mfloat-abi=hard; then
		epatch "${FILESDIR}"/v8-arm-enable-hardfp.patch
	fi
}

src_compile() {
	tc-export AR CC CXX RANLIB
	export LINK="${CXX}"

	# Use target arch detection logic from bug #354601.
	case ${CHOST} in
		i?86-*) myarch=ia32 ;;
		x86_64-*)
			if [[ $ABI = x86 ]] ; then
				myarch=ia32
			else
				myarch=x64
			fi ;;
		arm*-*) myarch=arm ;;
		*) die "Unrecognized CHOST: ${CHOST}"
	esac
	mytarget=${myarch}.release

	soname_version="${PV}"

	local snapshot=on
	host-is-pax && snapshot=off

	# TODO: Add console=readline option once implemented upstream
	# http://code.google.com/p/v8/issues/detail?id=1781

	emake V=1 \
		library=shared \
		werror=no \
		soname_version=${soname_version} \
		snapshot=${snapshot} \
		${mytarget} || die

	pax-mark m out/${mytarget}/{cctest,d8,shell} || die
}

src_test() {
	local arg testjobs
	for arg in ${MAKEOPTS}; do
		case ${arg} in
			-j*) testjobs=${arg#-j} ;;
			--jobs=*) testjobs=${arg#--jobs=} ;;
		esac
	done

	tools/test-wrapper-gypbuild.py \
		-j${testjobs:-1} \
		--arch-and-mode=${mytarget} \
		--no-presubmit \
		--progress=dots || die
}

src_install() {
	insinto /usr
	doins -r include || die

	dobin out/${mytarget}/d8 || die

	if [[ ${CHOST} == *-darwin* ]] ; then
		install_name_tool \
			-id "${EPREFIX}"/usr/$(get_libdir)/libv8$(get_libname).${soname_version} \
			out/${mytarget}/lib.target/libv8$(get_libname).${soname_version} || die
	fi

	dolib out/${mytarget}/lib.target/libv8$(get_libname).${soname_version} || die
	dosym libv8$(get_libname).${soname_version} /usr/$(get_libdir)/libv8$(get_libname) || die

	dodoc AUTHORS ChangeLog || die
}

pkg_preinst() {
	preserved_libs=()
	local baselib candidate

	eshopts_push -s nullglob

	for candidate in "${EROOT}usr/$(get_libdir)"/libv8-*$(get_libname) \
		"${EROOT}usr/$(get_libdir)"/libv8$(get_libname).*; do
		baselib=${candidate##*/}
		if [[ ! -e "${ED}usr/$(get_libdir)/${baselib}" ]]; then
			preserved_libs+=( "${EPREFIX}/usr/$(get_libdir)/${baselib}" )
		fi
	done

	eshopts_pop

	if [[ ${#preserved_libs[@]} -gt 0 ]]; then
		preserve_old_lib "${preserved_libs[@]}"
	fi
}

pkg_postinst() {
	if [[ ${#preserved_libs[@]} -gt 0 ]]; then
		preserve_old_lib_notify "${preserved_libs[@]}"
	fi
}
