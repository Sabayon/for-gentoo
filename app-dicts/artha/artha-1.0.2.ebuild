inherit eutils

DESCRIPTION="A free cross-platform English thesaurus"
HOMEPAGE="http://artha.sourceforge.net/wiki/index.php/Home"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="enchant libnotify"

DEPEND=">=app-dicts/wordnet-3
	>=x11-libs/gtk+-2.12
	>=dev-libs/glib-2.14
	>=dev-libs/dbus-glib-0.70"
RDEPEND="${DEPEND}
	enchant? ( app-text/enchant )
	libnotify? ( >=x11-libs/libnotify-0.4.1 )"

src_install() {
	make DESTDIR=${D} install || die "make install failed"
} 
