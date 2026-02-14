# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="feishin"

DESCRIPTION="Navidrome compatible music player"

HOMEPAGE="https://github.com/jeffvli/feishin"

SRC_URI="https://github.com/jeffvli/feishin/releases/download/v${PV}/Feishin-linux-x64.tar.xz -> ${P}.tar.xz"

S="${WORKDIR}/Feishin-linux-x64"

LICENSE="GPL-3"

SLOT="0"


KEYWORDS="~amd64 ~x86"

IUSE="appindicator +seccomp libnotify"
RESTRICT="bindist mirror strip test"

RDEPEND="
media-video/mpv
"
src_install() {
	insinto /opt/${MY_PN}
	doins -r *
	fperms +x /opt/${MY_PN}/feishin
	dosym /opt/${MY_PN}/feishin /usr/bin/feishin
	insinto /usr/share/applications
    doins "${FILESDIR}/feishin.desktop"
	}
