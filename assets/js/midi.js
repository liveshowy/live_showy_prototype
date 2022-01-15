async function init(onMidiSuccess, onMidiFailure, liveView) {
  if (navigator.requestMIDIAccess) {
    liveView.pushEvent("webmidi-supported", true)
    return await navigator.requestMIDIAccess()
      .then(onMidiSuccess, onMidiFailure)
  }
  liveView.pushEvent("webmidi-supported", false)
  return console.log("WebMIDI is not supported")
}

function onMidiSuccess(midiAccess) {
  console.info("WebMIDI connected")
  return midiAccess
}

function onMidiFailure(message) {
  console.error("WebMIDI failed to connect:", message)
}

function onMidiMessage(event, liveView) {
  const [status, note, velocity] = event.data
  liveView.pushEvent(
    "midi-message",
    {
      device_id: event.currentTarget.id,
      message: [status, note, velocity],
    }
  )
}

function onMidiDeviceChange(event, liveView) {
  const {connection, id, manufacturer, name, state, type} = event.currentTarget
  liveView.pushEvent("midi-device-change", { connection, id, manufacturer, name, state, type })
}

module.exports = {
  init,
  onMidiSuccess,
  onMidiFailure,
  onMidiMessage,
  onMidiDeviceChange,
}
