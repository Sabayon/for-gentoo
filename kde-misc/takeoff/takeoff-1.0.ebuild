# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

EAPI=4

KDE_MINIMAL="4.8"
KDE_LINGUAS="ca de el es gl it pl ru tr"
inherit kde4-base

DESCRIPTION="Takeoff is a full screen menu inspired in the aspect of Slingshot and the OS X Launchpad menu but adapted to the KDE users in a plasmoid"
HOMEPAGE="http://code.google.com/p/takeoff-launcher/"
SRC_URI="https://takeoff-launcher.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="$(add_kdebase_dep plasma-workspace)"

S="${WORKDIR}/${PN}"
