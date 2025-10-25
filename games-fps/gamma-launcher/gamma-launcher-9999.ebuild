# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Use setuptools PEP517 backend
DISTUTILS_USE_PEP517=setuptools

# Supported Python versions
# MUST be defined *before* inheriting python-r1 (which distutils-r1 does)
PYTHON_COMPAT=( python3_{10..12} )

# git-r3: for Git fetch
# distutils-r1: for standard Python PEP517 builds
inherit git-r3 distutils-r1

DESCRIPTION="S.T.A.L.K.E.R. GAMMA launcher for Linux"
HOMEPAGE="https://github.com/Mord3rca/gamma-launcher"
EGIT_REPO_URI="${HOMEPAGE}.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

# Python runtime dependencies
RDEPEND="
    dev-python/beautifulsoup4[${PYTHON_USEDEP}]
    dev-python/platformdirs[${PYTHON_USEDEP}]
    dev-python/py7zr[${PYTHON_USEDEP}]
    dev-python/unrar[${PYTHON_USEDEP}]
    dev-python/requests[${PYTHON_USEDEP}]
    dev-python/tenacity[${PYTHON_USEDEP}]
    dev-python/tqdm[${PYTHON_USEDEP}]
    dev-python/python-magic[${PYTHON_USEDEP}]
    dev-python/rarfile[${PYTHON_USEDEP}]
    dev-python/gitpython[${PYTHON_USEDEP}]
    dev-python/cloudscraper[${PYTHON_USEDEP}]
    app-arch/unrar
"

# Build-time deps (for potential build-time imports)
BDEPEND="
    ${RDEPEND}
"

# No phase functions needed.
# distutils-r1_src_compile calls python_compile for each impl.
# python_compile defaults to pep517_build (from pep517 eclass).
# distutils-r1_src_install calls python_install for each impl
# and python_install_all.
# python_install defaults to pep517_install (from pep517 eclass).
# python_install_all defaults to einstallerdocs.

