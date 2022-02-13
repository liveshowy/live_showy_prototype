defmodule LiveShowy.HostMidiDevices.Pool do
  @moduledoc false
  use Supervisor
  alias LiveShowy.HostMidiDevices.Registry, as: HostMidiDevicesRegistry

  @registry HostMidiDevicesRegistry

  def start_link(_) do
    Supervisor.start_link(__MODULE__, [])
  end

  @impl true
  def init(_) do
    %{input: _inputs, output: outputs} = PortMidi.devices()
    device_specs = Enum.map(outputs, &get_device_spec/1)

    supervisor_spec = %{
      id: :host_midi_devices_supervisor,
      type: :supervisor,
      start: {Supervisor, :start_link, [device_specs, [strategy: :one_for_one]]}
    }

    children = [
      {Registry, name: @registry, keys: :duplicate},
      supervisor_spec
    ]

    Supervisor.init(children, strategy: :rest_for_one)
  end

  defp get_device_spec(%PortMidi.Device{} = device) do
    type = if device.input == 1, do: :input, else: :output

    Supervisor.child_spec({@registry, {type, device.name}},
      id: {HostMidiDevices, type, device.name}
    )
  end

  def get_devices(type) when type in [:input, :output] do
    Registry.lookup(@registry, type)
  end

  def get_device_pid(type, name) when type in [:input, :output] and is_binary(name) do
    case Registry.match(@registry, type, {name, :_}) do
      [{_sup_pid, {^name, device_pid}}] ->
        device_pid

      _ ->
        :not_found
    end
  end
end
