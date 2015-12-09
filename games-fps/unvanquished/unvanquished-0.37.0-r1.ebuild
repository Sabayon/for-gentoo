# Copyright 2014 Julian Ospald <hasufell@posteo.de>
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils eutils flag-o-matic user gnome2-utils python-any-r1

MY_PN="Unvanquished"

DESCRIPTION="Daemon engine, a fork of OpenWolf which powers the game Unvanquished"
HOMEPAGE="http://unvanquished.net/"
SRC_URI="https://github.com/${MY_PN}/${MY_PN}/tarball/v${PV}
	-> ${P}.tar.gz
	x86? ( http://dl.unvanquished.net/deps/linux32-3.tar.bz2 -> unvanquished-${PV}-external-x86-3.tar.bz2 )
	amd64? ( http://dl.unvanquished.net/deps/linux64-3.tar.bz2 -> unvanquished-${PV}-external-amd64-3.tar.bz2 )"

LICENSE="GPL-3 CC-BY-SA-2.5 CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dedicated geoip +optimization +server +smp"

RDEPEND="
	dev-libs/nettle[gmp]
	dev-libs/gmp:0
	~games-fps/${PN}-data-${PV}
	net-misc/curl
	sys-libs/zlib
	!dedicated? (
		media-libs/freetype:2
		media-libs/glew
		media-libs/libogg
		media-libs/libpng:0
		media-libs/libsdl2[X,opengl,video]
		media-libs/libtheora
		media-libs/libvorbis
		media-libs/libwebp
		media-libs/openal
		media-libs/opusfile
		sys-libs/ncurses
		virtual/glu
		virtual/jpeg
		virtual/opengl
		x11-libs/libX11
		server? ( app-misc/screen )
	)
	dedicated? (
		app-misc/screen
		sys-libs/ncurses
	)
	geoip? ( dev-libs/geoip )"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	virtual/pkgconfig"

CMAKE_IN_SOURCE_BUILD=1

UNV_SERVER_HOME=/var/lib/${PN}-server
UNV_SERVER_DATA=${UNV_SERVER_HOME}/.Unvanquished/main

pkg_setup() {
	if use server || use dedicated ; then
		enewgroup "${PN}-server"
		enewuser \
			"${PN}-server" \
			"-1" \
			"/bin/sh" \
			"${UNV_SERVER_HOME}" \
			"${PN}-server"
	fi

	python-any-r1_pkg_setup
}

src_unpack() {
	default
	mv Unvanquished-Unvanquished-* "${S}" || die
	mv "linux$(usex amd64 "64" "32")-3" "${S}"/external_deps/ || die
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.37.0-flags.patch
}

src_configure() {
	if use optimization ; then
		append-cflags -ffast-math -fno-strict-aliasing
		append-cxxflags -ffast-math -fno-strict-aliasing -fvisibility=hidden
	fi
	append-cxxflags -std=gnu++11

	# theora requires vorbis
	local mycmakeargs=(
		-DUSE_LTO=0
		-DUSE_HARDENING=0
		-DUSE_PRECOMPILED_HEADER=0
		$(usex dedicated "-DBUILD_CLIENT=OFF" "-DBUILD_CLIENT=ON")
		-DBUILD_TTY_CLIENT=ON
		$(usex dedicated "-DBUILD_SERVER=ON" "$(cmake-utils_use_build server SERVER)")
		# https://github.com/Unvanquished/Unvanquished/issues/646
		# $(cmake-utils_use_use voip VOIP)
		-DUSE_VOIP=0
		$(cmake-utils_use_use smp SMP)
		$(cmake-utils_use_use geoip GEOIP)
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	if use server || use dedicated ; then
		insinto /etc/${PN}
		doins "${FILESDIR}"/config/{maprotation,server}.cfg

		newinitd "${FILESDIR}"/${PN}-server.initd ${PN}-server
		newconfd "${FILESDIR}"/${PN}-server.confd ${PN}-server

		newbin daemonded ${PN}ded
	fi

	if ! use dedicated ; then
		newbin daemon ${PN}client
		newbin "${FILESDIR}"/${PN}.sh ${PN}

		dolib *.so

		doicon -s 128 debian/${PN}.png
		make_desktop_entry ${PN}
		newbin daemon-tty ${PN}-tty
	fi
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update

	if use server || use dedicated ; then
		elog "To configure your dedicated server, edit the files:"
		elog "/etc/${PN}/server.cfg"
		elog "/etc/${PN}/maprotation.cfg"
		elog "/etc/conf.d/${PN}-server"
		elog ""
		elog "To run your dedicated server use the initscript"
		elog "/etc/init.d/${PN}-server which is run"
		elog "as user '${PN}-server' in a screen session."
		elog "The homedir is '${UNV_SERVER_HOME}'."
	fi
}

pkg_postrm() {
	gnome2_icon_cache_update
}

