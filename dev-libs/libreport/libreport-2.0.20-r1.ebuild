# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_COMPAT=( python{2_6,2_7} )

inherit autotools eutils python-r1 user

DESCRIPTION="Generic library for reporting software bugs"
HOMEPAGE="https://fedorahosted.org/abrt/"
SRC_URI="https://fedorahosted.org/released/abrt/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug"

COMMON_DEPEND="!dev-python/python-report
	>=dev-libs/btparser-0.18:=
	>=dev-libs/glib-2.21:2
	dev-libs/json-c:=
	dev-libs/libtar
	dev-libs/libxml2:2
	dev-libs/newt:=
	dev-libs/nss:=
	dev-libs/xmlrpc-c:=
	net-libs/libproxy:=
	net-misc/curl:=[ssl]
	sys-apps/dbus
	>=x11-libs/gtk+-3.3.12:3
	x11-misc/xdg-utils
	${PYTHON_DEPS}
"
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}
	app-text/asciidoc
	app-text/xmlto
	>=dev-util/intltool-0.3.50
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
"

# Tests require python-meh, which is highly redhat-specific.
RESTRICT="test"

pkg_setup() {
	enewgroup abrt
	enewuser abrt -1 -1 -1 abrt
}

src_prepare() {
	# Replace redhat- and fedora-specific defaults with gentoo ones, and disable
	# code that requires gentoo infra support.
	epatch "${FILESDIR}/${PN}-2.0.20-sabayon.patch"

	# json-c-0.11, https://github.com/abrt/libreport/pull/{159,174}
	epatch "${FILESDIR}/${PN}-2.0.20-json-c.patch"

	# Modify uploader_event so that the gui recognizes it
	epatch "${FILESDIR}/${PN}-2.0.7-uploader_event-syntax.patch"

	mkdir -p m4
	eautoreconf

	python_copy_sources
}

src_configure() {
	python_foreach_impl run_in_build_dir econf \
		--localstatedir="${EPREFIX}/var" \
		$(usex debug --enable-debug "")
	# --disable-debug enables debug!
}

src_compile() {
	python_foreach_impl run_in_build_dir default
}

src_install() {
	python_foreach_impl run_in_build_dir default

	# Need to set correct ownership for use by app-admin/abrt
	diropts -o abrt -g abrt
	keepdir /var/spool/abrt

	prune_libtool_files --modules

	# Drop Fedora specific files
	rm "${D}/etc/libreport/workflows/workflow_Fedora.xml"
	rm "${D}/etc/libreport/workflows/workflow_AnacondaFedora.xml"
	rm "${D}/etc/libreport/workflows/workflow_Upload.xml"
}
