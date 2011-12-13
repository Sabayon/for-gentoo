# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit base

DESCRIPTION="A tool to edit C strings in compiled binaries"
HOMEPAGE="http://ohnopub.net/~ohnobinki/bin_replace_string"
SRC_URI="ftp://ohnopub.net/mirror/bin_replace_string-0.2.tar.bz2"
LICENSE="AGPL-3"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc"

RDEPEND="|| ( >=dev-libs/libelf-0.8.13
		dev-libs/elfutils )"
DEPEND="doc? ( app-text/txt2man )
	${RDEPEND}"

src_configure() {
	econf $(use_enable doc)
}
