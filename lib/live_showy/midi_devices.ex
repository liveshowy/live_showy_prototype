defmodule LiveShowy.MidiDevices do
  require Logger
  alias LiveShowy.HostMidiDevices.Pool, as: DevicePool

  defdelegate get_devices(type), to: DevicePool
  defdelegate get_device_pid(type, name), to: DevicePool

  def write(name, {_status, _note, _velocity} = message) do
    PortMidi.write(get_device_pid(:output, name), message)
  end

  def write(name, {{status, note, velocity}, _timestamp} = _message) do
    write(name, {status, note, velocity})
  end

  def maybe_write_message(pid, message) do
    if is_pid(pid) && Process.alive?(pid) do
      PortMidi.write(pid, message)
    else
      Logger.warn(invalid_midi_pid: pid)
    end
  end
end
