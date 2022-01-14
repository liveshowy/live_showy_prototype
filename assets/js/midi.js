async function init(onMidiSuccess, onMidiFailure) {
  return await navigator.requestMIDIAccess()
    .then(onMidiSuccess, onMidiFailure)
}

function onMidiSuccess(midiAccess) {
  console.info("MIDI connected")
  return midiAccess
}

function onMidiFailure(message) {
  console.error("MIDI failed to connect:", message)
}

function onMidiMessage(event, liveView) {
  const [status, note, velocity] = event.data
  liveView.pushEvent("midi-message", [status, note, velocity])
}

function onMidiDeviceChange(event, liveView) {
  const {connection, id, manufacturer, name, state, type} = event.currentTarget
  liveView.pushEvent("midi-device-change", {connection, id, manufacturer, name, state, type})
}

module.exports = {
  init,
  onMidiSuccess,
  onMidiFailure,
  onMidiMessage,
  onMidiDeviceChange,
}
