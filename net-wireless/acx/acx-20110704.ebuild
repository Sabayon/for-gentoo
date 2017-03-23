# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit linux-mod git-2

EGIT_COMMIT="v${PV}"
EGIT_REPO_URI="git://acx100.git.sourceforge.net/gitroot/acx100/acx-mac80211"

DESCRIPTION="Driver for the ACX100 and ACX111 wireless chipset (CardBus, PCI, USB)"
HOMEPAGE="http://acx100.sourceforge.net/"
SRC_URI=""

LICENSE="GPL-2 as-is"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

IUSE=""

RDEPEND="net-wireless/wireless-tools
		net-wireless/acx-firmware"

MODULE_NAMES="acx-mac80211(net:${S})"
CONFIG_CHECK="~WIRELESS_EXT ~MAC80211 ~FW_LOADER" # TODO: && (USB || PCI)
BUILD_TARGETS="modules"

pkg_setup() {
	linux-mod_pkg_setup
	BUILD_PARAMS="-C ${KV_DIR} SUBDIRS=${S}"
}

src_unpack() {
	git-2_src_unpack
	chmod ug+w . -R

	# The default acx_config.h has some rather over-zealous debug output.
	cd "${S}"
	# With the current codebase, disabling debug would result in
	# major code explosion. Blame upstream for writing shitty code!

	epatch "${FILESDIR}/0001-2.6.40-wtf-stupidity.patch"
	epatch "${FILESDIR}/0002-linux-3.1.patch"
}

src_compile() {
	# augh, upstream not following external kernel mods build system
	# guidelines
	cd "${S}"
	local oldarch=${ARCH}
	unset ARCH
	emake || die
	ARCH=${oldarch}
}

src_install() {
	linux-mod_src_install

	dodoc README
}
