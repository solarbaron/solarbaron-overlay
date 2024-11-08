# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="runelite"

DESCRIPTION="OSRS client with plugin support"

HOMEPAGE="https://runelite.net/"

SRC_URI="
https://github.com/runelite/launcher/releases/download/${PV}/RuneLite.jar
https://raw.githubusercontent.com/runelite/launcher/${PV}/appimage/runelite.png
"

S="${DISTDIR}"

LICENSE="GPL-3"

SLOT="0"


KEYWORDS="~amd64 ~x86"

IUSE="appindicator +seccomp libnotify"
RESTRICT="bindist mirror strip test"

RDEPEND="
virtual/jre
"
src_install() {
	ls
	insinto /usr/share/java/${MY_PN}
	doins RuneLite.jar
	fperms +x /usr/share/java/${MY_PN}/RuneLite.jar
	dosym /usr/share/java/${MY_PN}/RuneLite.jar /usr/bin/runelite
	insinto /usr/share/icons
    doins runelite.png
	insinto /usr/share/applications
    doins "${FILESDIR}/runelite.desktop"
	}
