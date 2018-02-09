# Copyright 2014-2016 Julian Ospald <hasufell@posteo.de>
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit multilib cmake-utils eutils flag-o-matic user gnome2-utils python-any-r1

MY_PN="Unvanquished"
CBSE_COMMIT="1d621242e5bfce321c87b9cb29c5a893711a9f5c"

DESCRIPTION="Daemon engine, a fork of OpenWolf which powers the game Unvanquished"
HOMEPAGE="http://unvanquished.net/"
SRC_URI="https://github.com/${MY_PN}/${MY_PN}/tarball/v${PV}
	-> ${P}.tar.gz
	x86? ( http://dl.unvanquished.net/deps/linux32-4.tar.bz2 -> unvanquished-${PV}-external-x86-4.tar.bz2 )
	amd64? ( http://dl.unvanquished.net/deps/linux64-4.tar.bz2 -> unvanquished-${PV}-external-amd64-4.tar.bz2 )
	https://github.com/DaemonDevelopers/CBSE-Toolchain/archive/${CBSE_COMMIT}.tar.gz -> cbse-0.0.1.tar.gz"

LICENSE="GPL-3 CC-BY-SA-2.5 CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dedicated geoip +server +smp"

# https://github.com/Unvanquished/Unvanquished/issues/502
RESTRICT="strip"

RDEPEND="
	dev-libs/nettle[gmp]
	dev-libs/gmp:0
	~games-fps/${PN}-data-${PV}
	net-misc/curl
	sys-libs/ncurses:0
	sys-libs/zlib
	!dedicated? (
		dev-lang/lua:0
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
		virtual/glu
		virtual/jpeg:0
		virtual/opengl
		x11-libs/libX11
		server? ( app-misc/screen )
	)
	dedicated? (
		app-misc/screen
	)
	geoip? ( dev-libs/geoip )"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	virtual/pkgconfig"

CMAKE_BUILD_TYPE="Release"

UNV_SERVER_HOME=/var/lib/${PN}-server
UNV_SERVER_DATA=${UNV_SERVER_HOME}/.Unvanquished/main

pkg_pretend() {
	einfo "This package can benefit from the following CFLAGS/CXXFLAGS:"
	einfo "  -ffast-math"
	einfo "  -fvisibility=hidden"
	einfo
	einfo "You may want to set these for this package prior to compilation."
}

pkg_setup() {
	if use server || use dedicated ; then
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
	# unpack main archive
	unpack ${P}.tar.gz
	mv Unvanquished-Unvanquished-* "${S}" || die

	# unpack externel deps
	unpack unvanquished-${PV}-external-$(usex amd64 "amd64" "x86")-4.tar.bz2
	mv "linux$(usex amd64 "64" "32")-4" "${S}"/daemon/external_deps/ || die

	# unpack cbse
	cd "${S}"/src/utils || die
	rmdir cbse || die
	unpack cbse-0.0.1.tar.gz
	mv CBSE-Toolchain-* cbse
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.47.0-flags.patch \
		"${FILESDIR}"/${PN}-0.47.0-ncurses.patch

	sed \
		-e "s/@LIBDIR@/$(get_libdir)/" \
		"${FILESDIR}"/${PN}-0.38.sh  > "${T}"/${PN}-0.38.sh || die
}

src_configure() {
	# theora requires vorbis
	local mycmakeargs=(
		$(usex dedicated "-DBUILD_CLIENT=OFF -DBUILD_CGAME=OFF" "-DBUILD_CLIENT=ON -DBUILD_CGAME=ON")
		$(if use dedicated || use server ; then
			echo "-DBUILD_SERVER=ON -DBUILD_SGAME=ON"
		else
			echo "-DBUILD_SERVER=OFF -DBUILD_SGAME=OFF"
		fi)
		-DBUILD_GAME_NACL=OFF
		-DBUILD_TTY_CLIENT=ON
		-DCMAKE_C_FLAGS_RELEASE=""
		-DCMAKE_CXX_FLAGS_RELEASE=""
		-DUSE_DEBUG_OPTIMIZE=OFF
		$(cmake-utils_use_use geoip GEOIP)
		-DUSE_HARDENING=OFF
		-DUSE_LTO=OFF
		-DUSE_PEDANTIC=OFF
		-DUSE_PRECOMPILED_HEADER=ON
		$(cmake-utils_use_use smp SMP)
		-DUSE_WERROR=OFF
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cd "${BUILD_DIR}" || die

	exeinto /usr/$(get_libdir)/${PN}
	doexe nacl_loader nacl_helper_bootstrap *.nexe

	if use server || use dedicated ; then
		exeinto /usr/$(get_libdir)/${PN}
		doexe sgame-native-exe sgame-native-dll.so

		insinto /etc/${PN}
		doins "${FILESDIR}"/config/{maprotation,server}.cfg

		newinitd "${FILESDIR}"/${PN}-server.initd ${PN}-server
		newconfd "${FILESDIR}"/${PN}-server.confd ${PN}-server

		newbin daemonded ${PN}ded
	fi

	if ! use dedicated ; then
		newbin daemon ${PN}client
		newbin "${T}"/${PN}-0.38.sh ${PN}

		exeinto /usr/$(get_libdir)/${PN}
		doexe cgame-native-exe cgame-native-dll.so

		doicon -s 128 "${S}"/debian/${PN}.png
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

