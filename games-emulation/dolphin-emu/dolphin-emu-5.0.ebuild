# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

WX_GTK_VER="3.0"
MY_AUTHOR="dolphin-emu"
MY_PN="dolphin"

inherit cmake-utils eutils flag-o-matic pax-utils toolchain-funcs wxwidgets games

DESCRIPTION="Free, open source emulator for Nintendo GameCube and Wii"
HOMEPAGE="http://www.dolphin-emu.com/"
if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/${MY_AUTHOR}/${MY_PN}.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/${MY_AUTHOR}/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"

# NOTES:
# - wxWidgets support relies on 2.9 branch, which is currently masked in main tree
IUSE="alsa ao bluetooth doc encode +lzo openal opengl portaudio pulseaudio upnp +wxwidgets +gui egl enet qt5 git debug llvm"
REQUIRED_USE="
	opengl? ( gui )
	wxwidgets? ( gui )
	qt5? ( !wxwidgets gui )
"

RDEPEND=">=media-libs/glew-1.5
	>=media-libs/libsdl-1.2[joystick]
	>=dev-libs/libevdev-1.4.4
	virtual/udev
	net-libs/polarssl[havege]
	sys-libs/readline:=
	virtual/libusb:1
	>media-libs/libsfml-2.1
	virtual/libiconv
	media-libs/libpng:=
	media-libs/libsoundtouch
	sys-libs/zlib
	dev-cpp/gtest
	net-libs/mbedtls[havege]
	debug? ( dev-util/oprofile )
	qt5? ( dev-qt/qtcore:5
	       dev-qt/qtwidgets:5
	      )
	upnp? ( net-libs/miniupnpc )
	gui? ( x11-libs/libX11
	     x11-libs/libXext
	     >=x11-apps/xinput-1.5.0
	     x11-libs/libXrandr
	)
	egl? ( >=media-libs/mesa-9.1.6[egl] )
	enet? ( net-libs/enet:1.3 )
	ao? ( media-libs/libao )
	alsa? ( media-libs/alsa-lib )
	bluetooth? ( net-wireless/bluez )
	encode? ( virtual/ffmpeg[encode] )
	lzo? ( dev-libs/lzo )
	openal? ( media-libs/openal )
	opengl? ( virtual/opengl )
	portaudio? ( media-libs/portaudio )
	pulseaudio? ( media-sound/pulseaudio )
	wxwidgets? ( x11-libs/wxGTK:3.0 )
	git? ( dev-vcs/git )
	llvm? ( sys-devel/llvm )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig
	media-gfx/nvidia-cg-toolkit"

if [[ ${PV} != "9999" ]] ; then
	S="${WORKDIR}/${MY_PN}-${PV}"
fi

src_prepare() {
	append-cflags $(test-flags-CC -fpermissive)
	append-cxxflags $(test-flags-CXX -fpermissive)

	# Remove automagic dependencies
	if use !alsa; then
		sed -i -e '/^include(FindALSA/d' CMakeLists.txt || die
	fi
	if use !ao; then
		 sed -i -e '/^check_lib(AO/d' CMakeLists.txt || die
	fi
	if use !bluetooth; then
		sed -i -e '/^check_lib(BLUEZ/d' CMakeLists.txt || die
	fi
	if use !openal; then
		sed -i -e '/^include(FindOpenAL/d' CMakeLists.txt || die
	fi
	if use !portaudio; then
		sed -i -e '/CMAKE_REQUIRED_LIBRARIES portaudio/d' CMakeLists.txt || die
	fi
	if use !pulseaudio; then
		sed -i -e '/^check_lib(PULSEAUDIO/d' CMakeLists.txt || die
	fi
	if use !git; then
		sed -i -e '/^include(FindGit/d' CMakeLists.txt || die
	fi
	if use !llvm; then
		sed -i -e '/^include(FindLLVM/d' CMakeLists.txt || die
	fi
}

src_configure() {
	# filter problematic compiler flags
	filter-flags -flto -fwhole-program
	append-flags -fno-pie

	if $($(tc-getPKG_CONFIG) --exists nvidia-cg-toolkit); then
		append-flags "$($(tc-getPKG_CONFIG) --cflags nvidia-cg-toolkit)"
	else
		append-flags "-I/opt/nvidia-cg-toolkit/include"
	fi

	if $($(tc-getPKG_CONFIG) --exists nvidia-cg-toolkit); then
		append-ldflags "$($(tc-getPKG_CONFIG) --libs-only-L nvidia-cg-toolkit)"
	else
		append-ldflags "-L/opt/nvidia-cg-toolkit/lib"
	fi

	local mycmakeargs=(
		"-DDOLPHIN_WC_REVISION=${PV}"
		"-DCMAKE_INSTALL_PREFIX=${GAMES_PREFIX}"
		"-Dprefix=${GAMES_PREFIX}"
		"-Ddatadir=${GAMES_DATADIR}/${PN}"
		"-Dplugindir=$(games_get_libdir)/${PN}"
		$(cmake-utils_use !wxwidgets DISABLE_WX)
		$(cmake-utils_use encode ENCODE_FRAMEDUMPS)
		$(cmake-utils_use egl USE_EGL)
		$(cmake-utils_use gui TRY_X11)
		$(cmake-utils_use upnp USE_UPNP)
		$(cmake-utils_use qt5 ENABLE_QT)
		$(cmake-utils_use enet USE_SHARED_ENET)
		$(cmake-utils_use debug FASTLOG)
		$(cmake-utils_use debug OPROFILING)
		$(cmake-utils_use debug GDBSTUB)
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	# set binary name
	local binary="${PN}"
	use wxwidgets || binary+="-nogui"

	# install documentation as appropriate
	dodoc Readme.md
	if use doc; then
		doins -r docs
	fi

	# create menu entry for GUI builds
	if use wxwidgets || use qt5; then
		make_desktop_entry "${PN}" "Dolphin" "Dolphin" "Game;Emulator"
	fi

	prepgamesdirs
}

pkg_postinst() {
	# hardened fix
	pax-mark -m "${EPREFIX}/usr/games/bin/${PN}"

	if ! use portaudio; then
		ewarn "If you need to use your microphone for a game, rebuild with USE=portaudio"
	fi
	if ! use wxwidgets && ! use qt5; then
		ewarn "Note: It is not currently possible to configure Dolphin without the GUI."
		ewarn "Rebuild with USE=wxwidgets to enable the GUI if needed."
	fi

	games_pkg_postinst
}
