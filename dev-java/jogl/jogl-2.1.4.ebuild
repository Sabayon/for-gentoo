# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"
WANT_ANT_TASKS="ant-antlr ant-contrib dev-java/cpptasks:0"

inherit java-pkg-2 java-ant-2

#MY_PV="${PV/_rc/_rc0}"
#MY_P="${PN}-${MY_PV}"

DESCRIPTION="Java(TM) Binding fot the OpenGL(TM) API"
HOMEPAGE="http://jogamp.org/jogl/www/"
SRC_URI="https://github.com/sgothel/jogl/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="2.1"
KEYWORDS="~amd64 ~x86"
IUSE="cg"

CDEPEND="
	=dev-java/gluegen-${PV}:${SLOT}
	dev-java/antlr:0
	dev-java/ant-core:0
	x11-libs/libX11
	x11-libs/libXxf86vm
	dev-java/swt:3.7
	virtual/opengl
	cg? ( media-gfx/nvidia-cg-toolkit )"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.5"
DEPEND="${CDEPEND}
	>=virtual/jdk-1.5"

# upstream has a crude way to call the junit tests, which cause a lot of trouble to pass
# our test classpath...
RESTRICT="test"

JAVA_PKG_BSFIX_NAME+=" build-jogl.xml build-nativewindow.xml build-newt.xml"
JAVA_ANT_REWRITE_CLASSPATH="yes"
EANT_BUILD_XML="make/build.xml"
EANT_BUILD_TARGET="init build.nativewindow build.jogl build.newt one.dir tag.build"
EANT_DOC_TARGET=""
EANT_GENTOO_CLASSPATH="gluegen-${SLOT},antlr,ant-core,swt-3.7"
EANT_GENTOO_CLASSPATH_EXTRA="${S}/build/${PN}/*.jar:${S}/build/nativewindow/*.jar"
EANT_NEEDS_TOOLS="yes"

java_prepare() {
	#we keep make/lib/plugin3/puglin3-public.jar
	find -name 'make/lib/swt/*.jar' -delete -print || die

	# Empty filesets are never out of date!
	sed -i -e 's/<outofdate>/<outofdate force="true">/'  make/build*xml || die

	EANT_EXTRA_ARGS+=" -Dcommon.gluegen.build.done=true"
	EANT_EXTRA_ARGS+=" -Dgluegen.root=/usr/share/gluegen-${SLOT}/"
	EANT_EXTRA_ARGS+=" -Dgluegen.jar=$(java-pkg_getjar gluegen-${SLOT} gluegen.jar)"
	EANT_EXTRA_ARGS+=" -Dgluegen-rt.jar=$(java-pkg_getjar gluegen-${SLOT} gluegen-rt.jar)"

	use cg && EANT_EXTRA_ARGS+=" -Djogl.cg=1 -Dx11.cg.lib=/usr/lib"
}

src_install() {
	java-pkg_dojar build/jar/*.jar
	java-pkg_doso build/lib/*.so

	use doc && dodoc -r doc
	use source && java-pkg_dosrc src/jogl/classes/*
}
