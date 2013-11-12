# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit multilib-build

DESCRIPTION="Virtual package for FFmpeg implementation"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x64-macos ~x86-solaris"
IUSE="X +encode gsm jpeg2k mp3 sdl speex theora threads truetype vaapi vdpau x264"

RDEPEND="
	|| (
		>=media-video/ffmpeg-0.10.8:0[X?,encode?,gsm?,jpeg2k?,mp3?,sdl?,speex?,theora?,threads?,truetype?,vaapi?,vdpau?,x264?,${MULTILIB_USEDEP}]
		>=media-video/libav-0.8.9-r1[X?,encode?,gsm?,jpeg2k?,mp3?,sdl?,speex?,theora?,threads?,truetype?,vaapi?,vdpau?,x264?,${MULTILIB_USEDEP}]
	)
"
DEPEND=""
