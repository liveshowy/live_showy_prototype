defmodule Loomer.Midi do
  @moduledoc """
  A GenServer for interacting with MIDI devices connected to a server.
  """
  use GenServer

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

    {:ok, nil}
  end

  def set_devices() do
    :ets.insert(__MODULE__, {:devices, PortMidi.devices()})

    {:ok, :ets.lookup(__MODULE__, :devices)}
  end

  def set_device(device_type, device_name) when device_type in [:input, :output] do
    {:ok, device} = PortMidi.open(device_type, device_name)
    :ets.insert(__MODULE__, {device_type, device})

    {:ok, :ets.lookup(__MODULE__, device_type)}
  end

  def get_device(device) when device in [:input, :output] do
    [{_, pid}] = :ets.lookup(__MODULE__, device)
    pid
  end

  def get_device(_invalid_device), do: {:error, "not supported"}

  def remove_device(device) when device in [:input, :output] do
    :ets.delete(__MODULE__, device)

    {:ok}
  end

  def remove_device(_invalid_device), do: {:error, "not supported"}
end
