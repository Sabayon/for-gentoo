# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

PYTHON_DEPEND="python? 2"

inherit cmake-utils java-pkg-opt-2 multilib python

DESCRIPTION="General purpose XQuery processor implemented in C++."
HOMEPAGE="http://www.zorba-xquery.com/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0 mapm"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+curl doc examples fop +imap java php python +smtp +ssl ruby static-libs +threads +tidy +unicode xqueryx"

RDEPEND="dev-libs/libxml2
	dev-libs/xerces-c
	dev-libs/boost
	dev-libs/icu
	curl? ( net-misc/curl[ssl?] )
	fop? ( dev-java/fop )
	smtp? ( net-libs/c-client )
	tidy? ( app-text/htmltidy )
	unicode? ( dev-libs/icu )
	xqueryx? ( dev-libs/libxslt )
	java? ( virtual/jre )
	php? ( dev-lang/php:5.3 )
	ruby? ( dev-lang/ruby )"
DEPEND="${DEPEND}
	sys-devel/bison
	sys-devel/flex
	java? ( dev-lang/swig >=virtual/jdk-1.5 )
	php? ( dev-lang/swig )
	python? ( dev-lang/swig )
	ruby? ( dev-lang/swig )"

# TODO:
# - unbundle mapm
# - make c-client configureable
# - enable python/php/java bindings

pkg_setup() {
	python_pkg_setup
	java-pkg-opt-2_pkg_setup
}
src_prepare() {
	epatch \
		"${FILESDIR}/${PV}-disable-broken-tests.patch" \
		"${FILESDIR}/${PV}-use-c-client-so-lib.patch" \
		"${FILESDIR}/${PV}-configurable-bindings.patch"
	java-pkg-opt-2_src_prepare
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use curl ZORBA_WITH_REST)
		$(cmake-utils_use fop ZORBA_WITH_FOP)
		$(cmake-utils_use ssl ZORBA_WITH_SSL)
		$(cmake-utils_use static-libs ZORBA_BUILD_STATIC_LIBRARY)
		$(cmake-utils_use !threads ZORBA_FOR_ONE_THREAD_ONLY)
		$(cmake-utils_use tidy ZORBA_WITH_TIDY)
		$(cmake-utils_use !unicode ZORBA_NO_UNICODE)
		$(cmake-utils_use xqueryx ZORBA_XQUERYX)
		$(cmake-utils_use !java ZORBA_NO_JAVA_BINDINGS)
		$(cmake-utils_use !php ZORBA_NO_PHP_BINDINGS)
		$(cmake-utils_use !python ZORBA_NO_PYTHON_BINDINGS)
		$(cmake-utils_use !ruby ZORBA_NO_RUBY_BINDINGS)
		$(cmake-utils_use smtp ZORBA_MAIL_SUPPORT)
		)

	# disable swig completely if no language bindings requested
	use java || use php || use python || use ruby || mycmakeargs+=(-DZORBA_USE_SWIG=OFF)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile

	if use doc ; then
		einfo "generating docs as requested"
		cd "${S}/doc"
		doxygen Doxyfile || die "generating docs failed"
	fi
}

src_install() {
	cmake-utils_src_install

	# the modules directory contains .so and .xq files
	# moving it to the libdir and replace it by a symlink
	dodir "/usr/$(get_libdir)/zorba"
	mv "${D}/usr/include/zorba/modules" "${D}/usr/$(get_libdir)/zorba/modules"
	dosym ../../$(get_libdir)/zorba/modules /usr/include/zorba/modules

	rm -rf "${D}/usr/share/doc"

	if use java ; then
		java-pkg_doso "${D}/usr/share/java/libzorba_api.so"
		rm -rf "${D}/usr/share/java/"
	fi

	cd "${S}"

	dodoc AUTHORS.txt ChangeLog KNOWN_ISSUES.txt NOTICE.txt README.txt
	if use doc ; then
		dohtml -r doc/html/*
		dodoc doc/design/*.pdf
	fi

	if use examples ; then
		for l in c cxx java php python ruby ; do
			insinto /usr/share/doc/${PF}/${l}
			doins -r doc/${l}/examples
		done
	fi

}

pkg_postinst() {
	python_mod_optimize zorba_api.py
}

pkg_postrm() {
	python_mod_cleanup zorba_api.py
}
