# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

GOLANG_PKG_IMPORTPATH="github.com/github"
GOLANG_PKG_HAVE_TEST=1

inherit golang-single

DESCRIPTION="Git extension for versioning large files"
HOMEPAGE="https://${GOLANG_PKG_IMPORTPATH}/${PN}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm"

use test && RESTRICT+=" sandbox"

src_prepare() {
        golang-single_src_prepare
}

src_install() {
        golang-single_src_install
}




