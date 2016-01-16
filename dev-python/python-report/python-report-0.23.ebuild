# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

EGIT_REPO_URI="git://git.fedorahosted.org/report.git"
EGIT_COMMIT="${PV}"
inherit git-2 autotools eutils

DESCRIPTION="Provides a single configurable problem/bug/issue reporting API."
HOMEPAGE="http://git.fedoraproject.org/git/?p=report.git;a=summary"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/rpm
	net-misc/curl"
RDEPEND="dev-libs/openssl
	net-misc/curl
	dev-libs/libxml2
	>=app-misc/sabayon-version-14.05-r1"

src_prepare() {

	epatch "${FILESDIR}"/${P}-sabayon-config.patch
	epatch "${FILESDIR}"/${P}-disable-rpm.patch
	epatch "${FILESDIR}"/${P}-disable-Werror.patch

	eautoreconf || die "cannot run eautoreconf"
}

src_configure() {
	econf --prefix=/usr || die "configure failed"

	# Create some kind of version file to suit the build system
	mkdir -p "${S}"/python/report/plugins/RHEL-bugzilla/bugzillaCopy || die
	touch "${S}"/python/report/plugins/RHEL-bugzilla/bugzillaCopy/VERSION || die
}

src_install() {
	default
	# remove Red Hat stuff
	rm -rf "${D}"/python/report/plugins/{strata,RHEL-bugzilla} || die
}
