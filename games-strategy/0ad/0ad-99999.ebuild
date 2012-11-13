# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

WX_GTK_VER="2.8"

inherit eutils subversion wxwidgets games

MY_PV="r${PV%_*}-alpha"
MY_P=${PN}-${MY_PV}

DESCRIPTION="A free, real-time strategy game"
HOMEPAGE="http://wildfiregames.com/0ad/"
ESVN_REPO_URI="http://svn.wildfiregames.com/public/ps/trunk"

LICENSE="GPL-2 LGPL-2.1 MIT CCPL-Attribution-ShareAlike-3.0 as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+audio +editor fam +pch test"

RDEPEND="
	~dev-lang/spidermonkey-1.8.5
	dev-libs/boost
	dev-libs/libxml2
	media-gfx/nvidia-texture-tools
	!games-strategy/0ad-data
	media-libs/libpng:0
	media-libs/libsdl[X,opengl,video]
	net-libs/enet:1.3
	net-misc/curl
	sys-libs/zlib
	virtual/jpeg
	virtual/opengl
	audio? ( media-libs/libogg
		media-libs/libvorbis
		media-libs/openal )
	editor? ( x11-libs/wxGTK:$WX_GTK_VER[X,opengl] )
	fam? ( virtual/fam )
	"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( dev-lang/perl )"

S=${WORKDIR}/trunk

pkg_setup() {
	games_pkg_setup

	if ! use pch ; then
		eerror "pch useflag is potentially broken"
		eerror "see http://trac.wildfiregames.com/ticket/1313"
	fi
}

src_unpack() {
	subversion_src_unpack
}

src_configure() {
	cd build/workspaces || die

	# custom configure script
	local myconf
	use fam || myconf="--without-fam"
	use pch || myconf="${myconf} --without-pch"
	use test || myconf="${myconf} --without-tests"
	use audio || myconf="${myconf} --without-audio"

	# don't use bundled sources
	./update-workspaces.sh \
		--with-system-nvtt \
		--with-system-enet \
		--with-system-mozjs185 \
		$(use_enable editor atlas) \
		--bindir="${GAMES_BINDIR}" \
		--libdir="$(games_get_libdir)"/${PN} \
		--datadir="${GAMES_DATADIR}"/${PN} \
		${myconf} || die
}

src_compile() {
	emake -C build/workspaces/gcc verbose=1 || die
}

src_test() {
	cd binaries/system || die
	./test || die "test phase failed"
}

src_install() {
	# data
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r binaries/data/* || die

	# bin
	dogamesbin binaries/system/pyrogenesis || die

	# libs
	exeinto "$(games_get_libdir)"/${PN}
	doexe binaries/system/libCollada.so || die
	if use editor ; then
		doexe binaries/system/libAtlasUI.so || die
	fi

	# other
	dodoc binaries/system/readme.txt || die
	doicon build/resources/${PN}.png || die
	games_make_wrapper ${PN} "${GAMES_BINDIR}/pyrogenesis"
	make_desktop_entry ${PN} ${PN} ${PN}

	# permissions
	prepgamesdirs
}
