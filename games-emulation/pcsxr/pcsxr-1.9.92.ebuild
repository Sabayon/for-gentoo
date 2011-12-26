# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils autotools games

DESCRIPTION="PCSX-Reloaded: a fork of PCSX, the discontinued Playstation emulator"
HOMEPAGE="http://pcsxr.codeplex.com"
SRC_URI="mirror://sabayon/${CATEGORY}/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc"
IUSE="alsa cdio opengl oss pulseaudio +sdl-sound"

RDEPEND="x11-libs/gtk+:2
	gnome-base/libglade
	media-libs/libsdl
	sys-libs/zlib
	app-arch/bzip2
	x11-libs/libXv
	x11-libs/libXtst
	alsa? ( media-libs/alsa-lib )
	opengl? ( virtual/opengl
	x11-libs/libXxf86vm )
	pulseaudio? ( >=media-sound/pulseaudio-0.9.16 )
	cdio? ( dev-libs/libcdio )"

DEPEND="${RDEPEND}
	!games-emulation/pcsx
	!games-emulation/pcsx-df
	x86? ( dev-lang/nasm )"

pkg_setup() {
	if use sdl-sound; then
		sound_backend="sdl"
	elif use pulseaudio; then
		sound_backend="pulseaudio"
	elif use alsa; then
		sound_backend="alsa"
	elif use oss; then
		sound_backend="oss"
	else
		sound_backend="null"
	fi

	elog "Using ${sound_backend} sound"
	games_pkg_setup
}

src_prepare() {
	# fix plugin path
	for i in $(grep -irl 'games/psemu' *);
	do
		sed -i "$i" \
		-e "s:games/psemu:psemu:g" \
		|| die "sed failed"
	done

	# fix icon and .desktop path
	epatch "${FILESDIR}/${PN}-datadir.patch"
	epatch "${FILESDIR}/${PN}-include.patch"

	# regenerate for changes to spread
	eautoreconf
}

src_configure() {
	egamesconf \
		$(use_enable cdio libcdio) \
		$(use_enable opengl) \
		--enable-sound=${sound_backend} \
		|| die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install \
	    || die "emake install failed"

	dodoc README doc/keys.txt doc/tweaks.txt ChangeLog
	prepgamesdirs
}
