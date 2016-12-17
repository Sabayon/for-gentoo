# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils perl-module

DESCRIPTION="A frontend for ClamAV using Gtk2-perl"
HOMEPAGE="https://bitbucket.org/dave_theunsub/clamtk/"
SRC_URI="https://bitbucket.org/dave_theunsub/clamtk/downloads/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-1+ )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

LANGS="af ar ast az bg bs ca cs da de el_GR en_AU en_CA en_GB es eu fi fo fr ga gl he hr hu id it ja km ko lo lt lv mr ms nb nl_BE nl nn pa pl pt_BR pt ro ru sk sl sr@latin sv ta te th tr ug uk uz zh_CN zh_TW"
IUSE=""
for i in ${LANGS}; do
	IUSE="${IUSE} linguas_${i}"
done

DEPEND=""
RDEPEND="
	>=app-antivirus/clamav-0.95
	dev-perl/JSON
	dev-perl/LWP-Protocol-https
	dev-perl/Locale-gettext
	dev-perl/Text-CSV
	dev-perl/glib-perl
	dev-perl/gtk2-perl
	dev-perl/libwww-perl
	virtual/perl-Digest-SHA
	virtual/perl-MIME-Base64
	virtual/perl-Time-Piece
"

src_unpack() {
	unpack ${A}
	cd "${S}" || die "cd failed"
	gunzip ${PN}.1.gz || die "gunzip failed"
}

src_install() {
	dobin ${PN}

	doicon images/* || die "doicon failed"
	domenu ${PN}.desktop || die "domenu failed"

	dodoc CHANGES README.md DISCLAIMER
	doman ${PN}.1

	# The custom Perl modules
	perl_set_version
	insinto "${VENDOR_LIB}/ClamTk"
	doins lib/*.pm

	local l
	for l in ${LANGS}; do
		use "linguas_${l}" && domo "po/${l}.mo"
	done
}
