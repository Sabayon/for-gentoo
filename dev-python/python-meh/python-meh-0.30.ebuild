# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

EGIT_REPO_URI="git://git.fedorahosted.org/python-meh.git"
EGIT_COMMIT="r${PV}-1"
inherit distutils git-2 eutils

DESCRIPTION="Python exception handling library"
HOMEPAGE="http://git.fedoraproject.org/git/python-meh.git?p=python-meh.git;a=summary"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk"

COMMON_DEPEND="
	dev-python/dbus-python
	dev-util/intltool
	sys-devel/gettext
	"
DEPEND="${COMMON_DEPEND}"

RDEPEND="${COMMON_DEPEND}
	dev-libs/newt
	gtk? (
		x11-libs/gtk+:3
		dev-python/pygobject:3
	)
	>=dev-python/python-report-0.18
	net-misc/openssh"

src_prepare() {
	cd "${S}"
	epatch "${FILESDIR}/${PN}-keep_exc_win_above.patch"
	distutils_src_prepare
}
