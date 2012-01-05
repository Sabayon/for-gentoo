# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils toolchain-funcs versionator games

MY_P=${PN}_${PV}
BASE_PV=0.61
BASE_P=${PN}_${BASE_PV}
DESCRIPTION="Multiplayer FPS based on the QFusion engine (evolved from Quake 2)"
HOMEPAGE="http://www.warsow.net/"
SRC_URI="http://www.zcdn.org/dl/${BASE_P}_unified.zip
	http://www.zcdn.org/dl/${MY_P}_update.zip
	http://www.zcdn.org/dl/${MY_P}_sdk.zip
	mirror://gentoo/${PN}.png"

LICENSE="GPL-2 warsow"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+angelscript debug dedicated irc openal opengl"

UIRDEPEND="virtual/jpeg
	media-libs/libvorbis
	media-libs/libsdl
	virtual/opengl
	x11-libs/libXinerama
	x11-libs/libXxf86dga
	x11-libs/libXxf86vm
	openal? ( media-libs/openal )"
RDEPEND="net-misc/curl
	opengl? ( ${UIRDEPEND} )
	!opengl? ( !dedicated? ( ${UIRDEPEND} ) )"
UIDEPEND="x11-proto/xineramaproto
	x11-proto/xf86dgaproto
	x11-proto/xf86vidmodeproto
	openal? ( dev-util/pkgconfig )"
DEPEND="${RDEPEND}
	app-arch/unzip
	x11-misc/makedepend
	opengl? ( ${UIDEPEND} )
	!opengl? ( !dedicated? ( ${UIDEPEND} ) )"

S=${WORKDIR}/source

src_unpack() {
	unpack ${A/${MY_P}_update.zip/}
	cd ${BASE_P}_unified || die
	unpack ${MY_P}_update.zip
}

src_prepare() {
	sed -i \
		-e "/fs_basepath =/ s:\.:${GAMES_DATADIR}/${PN}:" \
		qcommon/files.c \
		|| die "sed files.c failed"

	sed -i \
		-e "s:jpeg_mem_src:_&:" \
		ref_gl/r_image.c || die

	cd "${WORKDIR}"
	rm -rf docs/old
	epatch \
		"${FILESDIR}"/${PN}-0.6-build-game.patch \
		"${FILESDIR}"/${PN}-0.6-build-no-start-scripts.patch \
		"${FILESDIR}"/${PN}-0.6-dont-delete-angelscript.patch \
		"${FILESDIR}"/${PN}-0.5-pic.patch
}

src_compile() {
	yesno() { use ${1} && echo YES || echo NO ; }

	local client="NO" irc="NO" openal="NO"
	if use opengl || ! use dedicated ; then
		client="YES"
		use irc && irc="YES"
		use openal && openal="YES"
	fi

	if use angelscript ; then
		tc-export AR RANLIB
		emake \
			-C ../libsrcs/angelscript/angelSVN/sdk/angelscript/projects/gnuc \
			|| die "emake angelscript failed"
	fi

	local arch
	if use amd64 ; then
		arch=x86_64
	elif use x86 ; then
		arch=i386
	fi

	unset ARCH
	emake \
		BASE_ARCH=${arch} \
		BINDIR=bin \
		BUILD_CLIENT=${client} \
		BUILD_SERVER=$(yesno dedicated) \
		BUILD_TV_SERVER=$(yesno dedicated) \
		BUILD_ANGELWRAP=$(yesno angelscript) \
		BUILD_IRC=${irc} \
		BUILD_SND_OPENAL=${openal} \
		BUILD_SND_QF=${client} \
		DEBUG_BUILD=$(yesno debug) \
		|| die "emake failed"
}

src_install() {
	cd bin

	if use opengl || ! use dedicated ; then
		newgamesbin ${PN}.* ${PN} || die "newgamesbin ${PN} failed"
		doicon "${DISTDIR}"/${PN}.png
		make_desktop_entry ${PN} Warsow
	fi

	if use dedicated ; then
		newgamesbin wsw_server.* ${PN}-ded || die "newgamesbin ${PN}-ded failed"
		newgamesbin wswtv_server.* ${PN}-tv || die "newgamesbin ${PN}-tv failed"
	fi

	exeinto "$(games_get_libdir)"/${PN}
	doexe */*.so || die "doexe failed"

	insinto "${GAMES_DATADIR}"/${PN}
	doins -r "${WORKDIR}/${BASE_P}_unified"/basewsw || die "doins failed"

	if [ -e libs ] ; then
		dodir "${GAMES_DATADIR}"/${PN}/libs || die "dodir failed"
	fi

	local so
	for so in basewsw/*.so ; do
		dosym "$(games_get_libdir)"/${PN}/${so##*/} \
			"${GAMES_DATADIR}"/${PN}/${so} || die "dosym ${so} failed"
	done
	for so in libs/*.so ; do
		dosym "$(games_get_libdir)"/${PN}/${so##*/} \
			"${GAMES_DATADIR}"/${PN}/${so} || die "dosym ${so} failed"
	done

	dodoc "${WORKDIR}"/docs/*
	prepgamesdirs
}
