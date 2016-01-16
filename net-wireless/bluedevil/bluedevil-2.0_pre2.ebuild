# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit kde4-base git-2

KDE_BUILD_TYPE="live"
# git clone git://anongit.kde.org/bluedevil
EGIT_COMMIT="df662c39b20188716782c5d120be8b4c72e67e42"
EGIT_BRANCH="bluez5"
SRC_URI=""
_calculate_live_repo

MY_P=${PN}-v${PV}
DESCRIPTION="Bluetooth stack for KDE"
HOMEPAGE="http://projects.kde.org/projects/extragear/base/bluedevil"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
SLOT="4"
IUSE="debug"

DEPEND="
	>=net-libs/libbluedevil-2.0_pre1
	x11-misc/shared-mime-info
"
RDEPEND="${DEPEND}
	!net-wireless/kbluetooth
	app-mobilephone/obexd[-server]
	app-mobilephone/obex-data-server
"
S=${WORKDIR}/${MY_P}
