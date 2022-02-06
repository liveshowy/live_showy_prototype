defmodule LiveShowy.MidiDevices.Registry do
  use GenServer

  @process_name :midi_device_registry

  # API

  def start_link do
    GenServer.start_link(__MODULE__, nil, name: @process_name)
  end

  def whereis_name(device_name) do
    GenServer.call(@process_name, {:whereis_name, device_name})
  end

  def register_name(device_name, pid) do
    GenServer.call(@process_name, {:register_name, device_name, pid})
  end

  def unregister_name(device_name) do
    GenServer.cast(@process_name, {:unregister_name, device_name})
  end

  def send(device_name, message) do
    case whereis_name(device_name) do
      :undefined ->
        {:badarg, {device_name, message}}

      pid ->
        Kernel.send(pid, message)
        pid
    end
  end

  # SERVER

  def init(_) do
    {:ok, Map.new()}
  end

  def handle_call({:whereis_name, device_name}, _from, state) do
    {:reply, Map.get(state, device_name, :undefined), state}
  end

  def handle_call({:register_name, device_name, pid}, _from, state) do
    case Map.get(state, device_name) do
      nil ->
        {:reply, :ok, Map.put(state, device_name, pid)}

      _ ->
        {:reply, :already_registered, state}
    end
  end

  def handle_cast({:unregister_name, device_name}, state) do
    {:noreply, Map.delete(state, device_name)}
  end
end
