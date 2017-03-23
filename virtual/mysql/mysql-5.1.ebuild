# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="2"

DESCRIPTION="Virtual for MySQL client or database"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~sparc-fbsd ~x86-fbsd ~x64-macos ~x86-macos ~x86-solaris"
IUSE="embedded minimal static"

DEPEND=""
# TODO: add mysql-cluster here
RDEPEND="|| (
	=dev-db/mysql-${PV}*[embedded=,minimal=,static=]
	=dev-db/mariadb-${PV}*[embedded=,minimal=,static=]
	=dev-db/google-mysql-${PV}*[embedded=,minimal=,static=]
)"
