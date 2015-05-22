# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# cvs -d :pserver:alistair64@cvs.dev.java.net:/cvs login
# cvs -d :pserver:alistair64@cvs.dev.java.net:/cvs export -r rel-1_5_1-fcs j3d-core-utils
# tar -cjf j3d-core-utils-1.5.1.tar.bz2 j3d-core-utils/
# cvs -d :pserver:alistair64@cvs.dev.java.net:/cvs export -r rel-1_5_1-fcs j3d-core
# tar -cjf j3d-core-1.5.1.tar.bz2 j3d-core

# TODO Look to actually splitting this into 2 packages.
# Maybe not.  j3d-core-utils requires j3d-core's build.xml files to build.
# they are more or less the same package.  Maybe just add a use flag to install
# utils jar/javadoc

EAPI=2
WANT_ANT_TASKS="ant-nodeps"
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION=" Java3D Core API and Utils package"
HOMEPAGE="https://java3d.dev.java.net/"
SRC_URI="http://dev.gentoo.org/~ali_bush/distfiles/${P}.tar.bz2
		http://dev.gentoo.org/~ali_bush/distfiles/${PN}-utils-${PV}.tar.bz2"

LICENSE="|| ( sun-jrl sun-jdl )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

COMMON_DEP="dev-java/vecmath"

RDEPEND=">=virtual/jre-1.5
		${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
		app-arch/unzip
		dev-java/eclipse-ecj:3.7[ant]
		dev-java/vecmath
		${COMMON_DEP}"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	mkdir -p vecmath/build/opt/lib/ext vecmath/build/debug/lib/ext
	cd vecmath/build/opt/lib/ext
	java-pkg_jarfrom vecmath
	cd "${WORKDIR}/vecmath/build/debug/lib/ext"
	java-pkg_jarfrom vecmath
}

EANT_BUILD_TARGET="jar-opt"
EANT_DOC_TARGET="docs"
ANT_OPTS="-Xmx1g"
JAVA_PKG_FORCE_COMPILER="ecj-3.7"

src_install() {

	local arch=""
	use x86 && arch="linux-i586"
	use amd64 && arch="linux-amd64"
	java-pkg_dojar build/default/opt/lib/ext/*.jar
	java-pkg_doso build/default/opt/native/*.so
	use doc && dohtml "build/${arch}/javadocs"
	use source && java-pkg_dosrc src/classes/jogl/javax src/classes/share/javax \
		src/classes/x11/javax src/classes/win32/javax
}
