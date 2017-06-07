# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
inherit qt4-r2 git-2

DESCRIPTION="LiteIDE is a simple, open source, cross-platform Go IDE."
HOMEPAGE="http://code.google.com/p/liteide"
EGIT_REPO_URI="https://github.com/visualfc/liteide.git"
MY_ECLASS="git-2"
inherit base eutils ${MY_ECLASS}

LICENSE="LGPL-2.1"
KEYWORDS=""
SLOT="0"
IUSE="ordered"

DEPEND="dev-lang/go
dev-qt/qtgui
dev-qt/qtdbus
dev-qt/qtwebkit
dev-lang/go
dev-qt/qtgui
dev-qt/qtdbus
dev-qt/qtwebkit"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/"${PN}"-"${PV}"/

src_unpack()
{
        git-2_src_unpack base_src_unpack
}

src_prepare() {
        qt4-r2_src_prepare
}

src_configure() {
        local conf_release
        local conf_ordered

        if use ordered ; then
conf_ordered="CONFIG+=ordered"
                conf_release=""
                else
conf_release="CONFIG+=release"
                conf_ordered=""
        fi

cd "${S}"/liteidex/
        eqmake4 "${S}"/liteidex/liteidex.pro "PREFIX=${EPREFIX}/usr" "LIBDIR=/usr/$(get_libdir)" ${conf_release} ${conf_ordered}
}

src_install() {
        cd "${S}"/liteidex/
        qt4-r2_src_install DESTDIR="${D}"usr/lib/${PN}/ INSTALL_ROOT="${D}"usr/lib/${PN}/ || die
        
        export GOPATH=$(pwd)

        # Go Tools
        go install -ldflags "-s" -v tools/goastview
        go install -ldflags "-s" -v tools/godocview
        go install -ldflags "-s" -v tools/goexec
        go install -ldflags "-s" -v tools/goapi

        # Licence & Readme
        dodoc LICENSE.LGPL LGPL_EXCEPTION.TXT ../README.md

        # Binaries
        insinto /usr/bin
        doins "${S}"/liteidex/liteide/bin/liteide
	doins "${S}"/liteidex/bin/go*

        # Bin Libraries
        insinto /usr/lib
        doins "${S}"/liteidex/liteide/bin/libliteapp.so "${S}"/liteidex/liteide/bin/libliteapp.so.1 "${S}"/liteidex/liteide/bin/libliteapp.so.1.0 
"${S}"/liteidex/liteide/bin/libliteapp.so.1.0.0
	
	insinto /usr/share/applications/
	doins "${S}"/liteidex/liteide.desktop

	#Lib Liraries
	insinto /usr/lib/${PN}
        doins "${S}"/liteidex/liteide/lib/${PN}/lib*

        # Plugins
        insinto /usr/lib/${PN}/plugins/
        doins "${S}"/liteidex/${PN}/lib/${PN}/plugins/*.so

        # Documentation
        insinto /usr/share/${PN}/
        doins -r "${S}"/liteidex/deploy/*
        doins -r "${S}"/liteidex/os_deploy/*

        # QT Libraries
        addread /usr/$(get_libdir)/qt4/
        insinto /usr/lib/${PN}
        doins /usr/$(get_libdir)/qt4/libQtCore.so*
        doins /usr/$(get_libdir)/qt4/libQtXml.so*
        doins /usr/$(get_libdir)/qt4/libQtNetwork.so*        
	doins /usr/$(get_libdir)/qt4/libQtGui.so*
        doins /usr/$(get_libdir)/qt4/libQtDBus.so*
        doins /usr/$(get_libdir)/qt4/libQtWebKit.so*

        fperms 755 /usr/bin/liteide
        fperms 755 /usr/bin/goapi
        fperms 755 /usr/bin/goastview
        fperms 755 /usr/bin/godocview
        fperms 755 /usr/bin/goexec
}
