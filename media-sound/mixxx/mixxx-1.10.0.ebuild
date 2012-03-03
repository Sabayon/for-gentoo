# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils multilib scons-utils toolchain-funcs

DESCRIPTION="a QT based Digital DJ tool"
HOMEPAGE="http://mixxx.sourceforge.net"
SRC_URI="http://downloads.mixxx.org/${P}/${P}-src.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug mp4 pulseaudio"

RDEPEND="media-libs/libmad
	media-libs/libid3tag
	media-libs/libmad
	media-libs/libogg
	media-libs/libvorbis
	media-libs/libsndfile
	media-libs/portmidi
	>=media-libs/libsoundtouch-1.5
	>=media-libs/portaudio-19_pre
	virtual/opengl
	virtual/glu
	x11-libs/qt-gui:4
	x11-libs/qt-svg:4
	x11-libs/qt-opengl:4
	x11-libs/qt-qt3support:4
	x11-libs/qt-webkit:4
	x11-libs/qt-xmlpatterns:4
	mp4? ( media-libs/libmp4v2 )
	pulseaudio? ( media-sound/pulseaudio )"
DEPEND="${RDEPEND}
	dev-util/scons
	dev-util/pkgconfig"

pkg_setup() {
	mysconsargs="prefix=/usr
		qtdir=/usr/$(get_libdir)/qt4
		install_root=${D}/usr
		hifieq=1
		vinylcontrol=1"

	use debug && mysconsargs+=" qdebug=1" || mysconsargs+=" qdebug=0"
	use mp4 && mysconsargs+=" m4a=1" || mysconsargs+=" m4a=0"
}

src_prepare() {

	# patch bzr revisoon issue.
	sed -i -e 's:return os.popen("bzr revno").readline().strip():return "gentoo":' \
		src/SConscript.env || die "sed revno failed"

	# fix issues with cxxflags
	sed -i -e "s:-pipe -Wall -W -g::" \
		src/SConscript.env || die "sed failed"

	# Patch startup command if not using pulse audio
	use pulseaudio || sed -i -e 's:pasuspender:nice -n 0:' src/mixxx.desktop

	# add addtional flags for debugging.
	local extraflags=""
	use debug && extraflags="${extraflags} -g"

	#Export paths for SConscript
	#Respect {C,CXX,LD}FLAGS. Bug #317519
	unset CFLAGS
	export CXXFLAGS="${CXXFLAGS} ${extraflags}"
	#export LINKFLAGS="${LDFLAGS}"
	export LIBPATH="/usr/$(get_libdir)"
}

src_compile() {

	# chicanery to use the correct compiler
	local cxx=$(type -P $(tc-getCXX))
	mkdir -p "${T}/bin"
	ln -s "${cxx}" "${T}/bin/g++" && \
	export PATH="${T}/bin:${PATH}"

	scons ${MAKEOPTS} ${mysconsargs} || die
}

src_install() {

	scons ${MAKEOPTS} ${mysconsargs} install || die

	dodoc README*

	insinto /usr/share/doc/${PF}/pdf
	doins Mixxx-Manual.pdf
}
