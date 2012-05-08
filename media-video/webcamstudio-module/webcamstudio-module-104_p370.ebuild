# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils linux-mod subversion toolchain-funcs

DESCRIPTION="Kernel module and helper library for WebcamStudio."
HOMEPAGE="http://www.ws4gl.org/"

# This should be replaced by a snapshot SVN file residing on a Gentoo server
ESVN_REPO_URI="http://webcamstudio.googlecode.com/svn/trunk/trunk/vloopback@370"
# ESVN_STORE_DIR="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}/svn-src/${PN}/0.6-series"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="virtual/linux-sources"
RDEPEND=""

MODULE_NAMES="webcamstudio(misc:${S})"
CONFIG_CHECK="VIDEO_DEV"

pkg_setup() {
	linux-mod_pkg_setup

	rm -f Makefile

	BUILD_PARAMS="-C ${KV_DIR} SUBDIRS=${S} KERNEL_DIR=${KV_DIR}"
	BUILD_TARGETS="modules"
	MODULESD_WEBCAMSTUDIO_ENABLED="yes"
}

src_compile() {
	# We use manual compile of the lib so be compliant to Gentoo flags
	einfo "Compiling helper library..."
	$(tc-getCC) \
		${CPPFLAGS} ${CFLAGS} \
		-fPIC \
		-c -o libwebcamstudio.o libwebcamstudio.c
	$(tc-getCC) \
		${CPPFLAGS} ${CFLAGS} ${LDFLAGS} \
		-fPIC \
		-shared -Wl,-soname,libwebcamstudio.so \
		-o libwebcamstudio.so.1.0.1  \
		libwebcamstudio.o
	ln -s libwebcamstudio.so.1.0.1 libwebcamstudio.so

	linux-mod_src_compile
}

src_install() {
	einfo "Installing helper library..."
	dolib libwebcamstudio.so libwebcamstudio.so.1.0.1

	linux-mod_src_install
}

pkg_postinst() {
	linux-mod_pkg_postinst

	elog "To use WebcamStudio you need to have the \"webcamstudio\" module"
	elog "loaded first."
	elog ""
	elog "If you want to do it automatically, please add \"webcamstudio\" to:"
	if has_version sys-apps/openrc; then
		elog "/etc/conf.d/modules"
	else
		elog "/etc/modules.autoload.d/kernel-${KV_MAJOR}.${KV_MINOR}"
	fi
	elog ""
}

