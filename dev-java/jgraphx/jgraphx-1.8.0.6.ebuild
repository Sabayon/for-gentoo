# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2 versionator

MY_PV=$(replace_all_version_separators '_')

DESCRIPTION="Open-source graph component for Java"
HOMEPAGE="http://www.jgraph.com"
SRC_URI="http://www.jgraph.com/downloads/jgraphx/archive/${PN}-${MY_PV}.zip -> ${P}.zip"

SLOT="1.8"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples source"

DEPEND="
	>=virtual/jdk-1.5
	app-arch/unzip"
RDEPEND=">=virtual/jre-1.5"

S="${WORKDIR}/${PN}"

src_prepare() {
	# don't do javadoc always
	sed -i \
		-e 's/depends="doc"/depends="compile"/' \
		build.xml || die "sed failed"
	rm -rf doc/api lib/jgraphx.jar || die
}

EANT_BUILD_TARGET="build"
EANT_DOC_TARGET="doc"

src_install() {
	java-pkg_dojar lib/${PN}.jar

	use doc && java-pkg_dojavadoc docs/api
	use source && java-pkg_dosrc src/org
	use examples && java-pkg_doexamples examples
}
