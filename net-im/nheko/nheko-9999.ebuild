# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3 optfeature xdg

DESCRIPTION="Native desktop client for Matrix using Qt"
HOMEPAGE="https://github.com/Nheko-Reborn/nheko"
EGIT_REPO_URI=(
	"https://github.com/Nheko-Reborn/nheko.git"
	"https://github.com/Nheko-Reborn/mtxclient.git"
	"https://nheko.im/nheko-reborn/coeurl.git"
)

LICENSE="GPL-3 MIT"
SLOT="0"
KEYWORDS=""
IUSE="X pipewire video voip"
REQUIRED_USE="video? ( voip )"

MY_GST_V="1.18"
RDEPEND="
	app-text/cmark
	dev-cpp/qt-jdenticon
	>=dev-db/lmdb++-1.0.0
	>=dev-libs/qtkeychain-0.12.0
	dev-libs/spdlog
	dev-qt/qtconcurrent:5
	dev-qt/qtgraphicaleffects:5
	dev-qt/qtgui:5[gif,jpeg,png]
	dev-qt/qtimageformats
	dev-qt/qtmultimedia:5[gstreamer,qml]
	dev-qt/qtquickcontrols2:5
	dev-qt/qtsvg:5
	pipewire? ( media-video/pipewire[gstreamer] )
	voip? (
		>=media-plugins/gst-plugins-dtls-${MY_GST_V}
		media-plugins/gst-plugins-libnice
		>=media-plugins/gst-plugins-meta-${MY_GST_V}[opus]
		>=media-plugins/gst-plugins-srtp-${MY_GST_V}
		>=media-plugins/gst-plugins-webrtc-${MY_GST_V}
		video? (
			>=media-libs/gst-plugins-base-${MY_GST_V}[opengl]
			>=media-plugins/gst-plugins-meta-${MY_GST_V}[v4l,vpx]
			>=media-plugins/gst-plugins-qt5-${MY_GST_V}
			X? (
				>=media-plugins/gst-plugins-ximagesrc-${MY_GST_V}
				x11-libs/xcb-util-wm
			)
		)
	)
"
DEPEND="
	dev-cpp/nlohmann_json
	${RDEPEND}
"
BDEPEND="dev-qt/linguist-tools:5"

src_unpack() {
	for repo_uri in ${EGIT_REPO_URI[@]}; do
		git-r3_fetch ${repo_uri}
		git-r3_checkout ${repo_uri} "${WORKDIR}/${repo_uri##*/}"
	done
	mv nheko.git ${P}
}

src_prepare() {
	# Don't try to download mtxclient and coeurl.
	sed -Ei '/GIT_(REPOSITORY|TAG)/d' CMakeLists.txt || die
	sed -Ei '/GIT_(REPOSITORY|TAG)/d' ../mtxclient.git/CMakeLists.txt || die

	mkdir -p "${WORKDIR}/${P}_build/_deps" || die
	mv ../mtxclient.git "${WORKDIR}/${P}_build/_deps/matrixclient-src" || die
	mv ../coeurl.git "${WORKDIR}/${P}_build/_deps/coeurl-src" || die

	cmake_src_prepare
}

src_configure() {
	local -a mycmakeargs=(
		"-DUSE_BUNDLED_MTXCLIENT=ON"
		"-DUSE_BUNDLED_COEURL=ON"
		"-DBUILD_SHARED_LIBS=OFF"
		"-DVOIP=$(usex voip)"
	)
	if use video && use X; then
		mycmakeargs+=("-DSCREENSHARE_X11=yes")
	else
		mycmakeargs+=("-DSCREENSHARE_X11=no")
	fi

	cmake_src_configure
}

pkg_preinst() {
	einfo "This ebuild bundles mtxclient and coeurl."
	einfo "Oh, and also this is a bit hacky. :-)"
}

src_install() {
	cmake_src_install

	# Remove stuff from bundled libs.
	rm -r "${D}/usr/$(get_libdir)" || die
	rm -r "${D}/usr/include" || die
}

pkg_postinst() {
	optfeature "audio & video file playback support" \
			   "media-plugins/gst-plugins-meta[ffmpeg]"
	optfeature "secrets storage support other than kwallet (gnome-keyring or keepassxc)" \
			   "dev-libs/qtkeychain[gnome-keyring]"

	xdg_pkg_postinst
}
