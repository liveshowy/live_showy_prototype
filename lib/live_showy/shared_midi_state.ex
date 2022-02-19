defmodule LiveShowy.SharedMidiState do
  @moduledoc """
  A GenServer-controlled ETS table to manage shared Midi state between users.

  - As users pass note-on events, call increment_key/1 to indicate users playing a note.
  - As users pass note-off events, call decrement_key/1 to indicate users releasing a note.
  """
  use GenServer
  alias LiveShowy.MidiDevices

  def start_link(_state) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @doc """
  Handle note-off messages
  """
  def write_message(output, {status, note, _velocity} = message) when status >= 144 do
    increment_key(note)
    MidiDevices.maybe_write_message(output, message)
    {:note_on, message}
  end

  def write_message(output, {status, note, _velocity} = message) when status in 128..143 do
    active_players =
      note
      |> decrement_key()
      |> get_key()

    if active_players in [0, nil] do
      MidiDevices.maybe_write_message(output, message)
      {:note_off, message}
    else
      {:note_on, message}
    end
  end

  def inspect do
    GenServer.call(__MODULE__, :inspect)
  end

  def list() do
    GenServer.call(__MODULE__, :list)
  end

  def get_key(key) when is_integer(key) do
    GenServer.call(__MODULE__, {:get, key})
  end

  def increment_key(key) when is_integer(key) do
    GenServer.cast(__MODULE__, {:increment, key})
    key
  end

  def decrement_key(key) when is_integer(key) do
    GenServer.cast(__MODULE__, {:decrement, key})
    key
  end

  def delete_key(key) when is_integer(key) do
    GenServer.cast(__MODULE__, {:delete, key})
    key
  end

  # SERVER

  @impl true
  def init(_) do
    :ets.new(__MODULE__, [:named_table, :set, write_concurrency: true, read_concurrency: true])

    {:ok, nil}
  end

  @impl true
  def handle_call(:inspect, _from, state) do
    {:reply, state, state}
  end

  def handle_call(:list, _from, state) do
    {:reply, :ets.tab2list(__MODULE__), state}
  end

  def handle_call({:get, key}, _from, state) do
    case :ets.lookup(__MODULE__, key) do
      [{^key, value}] ->
        {:reply, value, state}

      _ ->
        {:reply, nil, state}
    end
  end

  @impl true
  def handle_cast({:increment, key}, state) do
    :ets.update_counter(__MODULE__, key, 1, {key, 0})
    {:noreply, state}
  end

  def handle_cast({:decrement, key}, state) do
    :ets.update_counter(__MODULE__, key, {2, -1, 0, 0}, {key, 0})
    {:noreply, state}
  end

  def handle_cast({:delete, key}, state) do
    :ets.delete(__MODULE__, key)
    {:noreply, state}
  end
end
