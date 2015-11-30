# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
EGO_PN="gopkg.in/${PN}.v${PV}"

if [[ ${PV} = *9999* ]]; then
	inherit golang-vcs
else
	inherit golang-vcs
	KEYWORDS="~amd64 ~arm"
	EGIT_COMMIT="v${PV}"
fi
inherit golang-build

DESCRIPTION="YAML support for the Go language"
HOMEPAGE="https://github.com/go-yaml/yaml"
LICENSE="LGPL"
SLOT="0"
IUSE=""
DEPEND=""
RDEPEND=""
