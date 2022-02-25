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
import latency from './latency'
import { init as initMidi, onMidiSuccess, onMidiFailure, onMidiMessage, onMidiDeviceChange } from './midi'
import * as Tone from 'tone'

let Hooks = {
  TrackTouchEvents: {
    mounted() {
      console.info(`TrackTouchEvents mounted`)

      // DOCS: https://developer.mozilla.org/en-US/docs/Web/API/Touch_events/Using_Touch_Events
      const pushTouchEvents = (event) => {
        // TODO: Fix offset on touch devices
        const {clientX: x, clientY: y} = event.targetTouches[0]
        this.pushEvent("touch-event", [x, y])
      }

      // DOCS: https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent
      const pushMouseEvents = (event) => {
        // Only send events if a button is pressed within the element's bounds.
        if (event.buttons !== 0 && !event.relativeTarget) {
          const {offsetX: x, offsetY: y} = event
          this.pushEvent("mouse-event", [x, y])
        }
      }

      // TODO: Throttle these events to 30 fps.
      this.el.addEventListener('touchmove', pushTouchEvents)
      this.el.addEventListener('mousemove', pushMouseEvents)
    },
  },

  MonitorLatency: {
    mounted() {
      console.info(`MonitorLatency mounted`)
      latency.measure(this)
      window.setInterval(() => latency.measure(this), (10 * 1000))
    },

    disconnected() {
      window.clearInterval(latency.measure)
    },
  },

  HandleKeyboardPresses: {
    mounted() {
      console.info(`HandleKeyboardPresses mounted`)

      const noteon = e => {
        const {scrollHeight: height} = e.target
        const value = parseInt(e.target.value, 10)

        const y = e.offsetY
        const velocity = parseInt(parseFloat(y / height) * 127, 10)
        this.pushEvent("midi-message", {message: [144, value, velocity]})
      }

      const noteoff = e => {
        const value = parseInt(e.target.value, 10)
        this.pushEvent("midi-message", {message: [128, value, 0]})
      }

      if ('ontouchstart' in window) {
        this.el.addEventListener('touchstart', noteon)
        this.el.addEventListener('touchend', noteoff)
        this.el.addEventListener('touchcancel', noteoff)
      } else {
        this.el.addEventListener('mousedown', noteon)
        this.el.addEventListener('mouseup', noteoff)
        this.el.addEventListener('mouseleave', noteoff)
      }

    },
  },

  HandleDrumPadPresses: {
    mounted() {
      console.info(`HandleDrumPadPresses mounted`)

      const noteon = e => {
        const value = parseInt(e.target.value, 10)
        this.pushEventTo("#client-midi-devices", "midi-message", [144, value, 127])
      }

      const noteoff = e => {
        const value = parseInt(e.target.value, 10)
        this.pushEventTo("#client-midi-devices", "midi-message", [128, value, 0])
      }

      if ('ontouchstart' in window) {
        this.el.addEventListener('touchstart', noteon)
        this.el.addEventListener('touchend', noteoff)
        this.el.addEventListener('touchcancel', noteoff)
      } else {
        this.el.addEventListener('mousedown', noteon)
        this.el.addEventListener('mouseup', noteoff)
        this.el.addEventListener('mouseleave', noteoff)
      }
    },
  },

  HandleWebMidiDevices: {
    async mounted() {
      console.info(`HandleWebMidiDevices mounted`)
      midiAccess = await initMidi(onMidiSuccess, onMidiFailure, this)

      midiAccess.inputs.forEach(device => {
        if (device.name.match(/^iac/i)) {
          // Ignore IAC pseudo devices
          return
        }
        device.onmidimessage = event => onMidiMessage(event, this)
        device.onstatechange = event => onMidiDeviceChange(event, this)
      })

      midiAccess.outputs.forEach(device => {
        device.onstatechange = event => onMidiDeviceChange(event, this)
      })
    },
  },

  HandleToneJS: {
    mounted() {
      console.info(`HandleToneJS mounted`)
      const synth = new Tone.Synth().toDestination()
      synth.triggerAttackRelease("C4", "8n")
    }
  },

  HandleMetronomeBeats: {
    mounted() {
      console.info(`HandleMetronomeBeats mounted`)
      const tone = new Tone.Synth({
        envelope: {
          attack: 0.005,
          decay: 0.05,
          sustain: 0,
          release: 0.5
        }
      }).toDestination()
      this.handleEvent("metronome-beat", ({ beat }) => {
        const note = beat == 1 ? "C6" : "C5"
        tone.triggerAttack(note)
        }
      )
    },
  },
}

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
  params: {_csrf_token: csrfToken, userToken},
  hooks: Hooks,
  dom: {},
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
