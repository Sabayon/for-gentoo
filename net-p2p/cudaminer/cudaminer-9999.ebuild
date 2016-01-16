EAPI=4
inherit autotools git-2

DESCRIPTION="a CUDA accelerated litecoin mining application based on pooler's CPU miner"
HOMEPAGE="https://github.com/cbuchner1/CudaMiner"
EGIT_REPO_URI="https://github.com/cbuchner1/CudaMiner.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=">=dev-util/nvidia-cuda-toolkit-5.5.0"
DEPEND="${RDEPEND} >=dev-util/nvidia-cuda-sdk-5.5.0"

DOCS=( README.txt LICENSE.txt )

src_prepare() {
	sed -i "s#@CFLAGS@#-O3#g" Makefile.am || die
	eautoreconf
}

src_configure() {
	econf --with-cuda=/opt/cuda
}
