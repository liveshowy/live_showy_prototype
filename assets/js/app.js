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

  HandleSynth: {
    mounted() {
      console.info(`HandleSynth mounted`)

      const midi_note_map = {
        11: 15.434,
        12: 16.352,
        13: 17.324,
        13: 17.324,
        14: 18.354,
        15: 19.445,
        15: 19.445,
        16: 20.602,
        16: 20.602,
        17: 21.827,
        17: 21.827,
        18: 23.125,
        18: 23.125,
        19: 24.5,
        20: 25.957,
        20: 25.957,
        21: 27.5,
        22: 29.135,
        22: 29.135,
        23: 30.868,
        23: 30.868,
        24: 32.703,
        24: 32.703,
        25: 34.648,
        25: 34.648,
        26: 36.708,
        27: 38.891,
        27: 38.891,
        28: 41.203,
        28: 41.203,
        29: 43.654,
        29: 43.654,
        30: 46.249,
        30: 46.249,
        31: 48.999,
        32: 51.913,
        32: 51.913,
        33: 55,
        34: 58.27,
        34: 58.27,
        35: 61.735,
        35: 61.735,
        36: 65.406,
        36: 65.406,
        37: 69.296,
        37: 69.296,
        38: 73.416,
        39: 77.782,
        39: 77.782,
        40: 82.407,
        40: 82.407,
        41: 87.307,
        41: 87.307,
        42: 92.499,
        42: 92.499,
        43: 97.999,
        44: 103.83,
        44: 103.83,
        45: 110,
        46: 116.54,
        46: 116.54,
        47: 123.47,
        47: 123.47,
        48: 130.81,
        48: 130.81,
        49: 138.59,
        49: 138.59,
        50: 146.83,
        51: 155.56,
        51: 155.56,
        52: 164.81,
        52: 164.81,
        53: 174.61,
        53: 174.61,
        54: 185,
        54: 185,
        55: 196,
        56: 207.65,
        56: 207.65,
        57: 220,
        58: 233.08,
        58: 233.08,
        59: 246.94,
        59: 246.94,
        60: 261.63,
        60: 261.63,
        61: 277.18,
        61: 277.18,
        62: 293.66,
        63: 311.13,
        63: 311.13,
        64: 329.63,
        64: 329.63,
        65: 349.23,
        65: 349.23,
        66: 369.99,
        66: 369.99,
        67: 392,
        68: 415.3,
        68: 415.3,
        69: 440,
        70: 466.16,
        70: 466.16,
        71: 493.88,
        71: 493.88,
        72: 523.25,
        72: 523.25,
        73: 554.37,
        73: 554.37,
        74: 587.33,
        75: 622.25,
        75: 622.25,
        76: 659.26,
        76: 659.26,
        77: 698.46,
        77: 698.46,
        78: 739.99,
        78: 739.99,
        79: 783.99,
        80: 830.61,
        80: 830.61,
        81: 880,
        82: 932.33,
        82: 932.33,
        83: 987.77,
        83: 987.77,
        84: 1046.5,
        84: 1046.5,
        85: 1108.7,
        85: 1108.7,
        86: 1174.7,
        87: 1244.5,
        87: 1244.5,
        88: 1318.5,
        88: 1318.5,
        89: 1396.9,
        89: 1396.9,
        90: 1480,
        90: 1480,
        91: 1568,
        92: 1661.2,
        92: 1661.2,
        93: 1760,
        94: 1864.7,
        94: 1864.7,
        95: 1975.5,
        95: 1975.5,
        96: 2093,
        96: 2093,
        97: 2217.5,
        97: 2217.5,
        98: 2349.3,
        99: 2489,
        99: 2489,
        100: 2637,
        100: 2637,
        101: 2793.8,
        101: 2793.8,
        102: 2960,
        102: 2960,
        103: 3136,
        104: 3322.4,
        104: 3322.4,
        105: 3520,
        106: 3729.3,
        106: 3729.3,
        107: 3951.1,
        107: 3951.1,
        108: 4186,
        108: 4186,
        109: 4434.9,
        109: 4434.9,
        110: 4698.6,
        111: 4978,
        111: 4978,
        112: 5274,
        112: 5274,
        113: 5587.7,
        113: 5587.7,
        114: 5919.9,
        114: 5919.9,
        115: 6271.9,
        116: 6644.9,
        116: 6644.9,
        117: 7040,
        118: 7458.6,
        118: 7458.6,
        119: 7902.1,
        119: 7902.1,
        120: 8372,
        120: 8372,
        121: 8869.8,
        121: 8869.8,
        122: 9397.3,
        123: 9956.1,
        123: 9956.1,
        124: 10548,
        124: 10548,
        125: 11175,
        125: 11175,
        126: 11840,
        126: 11840,
        127: 12544,
        128: 13290,
        128: 13290,
        129: 14080,
        130: 14917,
        130: 14917,
        131: 15804,
        132: 16744,
        }
      const tone = new Tone.Synth().toDestination()

      this.handleEvent("update-tone-envelope", ({ attack, decay, sustain, release }) => {
        tone.set({
          envelope: {attack, decay, sustain, release}
        })
      })

      this.handleEvent("midi-message", ({ message }) => {
        const [status, note, velocity] = message
        if (velocity == 0 || (status >= 128 && status <= 143)) {
          return tone.triggerRelease()
        }
        return tone.triggerAttack(midi_note_map[note])
      })
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
