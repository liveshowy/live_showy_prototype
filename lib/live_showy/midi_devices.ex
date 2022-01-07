defmodule LiveShowy.MidiDevices do
  @moduledoc """
  A GenServer for managing with MIDI devices connected to a server.
  """
  use GenServer
  require Logger

  def start_link(_state) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl true
  def init(_) do
    :ets.new(__MODULE__, [
      :named_table,
      :set,
      :public,
      write_concurrency: false,
      read_concurrency: true
    ])

    set_devices()

    with {:ok, devices} <- Application.fetch_env(:live_showy, __MODULE__),
         output when is_binary(output) <- devices[:output] do
      set_device(:output, output)
    else
      _ -> raise("No MIDI devices configured")
    end

    {:ok, nil}
  end

  @doc """
  Places a list of devices from PortMidi into ETS.
  """
  def set_devices() do
    devices = PortMidi.devices()
    :ets.insert(__MODULE__, {:devices, devices})

    for input <- devices.input do
      Logger.info(midi_device_added: input)
    end

    for output <- devices.output do
      Logger.info(midi_device_added: output)
    end

    {:ok, :ets.lookup(__MODULE__, :devices)}
  end

  @doc """
  Retrieves a list of devices from ETS.
  """
  def get_devices() do
    [{_, devices}] = :ets.lookup(__MODULE__, :devices)

    devices
  end

  @doc """
  Places an input or output device PID in ETS.
  """
  def set_device(device_type, device_name) when device_type in [:input, :output] do
    {:ok, pid} = PortMidi.open(device_type, device_name)
    :ets.insert(__MODULE__, {device_type, pid})

    Logger.info(midi_device_set: {device_type, device_name, pid})

    {:ok, :ets.lookup(__MODULE__, device_type)}
  end

  @doc """
  Retrieves an input or output device PID from ETS.
  """
  def get_device(device) when device in [:input, :output] do
    [{_, pid}] = :ets.lookup(__MODULE__, device)
    pid
  end

  def get_device(_invalid_device), do: {:error, "not supported"}

  @doc """
  Removes an input or output device from ETS.
  """
  def remove_device(device) when device in [:input, :output] do
    :ets.delete(__MODULE__, device)

    Logger.info(midi_device_removed: device)

    {:ok}
  end

  def remove_device(_invalid_device), do: {:error, "not supported"}
end
