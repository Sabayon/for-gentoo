# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit eutils python-single-r1 qmake-utils

DESCRIPTION="Cross platform GUI for several code formatters, beautifiers and indenters"
HOMEPAGE="http://universalindent.sourceforge.net/"
SRC_URI="mirror://sourceforge/universalindent/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug examples html perl php python ruby xml"

DEPEND="dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtscript:4
	x11-libs/qscintilla[qt4(-)]
"
RDEPEND="${DEPEND}
	dev-util/astyle
	dev-util/bcpp
	dev-util/indent
	html? (
		app-text/htmltidy
		perl? ( dev-lang/perl )
	)
	perl? ( dev-perl/Perl-Tidy )
	php? ( dev-php/PEAR-PHP_Beautifier )
	python? ( ${PYTHON_DEPS} )
	ruby? ( dev-lang/ruby )
	xml? ( dev-util/xmlindent )
"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

PATCHES=(
	"${FILESDIR}"/qscintilla-2.10.patch
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default

	# correct translation binaries
	sed -e "s|lupdate-qt4|$(qt4_get_bindir)/lupdate|" \
		-e "s|lrelease-qt4|$(qt4_get_bindir)/lrelease|" \
		-i UniversalIndentGUI.pro || die "sed pro translation binary"

	if use debug; then
		sed -i -e 's:release,:debug,:g' UniversalIndentGUI.pro || die
	fi

	# patch .pro file according to our use flags
	# basic support
	UEXAMPLES="cpp sh"
	local UINDENTERS="shellindent.awk"
	local UIGUIFILES="shellindent gnuindent bcpp astyle"

	if use html; then
		UEXAMPLES="${UEXAMPLES} html"
		UIGUIFILES="${UIGUIFILES} tidy"
		if use perl; then
			UINDENTERS="${UINDENTERS} hindent"
			UIGUIFILES="${UIGUIFILES} hindent"
		fi
	fi

	if use perl; then
		UEXAMPLES="${UEXAMPLES} pl"
		UIGUIFILES="${UIGUIFILES} perltidy"
	fi

	if use php; then
		UEXAMPLES="${UEXAMPLES} php"
		UINDENTERS="${UINDENTERS} phpStylist.php"
		UIGUIFILES="${UIGUIFILES} php_Beautifier phpStylist"
	fi

	if use python; then
		UEXAMPLES="${UEXAMPLES} py"
		UINDENTERS="${UINDENTERS} pindent.py"
		UIGUIFILES="${UIGUIFILES} pindent"
		python_fix_shebang .
	fi

	if use ruby; then
		UEXAMPLES="${UEXAMPLES} rb"
		UINDENTERS="${UINDENTERS} rbeautify.rb ruby_formatter.rb"
		UIGUIFILES="${UIGUIFILES} rbeautify rubyformatter"
	fi

	if use xml; then
		UEXAMPLES="${UEXAMPLES} xml"
		UIGUIFILES="${UIGUIFILES} xmlindent"
	fi

	local IFILES= I=
	for I in ${UINDENTERS}; do
		IFILES="${IFILES} indenters/${I}"
		chmod +x indenters/${I} || die
	done

	for I in ${UIGUIFILES}; do
		IFILES="${IFILES} indenters/uigui_${I}.ini"
	done

	# apply fixes in .pro file
	sed -i -e "/^unix:indenters.files +=/d" UniversalIndentGUI.pro ||
		die ".pro patching failed"
	sed -i -e "s:indenters/uigui_\*\.ini:${IFILES}:" UniversalIndentGUI.pro ||
		die ".pro patching failed"
}

src_configure() {
	eqmake4 UniversalIndentGUI.pro
}

src_install() {
	emake install INSTALL_ROOT="${D}"
	dodoc CHANGELOG.txt readme.html

	doman doc/${PN}.1.gz

	if use examples; then
		docinto examples
		local I
		for I in ${UEXAMPLES}; do
			dodoc indenters/example.${I}
		done
	fi

	newicon resources/universalIndentGUI_512x512.png ${PN}.png
	make_desktop_entry ${PN} UniversalIndentGUI ${PN} "Qt;Development"
}
