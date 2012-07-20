# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

KDE_SCM="git"

inherit kde4-base

DESCRIPTION="KDE-based PackageKit frontend"
HOMEPAGE="https://projects.kde.org/projects/playground/sysadmin/apper"
SRC_URI="mirror://kde/stable/apper/${PV}/src/apper-${PV}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~arm ~x86"
SLOT="4"
IUSE="debug"

COMMON_DEPEND=">=kde-base/kdelibs-4.3.0
	>=app-admin/packagekit-qt4-0.6.17
	>=kde-base/libkworkspace-4.3.0"
DEPEND="${COMMON_DEPEND}
	dev-util/automoc"
RDEPEND="${COMMON_DEPEND}"

src_install() {
       kde4-base_src_install
       # fix dbus service path otherwise conflicting with gnome-packagekit one
       mv "${ED}/usr/share/dbus-1/services/org.freedesktop.PackageKit.service" \
               "${ED}"/usr/share/dbus-1/services/kde-org.freedesktop.PackageKit.service || \
               die "cannot hackily move packagekit dbus service file"
}
