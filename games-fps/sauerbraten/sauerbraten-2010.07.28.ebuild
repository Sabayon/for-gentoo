# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="2"
inherit eutils games

EDITION="justice_edition"

DESCRIPTION="Cube 2: Sauerbraten is an open source game engine (Cube 2) with freeware game data (Sauerbraten)"
HOMEPAGE="http://sauerbraten.org/"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${PV//./_}_${EDITION}_linux.tar.bz2"
LICENSE="ZLIB freedist"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug dedicated doc"

#PATCH_VERSION="2009_06_19"
#SRC_URI="${SRC_URI} mirror://sourceforge/${PN}/patch_${PATCH_VERSION}_linux.tar.bz2 -> ${PN}_${PATCH_VERSION}_patch_linux.tar.bz2"

RDEPEND="
	sys-libs/zlib
	!dedicated? (
		media-libs/libsdl[X,opengl]
		media-libs/sdl-mixer[vorbis]
		media-libs/sdl-image[png,jpeg]
	)"
DEPEND="${RDEPEND}
	>=net-libs/enet-1.2_p20090328
	"

S=${WORKDIR}/${PN}

LIBEXECDIR="${GAMES_PREFIX}/libexec"
DATADIR="${GAMES_DATADIR}/${PN}"
SYSCONFDIR="${GAMES_SYSCONFDIR}/${PN}"

src_prepare() {
	# Remove cruft
	# Not technically nessesary, but will guard against some potential trouble
	ecvs_clean
	rm -rf "${S}"/sauerbraten_unix "${S}"/bin_unix "${S}"/src/{include,lib,vcpp,enet}

	# Patch makefile to use system enet instead of bundled
	epatch "${FILESDIR}"/${P}-system-enet.diff

	# Fix links so they point to the correct directory
	sed -i "${S}"/README.html \
		-e 's:docs/::' \
		|| die "sed README.html failed"
}

src_compile() {
	local builds build
	builds="master server"
	cd "${S}/src"
	use dedicated || builds+=" client"
	for build in ${builds}; do
		emake -j1 CXXFLAGS="${CXXFLAGS}$(use debug && echo " -D_DEBUG")" ${build} || die "make failed!"
	done
}

src_install() {
	if ! use dedicated ; then
		# Install the game data
		insinto "${DATADIR}"
		doins -r data packages || die "doins -r failed"

		# Install the client executable
		exeinto "${LIBEXECDIR}"
		doexe src/sauer_client || die "doexe failed"

		# Install the client wrapper
		games_make_wrapper "${PN}-client" "${LIBEXECDIR}/sauer_client -q\$HOME/.${PN} -r" "${DATADIR}"

		# Create menu entry
		doicon "data/cube.png" || die "doicon failed"
		make_desktop_entry "${PN}-client" "Cube 2: Sauerbraten" cube.png "Game;ActionGame"
	fi

	# Install the server config files
	insinto "${SYSCONFDIR}"
	doins "server-init.cfg" || die "doins failed"

	# Install the server executables
	exeinto "${LIBEXECDIR}"
	doexe src/sauer_{server,master} || die "doexe failed"

	# Install the server wrappers
	games_make_wrapper "${PN}-server" "${LIBEXECDIR}/sauer_server -q\$HOME/.${PN}" "${SYSCONFDIR}"
	cp "${FILESDIR}"/${PN}-master "${T}"/${PN}-master
	sed -i \
		-e "s:%PN%:${PN}:g" \
		-e "s:%LIBEXECDIR%:${LIBEXECDIR}:g" \
		"${T}"/${PN}-master || die "sed failed"
	dogamesbin "${T}"/${PN}-master

	# Install the server init script
	keepdir "${GAMES_STATEDIR}/run/${PN}"
	cp "${FILESDIR}"/${PN}.init "${T}"
	sed -i \
		-e "s:%SYSCONFDIR%:${SYSCONFDIR}:g" \
		-e "s:%LIBEXECDIR%:${LIBEXECDIR}:g" \
		-e "s:%GAMES_STATEDIR%:${GAMES_STATEDIR}:g" \
		"${T}"/${PN}.init || die "sed failed"
	newinitd "${T}"/${PN}.init ${PN} || die "newinitd failed"
	cp "${FILESDIR}"/${PN}.conf "${T}"
	sed -i \
		-e "s:%SYSCONFDIR%:${SYSCONFDIR}:g" \
		-e "s:%LIBEXECDIR%:${LIBEXECDIR}:g" \
		-e "s:%GAMES_USER_DED%:${GAMES_USER_DED}:g" \
		-e "s:%GAMES_GROUP%:${GAMES_GROUP}:g" \
		"${T}"/${PN}.conf || die "sed failed"
	newconfd "${T}"/${PN}.conf ${PN} || die "newconfd failed"

	if use doc ; then
		dodoc src/*.txt docs/dev/*.txt || die "dodoc failed"
		dohtml -r README.html docs/* || die "dohtml failed"
	fi

	prepgamesdirs
	fowners -R ${GAMES_USER_DED} "${SYSCONFDIR}"
}

pkg_postinst() {
	games_pkg_postinst

	elog "If you plan to use map editor feature copy all map data from ${DATADIR}"
	elog "to corresponding folder in your HOME/.${PN}"
}
