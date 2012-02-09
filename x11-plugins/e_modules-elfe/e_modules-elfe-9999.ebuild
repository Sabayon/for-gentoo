# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

ESVN_SUB_PROJECT="E-MODULES-EXTRA"
ESVN_URI_APPEND="${PN#e_modules-}"
inherit enlightenment

DESCRIPTION="Enlightenment Launcher for embedded devices"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-wm/enlightenment:0.17
	>=media-libs/elementary-9999
	>=media-libs/edje-9999"

RDEPEND="${DEPEND}"
