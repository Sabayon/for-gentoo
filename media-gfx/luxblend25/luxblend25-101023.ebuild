# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

EHG_REVISION="542b3a7ac219"

DESCRIPTION="Blender 2.5 exporter for luxrender"
HOMEPAGE="http://www.luxrender.net"
SRC_URI="http://src.luxrender.net/luxblend25/archive/${EHG_REVISION}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=media-gfx/blender-2.55"
DEPEND=""

S="${WORKDIR}/luxblend25-${EHG_REVISION}"

src_install() {
	insinto /usr/share/blender/2.5/scripts/addons/
	doins -r src/luxrender
	chown root:users -R "${D}"/usr/share/blender/2.5/scripts/addons/luxrender
	diropts -m0770
	dodir /usr/share/blender/2.5/scripts/presets/luxrender
	chown root:users "${D}"/usr/share/blender/2.5/scripts/presets/luxrender
}
