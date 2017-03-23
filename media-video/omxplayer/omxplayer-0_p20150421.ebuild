# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils toolchain-funcs vcs-snapshot

DESCRIPTION="command line media player for the Raspberry Pi"
HOMEPAGE="https://github.com/popcornmix/omxplayer"
SRC_URI="https://github.com/popcornmix/omxplayer/tarball/b1ad23ec68 -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm"
IUSE=""

RDEPEND="dev-libs/libpcre
	|| ( media-libs/raspberrypi-userland media-libs/raspberrypi-userland-bin )
	virtual/ffmpeg
	sys-apps/dbus
	sys-apps/fbset"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0_p20150421-Makefile.patch

	cat > Makefile.include << EOF
LIBS=-lvchiq_arm -lvcos -lbcm_host -lEGL -lGLESv2 -lopenmaxil -lrt -lpthread
EOF

	tc-export CXX
}

src_compile() {
	emake ${PN}.bin
}

src_install() {
	dobin ${PN} ${PN}.bin
	dodoc README.md
}
