# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit cmake-utils

MY_PN="awayonlock"

DESCRIPTION="Change your status when the screensaver gets activated"
HOMEPAGE="http://costela.net/projects/awayonlock"
SRC_URI="http://costela.net/files/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/pkgconfig
	>=net-im/pidgin-2.4.0
	sys-libs/glibc
	dev-libs/dbus-glib"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}-${PV}"
