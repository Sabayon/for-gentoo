# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils java-pkg-2

DESCRIPTION="Lightstreamer Server (Moderato Edition, Free)"

MY_PN="Lightstreamer_Moderato"
MY_PV="5_0_a1"
MY_BRANCH="Colosseo_20120504"
MY_NAME="${MY_PN}_${MY_PV}_${MY_BRANCH}"
MY_TARBALL="${MY_NAME}.tar.gz"

SLOT="0"
SRC_URI="http://www.lightstreamer.com/download/1018/${MY_TARBALL}"
HOMEPAGE="http://www.lightstreamer.com"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
LICENSE="lightstreamer"

IUSE=""

RDEPEND="!www-servers/lightstreamer-allegro
	!www-servers/lightstreamer-presto
	!www-servers/lightstreamer-vivace
	>=virtual/jre-1.6"
DEPEND=">=virtual/jre-1.6"

S="${WORKDIR}/Lightstreamer"

LS_USER="lightstreamer"
LS_GROUP="lightstreamer"

pkg_setup() {
	java-pkg-2_pkg_setup
	enewgroup "${LS_GROUP}"
	enewuser "${LS_USER}" 265 -1 /dev/null "${LS_GROUP}"
}

src_compile() { echo; }

src_install() {
	dodir /opt/Lightstreamer
	dodir /etc/init.d

	DESTDIR="${ED}" \
	INIT_DIR="${ED}/etc/init.d" \
	LS_USER=${LS_USER} LS_GROUP=${LS_GROUP} \
	LS_ADD_SERVICE="0" LS_INTERACTIVE="0" \
		"${S}"/bin/unix-like/install/Gentoo/install.sh \
			|| die "Cannot install Lightstreamer"

	# tweak JAVA_HOME
	sed -i '/^JAVA_HOME/ s/JAVA_HOME=".*"/JAVA_HOME="`java-config --jre-home`"/' \
		"${ED}/opt/Lightstreamer/bin/unix-like/LS.sh" || die "cannot tweak JAVA_HOME"

	# Remove Java 1.5 libs, not needed with >=1.6
	rm "${ED}/opt/Lightstreamer/lib/native" -rf
}

pkg_postinst() {
	elog
	elog "You have installed Lightstreamer Moderato."
	elog "This edition requires a valid (free) license key"
	elog "obtainable at:"
	elog "http://www.lightstreamer.com/download"
	elog
}
