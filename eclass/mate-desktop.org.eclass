# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

# @ECLASS: mate-desktop.org.eclass
# @MAINTAINER:
# gnome@gentoo.org
# @AUTHOR:
# Authors: Spidler <spidler@gentoo.org> with help of carparski.
# eclass variable additions and documentation: Gilles Dartiguelongue <eva@gentoo.org>
# @BLURB: Helper eclass for gnome.org hosted archives
# @DESCRIPTION:
# Provide a default SRC_URI for tarball hosted on mate-desktop.org mirrors.

inherit versionator

DEPEND="${DEPEND} app-arch/xz-utils"

# @ECLASS-VARIABLE: MATE_DESKTOP_ORG_MODULE
# @DESCRIPTION:
# Name of the module as hosted on mate-desktop.org mirrors.
# Leave unset if package name matches module name.
: ${MATE_DESKTOP_ORG_MODULE:=$PN}

# @ECLASS-VARIABLE: GNOME_ORG_PVP
# @INTERNAL
# @DESCRIPTION:
# Major and minor numbers of the version number.
: ${GNOME_ORG_PVP:=$(get_version_component_range 1-2)}

SRC_URI="http://pub.mate-desktop.org/releases/${GNOME_ORG_PVP}/${MATE_DESKTOP_ORG_MODULE}-${PV}.tar.xz"
S="${WORKDIR}/${MATE_DESKTOP_ORG_MODULE}-${PV}"
