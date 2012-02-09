# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

E_PKG_IUSE="doc nls"
inherit enlightenment

DESCRIPTION="Basic widget set, based on EFL with focus mobile touch-screen devices."
HOMEPAGE="http://trac.enlightenment.org/e/wiki/Elementary"

LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~x86"
IUSE="dbus emap fbcon opengl quicklaunch sdl static-libs thumbnails video weather webkit X xcb xdg"

RDEPEND="
	>=dev-libs/ecore-9999[evas,fbcon?,opengl?,sdl?,X?,xcb?]
	>=media-libs/evas-9999[fbcon?,opengl?,sdl?,X?,xcb?]
	>=media-libs/edje-9999
	dbus? ( >=dev-libs/e_dbus-9999 )
	emap? ( >=sci-geosciences/emap-9999 )
	xdg? ( >=dev-libs/efreet-9999 )
	weather? ( >=net-libs/libeweather-9999 )
	webkit? ( >=net-libs/webkit-efl-0.1.96323 )
	thumbnails? ( >=media-libs/ethumb-9999[dbus?] )
	video? ( >=media-libs/emotion-9999 )
	"
DEPEND="${RDEPEND}"

src_configure() {
	export MY_ECONF="
	  ${MY_ECONF}
	  $(use_enable dbus edbus)
	  $(use_enable emap emap)
	  $(use_enable xdg efreet)
	  $(use_enable weather eweather)
	  $(use_enable fbcon ecore-fb)
	  $(use_enable sdl ecore-sdl)
	  $(use_enable X ecore-x)
	  $(use_enable thumbnails ethumb)
	  $(use_enable video emotion)
	  $(use_enable quicklaunch quick-launch)
	  $(use_enable webkit web)
	  --disable-build-examples
	"
	efl_src_configure
} 
