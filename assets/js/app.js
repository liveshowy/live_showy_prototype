// We import the CSS which is extracted to its own file by esbuild.
// Remove this line if you add a your own CSS build pipeline (e.g postcss).
import "../css/app.css"

// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "./vendor/some-package.js"
//
// Alternatively, you can `npm install some-package` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"
import _ from 'underscore'

let throttleMs = 50

let Hooks = {
  TrackTouchEvents: {
    mounted() {
      console.log(`TrackTouchEvents mounted!`)

      // DOCS: https://developer.mozilla.org/en-US/docs/Web/API/Touch_events/Using_Touch_Events
      const pushTouchEvents = _.throttle(e => {
        const {clientX, clientY} = e.touches[0]
        this.pushEvent("touch-event", {clientX, clientY})
      }, throttleMs)

      // DOCS: https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent
      const pushMouseEvents = _.throttle(e => {
        const {clientX, clientY, buttons} = e
        // Only send events if a button is pressed
        if (buttons !== 0) {
          this.pushEvent("mouse-event", {clientX, clientY})
        }
      }, throttleMs)

      this.el.addEventListener('touchmove', pushTouchEvents)

      this.el.addEventListener('mousemove', pushMouseEvents)
    },
  }
}

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
  params: {_csrf_token: csrfToken},
  hooks: Hooks,
})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", info => topbar.show())
window.addEventListener("phx:page-loading-stop", info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket
