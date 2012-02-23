# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

ESVN_REPO_URI="svn://anonsvn.mono-project.com/source/trunk/mwf-designer"

inherit mono eutils subversion

DESCRIPTION="WinForms Designer for Mono."
HOMEPAGE="http://www.mono-project.com/WinForms_Designer"
SRC_URI=""

LICENSE="|| ( GPL-2 LGPL-2 X11 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-lang/mono-1.9"
DEPEND="${RDEPEND}"


src_compile() {
	emake || die
}

src_install() {
	dodir /usr/$(get_libdir)/${PN}
	insinto /usr/$(get_libdir)/${PN}

	doins deps/*.dll
	doins build/*.mdb
	doins build/*.exe

	make_wrapper mwf-designer "mono /usr/$(get_libdir)/${PN}/mwf-designer.exe"
}
