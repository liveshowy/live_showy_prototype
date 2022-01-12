defmodule LiveShowy.MidiDevices do
  @moduledoc """
  A GenServer for managing MIDI output devices connected to the server.
  """
  use GenServer
  require Logger

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl true
  def init(_) do
    :ets.new(__MODULE__, [
      :named_table,
      :bag,
      :public,
      write_concurrency: false,
      read_concurrency: true
    ])

    {:ok, nil}
  end

  def list() do
    :ets.tab2list(__MODULE__)
  end

  @doc """
  Opens a PortMidi device if it is not already opened, then adds the device pid and name to the ETS table.
  """
  def add(%PortMidi.Device{opened: 0} = device) do
    with type <- get_device_type(device),
         %PortMidi.Device{opened: 0} <- get_portmidi_device_by_name(type, device.name),
         {:ok, pid} <- PortMidi.open(type, device.name),
         device <- Map.put(device, :opened, 1),
         result <- {type, pid, device},
         added? <- :ets.insert_new(__MODULE__, result) do
      if added?, do: Logger.info(midi_output_added: device.name)
      {:ok, result}
    else
      {:error, message} -> {:error, message}
      e -> {:error, e}
    end
  end

  def add(%PortMidi.Device{opened: 1}) do
    {:error, "the provided device is already open"}
  end

  def add(_) do
    {:error, "an unopened PortMidi.Device is required"}
  end

  @doc """
  Removes a PortMidi device from the ETS table and closes it if the process is still alive.
  """
  def remove(%PortMidi.Device{opened: 1} = device) do
    with type <- get_device_type(device),
         %PortMidi.Device{opened: 1} <- get_portmidi_device_by_name(type, device.name),
         {:ok, pid} <- get_device_pid(type, device.name),
         alive? <- Process.alive?(pid),
         deleted? <- :ets.delete_object(__MODULE__, {:output, pid, device}) do
      if alive?, do: PortMidi.close(type, pid)
      if deleted?, do: Logger.info(midi_device_removed: device.name)
      device = Map.put(device, :opened, 0)
      {:ok, device}
    else
      {:error, message} -> {:error, message}
      e -> {:error, e}
    end
  end

  def remove(%PortMidi.Device{opened: 0}) do
    {:error, "the provided device is already closed"}
  end

  def remove(_) do
    {:error, "an opened PortMidi.Device is required"}
  end

  def get_by_name(type, name) when type in [:input, :output] and is_binary(name) do
    input = if type == :input, do: 1, else: 0
    output = if type == :output, do: 1, else: 0
    device = %{name: name, input: input, output: output}

    case :ets.match_object(__MODULE__, {type, :_, device}) do
      [{matched_type, matched_pid, matched_name}] ->
        {matched_type, matched_pid, matched_name}

      [] ->
        nil
    end
  end

  def get_portmidi_device_by_name(type, name) do
    device =
      PortMidi.devices()
      |> Map.get(type)
      |> Enum.filter(fn device -> device.name == name end)
      |> Enum.at(0)

    case device do
      %PortMidi.Device{} -> device
      _ -> nil
    end
  end

  defp get_device_type(%PortMidi.Device{} = device) do
    if device.input == 1 do
      :input
    else
      if device.output == 1 do
        :output
      end
    end
  end

  defp get_device_pid(type, name) when type in [:input, :output] and is_binary(name) do
    case :ets.match_object(__MODULE__, {type, :_, %{name: name}}) do
      [{_type, pid, _device}] ->
        {:ok, pid}

      _ ->
        {:error, "pid not found"}
    end
  end
end
