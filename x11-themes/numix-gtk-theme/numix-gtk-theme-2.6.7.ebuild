# Copyright 2004-2018 Sabayon
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A modern flat theme with a combination of light and dark elements"
HOMEPAGE="http://numixproject.org"

BASE_URI="https://github.com/numixproject/${PN}"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="${BASE_URI}.git"
	KEYWORDS=""
else
	SRC_URI="${BASE_URI}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

DEPEND="dev-ruby/sass
	dev-libs/glib:2
	x11-libs/gdk-pixbuf:2"
RDEPEND="x11-themes/gtk-engines-murrine"
