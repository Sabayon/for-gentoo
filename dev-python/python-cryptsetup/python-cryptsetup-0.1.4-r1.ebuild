# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
EGIT_REPO_URI="git://git.fedorahosted.org/python-cryptsetup.git"
EGIT_COMMIT="${P}-${PR/r}"

inherit distutils git-2 eutils

DESCRIPTION="Python bindings for Network Security Services (NSS)"
HOMEPAGE="http://git.fedorahosted.org/cgit/python-cryptsetup.git/"
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-fs/cryptsetup"
RDEPEND="${DEPEND}"
