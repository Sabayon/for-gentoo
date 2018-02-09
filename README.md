# [![Build Status](https://travis-ci.org/Sabayon/for-gentoo.svg?branch=master)](https://travis-ci.org/Sabayon/for-gentoo) Sabayon overlay

This is a Gentoo overlay and it contains the ebuilds that could be upstreamed.

If you are submitting a pull request or committing keep in mind:

* If the ebuild/fixes you are submitting are already available in layman, the correct place is [community-repositories](https://github.com/Sabayon/community-repositories)
* If the ebuild/fixes is Sabayon related (e.g. specific tweaking, configurations, metas) the correct place is [sabayon-distro overlay](https://github.com/Sabayon/sabayon-distro)

Here goes:

* ebuilds that propose fixes wrt upstream bugs
* new ebuilds that are not present in Portage, but follows Gentoo ebuild standards
* ebuilds that fixes bad behaviours or fixes bugs that will be submitted upstream

# Layman

This overlay is available in layman:

    layman -a sabayon
