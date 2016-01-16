# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

EHG_REVISION="dd31cb14b9f1"

DESCRIPTION="Blender 2.5 exporter for luxrender"
HOMEPAGE="http://www.luxrender.net"
SRC_URI="mirror://sabayon/${CATEGORY}/${PF}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=">=media-gfx/blender-2.50"

S="${WORKDIR}/luxblend25-${EHG_REVISION}"

src_install() {
	insinto ${BLENDER_SYSTEM_SCRIPTS}/addons/
	doins -r src/luxrender
	dodir ${BLENDER_SYSTEM_SCRIPTS}/presets/luxrender
}
