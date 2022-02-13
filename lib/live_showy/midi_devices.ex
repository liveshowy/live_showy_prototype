defmodule LiveShowy.MidiDevices do
  alias LiveShowy.HostMidiDevices.Pool, as: DevicePool

  defdelegate get_devices(type), to: DevicePool
  defdelegate get_device_pid(type, name), to: DevicePool

  def write(name, {_status, _note, _velocity} = message) do
    PortMidi.write(get_device_pid(:output, name), message)
  end

  def write(name, {{status, note, velocity}, _timestamp} = _message) do
    write(name, {status, note, velocity})
  end
end
