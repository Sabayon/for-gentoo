# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

inherit ruby-fakegem

if [[ ${PV} == 9999 ]]; then
	git-r3
	EGIT_REPO_URI="https://github.com/evilsocket/bettercap/"
fi

DESCRIPTION=""
HOMEPAGE=""
SRC_URI="https://github.com/evilsocket/bettercap/archive/v${PV}.tar.gz -> bettercap-${PV}.tar.gz"
RESTRICT="mirror"
if [[ ${PV} == 9999 ]]; then
    SRC_URI=""
fi

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~arm"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	net-libs/libpcap"

ruby_add_rdepend "
	>=dev-ruby/colorize-0.7.5
	>=dev-ruby/packetfu-1.1.0
	>=dev-ruby/pcaprub-0.12.0"

