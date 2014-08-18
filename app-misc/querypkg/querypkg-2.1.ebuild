# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
EGIT_REPO_URI="git://github.com/Enlik/querypkg.git"
EGIT_COMMIT="v${PV}"
inherit perl-module vcs-snapshot

DESCRIPTION="A simple CLI interface to packages.sabayon.org"
HOMEPAGE="http://github.com/Enlik/querypkg/"
SRC_URI="https://github.com/Enlik/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-lang/perl-5.10
	dev-perl/JSON-XS
	dev-perl/URI
	dev-perl/libwww-perl"
DEPEND="${RDEPEND}"

SRC_TEST=do
