defmodule LiveShowy.HostMidiDevices.Registry do
  @moduledoc false
  use GenServer

  def start_link({type, name} = device) when type in [:input, :output] and is_binary(name) do
    GenServer.start_link(__MODULE__, device)
  end

  @impl true
  def init({type, name}) when type in [:input, :output] and is_binary(name) do
    case PortMidi.open(type, name) do
      {:ok, pid} ->
        Registry.register(__MODULE__, type, {name, pid})

      {:error, reason} ->
        {:error, reason}
    end
  end
end
