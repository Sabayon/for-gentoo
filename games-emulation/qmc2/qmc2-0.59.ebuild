# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils games

DESCRIPTION="Frontend for MAME/MESS"
HOMEPAGE="http://qmc2.arcadehits.net/wordpress/"
SRC_URI="http://sourceforge.net/projects/${PN}/files/${PN}/${PV}/${P}.tar.bz2/download -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="debug +arcade joystick opengl phonon tools"
RESTRICT="mirror"

RDEPEND=">=games-emulation/sdlmame-0.164[tools=]"
DEPEND="${RDEPEND}
	dev-qt/qtcore:4
	dev-qt/qtgui:4[accessibility]
	dev-qt/qtopengl:4
	dev-qt/qtsql:4[sqlite]
	dev-qt/qtsvg:4
	dev-qt/qttest:4
	dev-qt/qtwebkit:4
	dev-qt/qtxmlpatterns:4
	media-libs/libsdl
	net-misc/rsync
	sys-libs/zlib
	x11-apps/xwininfo
	arcade? ( dev-qt/qtdeclarative:4 )
	joystick? ( media-libs/libsdl[joystick] )
	opengl? ( dev-qt/qtopengl:4 )
	phonon? ( || ( media-libs/phonon dev-qt/qtphonon:4 ) )
	tools? ( dev-qt/qtscript )"

S="${WORKDIR}/${PN}"

src_prepare() {
	# *.desktop files belong in /usr/share/applications, not /usr/share/games/applications #
	sed -e "s:\$(GLOBAL_DATADIR)/applications:${ED}usr/share/applications:g" \
		-i Makefile || die
}

src_compile() {
	FLAGS="DESTDIR=\"${ED}\" PREFIX=\"${GAMES_PREFIX}\" SYSCONFDIR=\"${GAMES_SYSCONFDIR}\" DATADIR=\"${GAMES_DATADIR}\" CTIME=0"
	emake ${FLAGS} \
		DEBUG=$(usex debug "1" "0") \
		JOYSTICK=$(usex joystick "1" "0") \
		OPENGL=$(usex opengl "1" "0") \
		PHONON=$(usex phonon "1" "0")

	use arcade && \
		emake ${FLAGS} arcade

	use tools && \
		emake ${FLAGS} tools
}

src_install() {
	emake ${FLAGS} install

	use arcade && \
		emake ${FLAGS} arcade-install

	use tools && \
		emake ${FLAGS} tools-install

	prepgamesdirs
}
