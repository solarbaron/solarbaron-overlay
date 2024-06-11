# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="vesktop"

DESCRIPTION="Unofficial modified discord client with several improvements"

HOMEPAGE="https://github.com/Vencord/Vesktop"

SRC_URI="https://github.com/Vencord/Vesktop/releases/download/v1.5.2/${P}.tar.gz"

S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="GPL-3"

SLOT="0"


KEYWORDS="~amd64 ~x86"

IUSE="appindicator +seccomp libnotify"
RESTRICT="bindist mirror strip test"

RDEPEND="
	>=app-accessibility/at-spi2-core-2.46.0:2
	app-crypt/libsecret
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/mesa[gbm(+)]
	net-print/cups
	sys-apps/dbus
	sys-apps/util-linux
	sys-libs/glibc
	x11-libs/cairo
	x11-libs/libdrm
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXScrnSaver
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/libxshmfence
	x11-libs/pango
	appindicator? ( dev-libs/libayatana-appindicator )
	libnotify? ( x11-libs/libnotify )
"
src_install() {
	insinto /opt/${MY_PNPN}
	doins -r *
	fperms +x /opt/${MY_PN}/vesktop
	dosym /opt/${MY_PN}/vesktop /usr/bin/vesktop
	insinto /usr/share/applications
    doins "${FILESDIR}/vesktop.desktop"
	}
