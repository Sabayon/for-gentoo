# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
PYTHON_DEPEND="2:2.5"
PYTHON_RESTRICT_ABIS="3.*"
inherit distutils


DESCRIPTION="A fairly simple module, it provide only raw yEnc
encoding/decoding with builitin crc32 calculation.."
HOMEPAGE="http://sourceforge.net/projects/sabnzbd"
SRC_URI="http://sabnzbd.sourceforge.net/yenc-0.3.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
