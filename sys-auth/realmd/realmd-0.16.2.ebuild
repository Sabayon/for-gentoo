# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

AUTOTOOLS_AUTORECONF=1

inherit autotools-utils systemd

DESCRIPTION="DBus service for configuring kerberos and other online identities"
HOMEPAGE="http://cgit.freedesktop.org/realmd/realmd/"
SRC_URI="http://www.freedesktop.org/software/realmd/releases/${P}.tar.gz"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="systemd"

DEPEND="app-admin/packagekit-base
	sys-auth/polkit[introspection]
	sys-devel/gettext
	dev-libs/glib:2
	virtual/krb5
	systemd? ( sys-apps/systemd )"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -e '/gentoo-release/s/dnl/ /g' -i configure.ac
	# Copy the gentoo config file
	cp "${FILESDIR}/realmd-gentoo.conf" "${S}/service/" || die

	autotools-utils_src_prepare
}

src_configure() {
	autotools-utils_src_configure \
		$(use_with systemd systemd-journal) \
		--with-systemd-unit-dir=$(systemd_get_unitdir)
}
