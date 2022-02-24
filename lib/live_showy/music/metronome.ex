defmodule LiveShowy.Music.Metronome do
  @moduledoc false
  use Timex
  use GenServer
  require Logger
  alias Phoenix.PubSub

  defstruct bpm: 120,
            running: false,
            subdivision: 1,
            time_signature_top: 4,
            time_signature_bottom: 4,
            timer_ref: nil,
            current_beat: 1

  @type t :: %__MODULE__{
          bpm: non_neg_integer(),
          running: boolean(),
          subdivision: non_neg_integer(),
          time_signature_top: list(non_neg_integer()),
          time_signature_bottom: list(non_neg_integer()),
          current_beat: non_neg_integer()
        }

  @topic "music.metronome"

  # API

  def start_link(state \\ %__MODULE__{}) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def subscribe, do: PubSub.subscribe(LiveShowy.PubSub, @topic)

  def run do
    GenServer.cast(__MODULE__, :run)
  end

  def stop do
    GenServer.cast(__MODULE__, :stop)
  end

  def get do
    GenServer.call(__MODULE__, :get_state)
  end

  def get_keys(type \\ :atom) when type in [:atom, :string] do
    keys = Map.keys(get())

    case type do
      :atom ->
        keys

      :string ->
        Enum.map(keys, &Atom.to_string/1)
    end
  end

  def update(params) when is_map(params) do
    prev_state = get()

    params =
      params
      |> Map.update(:bpm, nil, &String.to_integer/1)
      |> Map.update(:subdivision, nil, &String.to_integer/1)
      |> Map.update(:time_signature_top, nil, &String.to_integer/1)
      |> Map.update(:time_signature_bottom, nil, &String.to_integer/1)
      |> Map.update(:running, nil, &(&1 == "true"))

    GenServer.cast(__MODULE__, {:update, params})

    case {params.running, prev_state.running} do
      {true, false} ->
        run()

      {false, true} ->
        stop()

      _ ->
        nil
    end

    get()
  end

  # SERVER

  @impl true
  def init(state) do
    Logger.info(metronome_initialized: state)
    {:ok, state}
  end

  @impl true
  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_call(_request, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_cast(:run, state) do
    state = Map.put(state, :running, true)
    GenServer.cast(__MODULE__, :broadcast_beat)
    PubSub.broadcast!(LiveShowy.PubSub, @topic, :metronome_running)
    Logger.info(metronome: :running)
    {:noreply, state}
  end

  def handle_cast(:stop, %{timer_ref: timer_ref} = state) do
    state = Map.put(state, :running, false)

    if is_reference(timer_ref) do
      Process.cancel_timer(timer_ref)
    end

    PubSub.broadcast!(LiveShowy.PubSub, @topic, :metronome_stopped)
    Logger.info(metronome: :stopped)

    {
      :noreply,
      state
      |> Map.put(:timer_ref, nil)
      |> Map.put(:current_beat, 1)
    }
  end

  def handle_cast(:broadcast_beat, %{running: true} = state) do
    PubSub.broadcast!(LiveShowy.PubSub, @topic, {:metronome_beat, state.current_beat})
    interval_ms = round(60_000 / state.bpm / state.subdivision)
    state = Map.put(state, :timer_ref, Process.send_after(self(), :broadcast_beat, interval_ms))

    {:noreply,
     Map.update!(state, :current_beat, &if(&1 == state.time_signature_top, do: 1, else: &1 + 1))}
  end

  def handle_cast({:update, params}, state) do
    PubSub.broadcast!(LiveShowy.PubSub, @topic, :metronome_updated)
    state = Map.merge(state, params, fn _k, v1, v2 -> v2 || v1 end)
    Logger.info(metronome_updated: params)
    {:noreply, state}
  end

  @impl true
  def handle_info(:broadcast_beat, state) do
    GenServer.cast(__MODULE__, :broadcast_beat)
    {:noreply, state}
  end

  def handle_info({:cancel_timer, _ref, _int}, state) do
    {:noreply, Map.put(state, :timer_ref, nil)}
  end
end
