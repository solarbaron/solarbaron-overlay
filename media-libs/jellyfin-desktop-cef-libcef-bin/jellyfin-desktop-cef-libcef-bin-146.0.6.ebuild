# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic

DESCRIPTION="CEF SDK for jellyfin-desktop-cef"
HOMEPAGE="https://bitbucket.org/chromiumembedded/cef"

CEF_VERSION="146.0.6+g68649e2+chromium-146.0.7680.154"
SRC_URI="https://cef-builds.spotifycdn.com/cef_binary_${CEF_VERSION}_linux64_minimal.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror strip"

RDEPEND="
	media-libs/alsa-lib
	app-accessibility/at-spi2-core
	x11-libs/cairo
	net-print/cups
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libxkbcommon
	x11-libs/libXrandr
	dev-libs/nss
	dev-libs/nspr
	x11-libs/pango
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-build/cmake
	dev-build/ninja
"

S="${WORKDIR}/cef_binary_${CEF_VERSION}_linux64_minimal"

src_configure() {
	# Strip fortify source flags that conflict with CEF build
	filter-flags '-Wp,-D_FORTIFY_SOURCE=*'

	cmake -B "${S}/build" -G Ninja \
		-DCMAKE_BUILD_TYPE=Release \
		"${S}" || die "cmake configure failed"
}

src_compile() {
	cmake --build "${S}/build" --target libcef_dll_wrapper || die "cmake build failed"
}

src_install() {
	# Headers
	insinto /opt/jellyfin-desktop-cef/libcef/include
	doins -r include/*

	# Libraries and resources
	insinto /opt/jellyfin-desktop-cef/libcef/lib
	doins -r Release/*
	doins -r Resources/*

	# Find the built wrapper library wherever cmake placed it
	local wrapper_lib=$(find "${S}/build" -name 'libcef_dll_wrapper.a' -o -name 'liblibcef_dll_wrapper.a' | head -1)
	if [[ -z "${wrapper_lib}" ]]; then
		# Debug: show what .a files exist
		einfo "Contents of ${S}/build:"
		find "${S}/build" -name '*.a' -ls
		die "Could not find libcef_dll_wrapper.a"
	fi
	einfo "Found wrapper library at: ${wrapper_lib}"
	doins "${wrapper_lib}"

	# Fix permissions on shared libraries and chrome-sandbox
	fperms 0755 /opt/jellyfin-desktop-cef/libcef/lib/libcef.so
	fperms 0755 /opt/jellyfin-desktop-cef/libcef/lib/libEGL.so
	fperms 0755 /opt/jellyfin-desktop-cef/libcef/lib/libGLESv2.so
	fperms 0755 /opt/jellyfin-desktop-cef/libcef/lib/libvk_swiftshader.so
	fperms 0755 /opt/jellyfin-desktop-cef/libcef/lib/libvulkan.so.1
	fperms 4755 /opt/jellyfin-desktop-cef/libcef/lib/chrome-sandbox

	# License
	dodoc LICENSE.txt
}
