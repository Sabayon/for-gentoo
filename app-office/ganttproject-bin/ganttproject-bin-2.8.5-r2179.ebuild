# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit eutils java-pkg-2

MY_PF=${PN/-bin}-${PVR}
DESCRIPTION="A tool for creating a project schedule by means of Gantt chart and resource load chart"
HOMEPAGE="http://ganttproject.sourceforge.net/"
SRC_URI="mirror://sourceforge/ganttproject/${MY_PF}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/unzip
	>=virtual/jdk-1.4"
RDEPEND="virtual/jre"

S="${WORKDIR}/${MY_PF}"

src_install() {
	insinto /usr/share/${PN}
	doins -r eclipsito.jar plugins-${PV}/ || die

	newbin "${FILESDIR}/${PV}-${PN}" ${PN} || die

	insinto /usr/share/${PN}/examples
	doins *.gan || die

	doicon "${S}/plugins-${PV}/ganttproject/data/resources/icons/ganttproject.png"
	make_desktop_entry ${PN} "GanttProject" ${PN/-bin} "Java;Office;ProjectManagement"
}
