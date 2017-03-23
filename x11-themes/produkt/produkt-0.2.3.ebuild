# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit cmake-utils

CONTENT_ID="124213"

DESCRIPTION="A textured plasma theme"
HOMEPAGE="http://opendesktop.org/content/show.php?content=124213"
SRC_URI="http://opendesktop.org/CONTENT/content-files/${CONTENT_ID}-${PN}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"
