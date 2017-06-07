# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit mercurial

DESCRIPTION="Blender 2.5 exporter for LuxRender"
HOMEPAGE="http://www.luxrender.net"
EHG_REPO_URI="https://bitbucket.org/luxrender/luxblend25"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=">=media-gfx/blender-2.50
	media-gfx/luxrender"

src_install() {
	insinto /usr/share/blender/2.5/scripts/addons/
	insopts -g users -m0750 
	doins -r src/luxrender || die
	diropts -g users -m0770
	dodir /usr/share/blender/2.5/scripts/presets/luxrender || die
}
