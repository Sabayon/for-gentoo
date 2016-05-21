# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI=6
DESCRIPTION="a lightweight hotkey daemon"
HOMEPAGE="https://github.com/wertarbyte/triggerhappy"
SRC_URI="https://github.com/wertarbyte/triggerhappy/archive/release/${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~arm"
IUSE=""
S="${WORKDIR}/${PN}-release-${PV}"

src_compile() {

  emake DESTDIR="${D}" version.h
  default

}
