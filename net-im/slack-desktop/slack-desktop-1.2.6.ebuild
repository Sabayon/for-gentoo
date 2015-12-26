# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit eutils unpacker python-r1

DESCRIPTION="a messaging app for teams"
HOMEPAGE="https://slack.com/"
SRC_BASE="https://slack-ssb-updates.global.ssl.fastly.net/linux_releases/${P}"
SRC_URI="
	amd64? ( ${SRC_BASE}-amd64.deb )
	x86?   ( ${SRC_BASE}-i386.deb )
"
QA_EXECSTACK="usr/share/slack/slack"
QA_PRESTRIPPED="/usr/share/slack/slack
		/usr/share/slack/libnode.so
		/usr/share/slack/libgcrypt.so.11
		/usr/share/slack/libnotify.so.4"

LICENSE="Apache-2.0 MIT WTFPL-2 ISC BSD no-source-code"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="gnome-base/gconf:2
	x11-libs/gtk+:2
	x11-libs/gtk+:3
	virtual/libudev:=
	dev-libs/libgcrypt:=
	x11-libs/libnotify
	x11-libs/libXtst
	>=dev-libs/nss-3.0
	gnome-base/gvfs
	x11-misc/xdg-utils
	gnome-base/libgnome-keyring"
RDEPEND=${DEPEND}

S=${WORKDIR}

src_install(){
	insinto "/usr/share/"
	doins -r "usr/share/slack"
	fperms 0755 "/usr/share/slack/libnode.so"
	fperms 0755 "/usr/share/slack/slack"
	doins -r "usr/share/lintian"
	doicon "usr/share/pixmaps/slack.png"
	domenu "usr/share/applications/slack.desktop"
	dodoc  "usr/share/doc/slack/copyright"
	# Install cronjob
	insinto "/etc/"
	doins -r "etc/cron.daily"
	fperms 0755 "/etc/cron.daily/slack"
	# Symlinking bin file in bin
	dosym "/usr/share/slack/slack" "/usr/bin/slack"
}
