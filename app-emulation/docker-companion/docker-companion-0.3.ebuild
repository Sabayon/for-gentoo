# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

GOLANG_PKG_IMPORTPATH="github.com/mudler"
GOLANG_PKG_VERSION="d5d006cec9303baadbf2615d2fd0a272eee197e1"
GOLANG_PKG_HAVE_TEST=0

# Declares dependencies
GOLANG_PKG_DEPENDENCIES=(

	"github.com/Sirupsen/logrus:f7f79f7"
	"github.com/codegangsta/cli:222ec6fb7eb8a3da24cfa4017694ba45e3f1f516"
	"github.com/fsouza/go-dockerclient:1d4f4ae73768d3ca16a6fb964694f58dc5eba601"
	"github.com/spf13/jWalterWeatherman:33c24e77fb80341fe7130ee7c594256ff08ccc46"
	"github.com/docker/docker:717842fbdeeec3e3bd56525e998a2ffcb087b4d0"
	"github.com/docker/go-units:5d2041e26a699eaca682e2ea41c8f891e1060444"
	"github.com/golang/net:1aafd77e1e7f6849ad16a7bdeb65e3589a10b2bb -> golang.org/x"
)

inherit golang-single

DESCRIPTION="A mix of tools for Docker"
HOMEPAGE="https://${GOLANG_PKG_IMPORTPATH}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm"

use test && RESTRICT+=" sandbox"

src_prepare() {
	golang-single_src_prepare

	golang_fix_importpath_alias \
		"github.com/spf13/jWalterWeatherman" \
		"github.com/spf13/jwalterweatherman"
}

src_install() {
	golang-single_src_install

}
