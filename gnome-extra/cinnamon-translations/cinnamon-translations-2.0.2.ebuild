# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="Translations for the Cinnamon Desktop Environment."
HOMEPAGE="https://github.com/linuxmint/cinnamon-translations"

SRC_URI="https://github.com/linuxmint/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

LANGUAGES="af am an ar as ast az be be@latin bg bn bn_IN br bs ca ca@valencia crh
cs csb cy da de dz el en_AU en_CA en_GB en@shaw eo es es_AR et eu fa fi fil fo fr
fr_CA ga gd gl gu he hi hr hu hy ia id is it ja jv ka kk km kn ko ksw ku ky la li
lt lv mai mg mk ml mn mr ms my nb nds ne nl nn nso oc om or pa pl ps pt pt_BR ro
ru rue rw si sk sl so sq sr sr@ijekavianlatin sr@latin sv ta te th tlh tpi tr ts
ug uk ur uz uz@cyrillic vi wa xh yi zh_CN zh_HK zh_TW zu"

for lang in ${LANGUAGES}; do
	IUSE+=" linguas_${lang}"
done
unset lang

src_prepare() { :; }
src_configure() { :; }
src_compile() { :; }

src_install() {
	for lang in ${LANGUAGES}; do
		use "linguas_${lang}" || continue
		einfo "Installing language pack for: ${lang}"
		dodir "/usr/share/cinnamon/locale/${lang}"
		insinto "/usr/share/cinnamon/locale/${lang}"
		doins -r "${S}/mo-export/${lang}"/*

	done
}
