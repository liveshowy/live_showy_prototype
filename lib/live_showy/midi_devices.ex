defmodule LiveShowy.MidiDevices do
  require Logger

  @registries %{input: HostMidiInputRegistry, output: HostMidiOutputRegistry}

  def open(type, name) when type in [:input, :output] and is_binary(name) do
    case PortMidi.open(type, name) do
      {:ok, pid} ->
        Map.get(@registries, type)
        |> Registry.register(name, pid)

        Logger.info(host_midi_device_opened: {type, name, pid})
        {:ok, pid}

      {:error, reason} ->
        {:error, reason}
    end
  end

  def get_pid(type, name) when type in [:input, :output] and is_binary(name) do
    [{registry_pid, device_pid}] =
      Map.get(@registries, type)
      |> Registry.lookup(name)

    %{registry_pid: registry_pid, device_pid: device_pid}
  end

  def close(type, name) when type in [:input, :output] and is_binary(name) do
    PortMidi.close(type, get_pid(type, name).device_pid)

    Map.get(@registries, type)
    |> Registry.unregister(name)

    Logger.info(host_midi_device_closed: {type, name})
    :ok
  end

  def list_devices(type, registry_pid) when type in [:input, :output] and is_pid(registry_pid) do
    Map.get(@registries, type)
    |> Registry.keys(registry_pid)
  end

  def list_portmidi_devices(type) when type in [:input, :output] do
    PortMidi.devices()
    |> Map.get(type)
  end

  defdelegate list_portmidi_devices, to: PortMidi.devices()

  def write(type, name, {_status, _note, _velocity} = message) do
    %{device_pid: device_pid} = get_pid(type, name)
    PortMidi.write(device_pid, message)
  end

  def write(type, name, {{status, note, velocity}, _timestamp} = _message) do
    write(type, name, {status, note, velocity})
  end
end
