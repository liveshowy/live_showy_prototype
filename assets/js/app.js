import "phoenix_html"
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"
import {
  HandleSynth,
  TrackTouchEvents,
  MonitorLatency,
  HandleKeyboardPresses,
  HandleDrumPadPresses,
  HandleWebMidiDevices,
  HandleMetronomeBeats,
} from './hooks'

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
  params: {_csrf_token: csrfToken, userToken},
  hooks: {
    HandleSynth,
    TrackTouchEvents,
    MonitorLatency,
    HandleKeyboardPresses,
    HandleDrumPadPresses,
    HandleWebMidiDevices,
    HandleMetronomeBeats,
  },
  dom: {},
})

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" })

let topBarScheduled = undefined

window.addEventListener("phx:page-loading-start", () => {
  if (!topBarScheduled) {
    topBarScheduled = setTimeout(() => topbar.show(), 200)
  }
})

window.addEventListener("phx:page-loading-stop", () => {
  clearTimeout(topBarScheduled)
  topBarScheduled = undefined
  topbar.hide()
})

liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket
