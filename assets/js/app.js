// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.css"

import "alpinejs"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"
import phoenix from "phoenix"
const {Socket} = phoenix;
import NProgress from "nprogress"
import LiveSocket from "phoenix_live_view"

const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
const liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}})

// Show progress bar on live navigation and form submits
window.addEventListener("phx:page-loading-start", _info => NProgress.start())
window.addEventListener("phx:page-loading-stop", _info => NProgress.done())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

// import "hls.js"
// window.loadHlsUrl = (el, url) => {
//   if (Hls.isSupported()) {
//     const hls = new Hls()
//     hls.loadSource(url)
//     hls.attachMedia(el)
//     return true
//   } else if (audio.canPlayType("application/vnd.apple.mpegurl")) {
//     el.src = url
//     return true
//   } else {
//     return false
//   }
// }

// Default theme. ~960B
import "@vime/core/themes/default.css"

// Optional light theme (extends default). ~400B
import "@vime/core/themes/light.css"
import { VmPlayer, VmAudio, VmHls, VmDefaultUi } from "@vime/core"

// Define custom elements for vime player, providers and ui
customElements.define("vm-player", VmPlayer)
customElements.define("vm-audio", VmAudio)
customElements.define("vm-default-ui", VmDefaultUi)
customElements.define("vm-hls", VmHls)
