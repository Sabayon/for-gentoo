# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit kde4-base git-2

KDE_BUILD_TYPE="live"
# git clone git://anongit.kde.org/libbluedevil
EGIT_COMMIT="a46446ff5c770ba1440e2f8c4f5dcc0857f9b0be"
EGIT_BRANCH="bluez5"
SRC_URI=""
_calculate_live_repo

MY_P=${PN}-v${PV}
DESCRIPTION="Qt wrapper for bluez used in the KDE bluetooth stack"
HOMEPAGE="http://projects.kde.org/projects/playground/libs/libbluedevil"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
SLOT="4"
IUSE="debug"

RDEPEND=">=net-wireless/bluez-5.10"

S=${WORKDIR}/${MY_P}
