# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="bolt-launcher"

DESCRIPTION="jagex launcher third party launcher"

HOMEPAGE="https://github.com/Adamcake/Bolt/"

SRC_URI="
https://github.com/Adamcake/Bolt/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
https://adamcake.com/cef/cef-114.0.5735.134-linux-x86_64-minimal-ungoogled.tar.gz
https://github.com/fmtlib/fmt/archive/0c9fce2ffefecfdce794e1859584e25877b7b592.tar.gz -> fmt-0c9fce2.tar.gz
https://github.com/tidwall/hashmap.c/archive/f5b39e9e4a7798e6c278096a1549f38eff3a4178.tar.gz -> hashmap-f5b39e9.tar.gz
https://github.com/randy408/libspng/archive/adc94393dbeddf9e027d1b2dfff7c1bab975224e.tar.gz -> spng-adc9439.tar.gz
"

S="${WORKDIR}"

LICENSE="AGPL-3"

SLOT="0"


KEYWORDS="~amd64 ~x86"

RESTRICT=""

BDEPEND="
x11-libs/libX11
x11-libs/libxcb
app-arch/libarchive
dev-lang/luajit
dev-build/cmake
dev-vcs/git
"
RDEPEND="
dev-libs/nss
dev-ml/fmt
sys-apps/dbus
media-libs/alsa-lib
"

src_unpack() {
	default

	tar -xf "${DISTDIR}/fmt-0c9fce2.tar.gz" -C "${S}/Bolt-${PV}/modules/fmt" --strip-components=1
	tar -xf "${DISTDIR}/hashmap-f5b39e9.tar.gz" -C "${S}/Bolt-${PV}/modules/hashmap" --strip-components=1
	tar -xf "${DISTDIR}/spng-adc9439.tar.gz" -C "${S}/Bolt-${PV}/modules/spng" --strip-components=1


}

src_compile(){
	cmake -S Bolt-${PV} -B build -G "Unix Makefiles" -D CMAKE_BUILD_TYPE=Release -D CEF_ROOT="${S}"/cef_binary_114.2.11+g87c8807+chromium-114.0.5735.134_linux64_minimal -D CMAKE_INSTALL_PREFIX="/" -D BOLT_BINDIR=usr/bin -D BOLT_LIBDIR=usr/lib -D BOLT_SHAREDIR=usr/share -D BOLT_META_NAME="${MY_PN}" -D BOLT_SKIP_LIBRARIES=1
	cmake --build build
}

src_install() {
	DESTDIR="${D}" cmake --install build
	insinto /usr/share/applications
    doins "${FILESDIR}/bolt-launcher.desktop"
}
