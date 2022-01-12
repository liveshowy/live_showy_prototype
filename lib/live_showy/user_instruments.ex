defmodule LiveShowy.UserInstruments do
  @moduledoc """
  An ETS table for managing user-instrument assignments.
  """
  require Logger
  use GenServer
  alias LiveShowy.Instrument
  alias Phoenix.PubSub

  @topic "user_instruments"

  def get_topic, do: @topic

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl true
  def init(_) do
    :ets.new(
      __MODULE__,
      [
        :named_table,
        :public,
        :set,
        write_concurrency: true,
        read_concurrency: true
      ]
    )

    {:ok, nil}
  end

  def list do
    :ets.tab2list(__MODULE__)
  end

  def add({user_id, %Instrument{} = _instrument} = user_instrument) when is_binary(user_id) do
    :ets.insert(__MODULE__, user_instrument)
    PubSub.broadcast(LiveShowy.PubSub, @topic, {:user_instrument_added, user_instrument})
    Logger.info(user_instrument_added: user_instrument)
    user_instrument
  end

  def get(user_id) when is_binary(user_id) do
    case :ets.match_object(__MODULE__, {user_id, :_}) do
      [{user_id, instrument}] -> {user_id, instrument}
      _ -> nil
    end
  end

  def remove(user_id) when is_binary(user_id) do
    :ets.delete(__MODULE__, user_id)
  end
end
