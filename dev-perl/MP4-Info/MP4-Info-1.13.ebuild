# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

MODULE_AUTHOR=JHAR
inherit perl-module

DESCRIPTION="Fetch info from MPEG-4 files (.mp4, .m4a, .m4p, .3gp)"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-perl/IO-String"
DEPEND="
	test? ( ${RDEPEND} )"

SRC_TEST=do
