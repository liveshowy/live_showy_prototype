defmodule LiveShowy.UserCoordinates do
  @moduledoc """
  A module for managing user coordinates on some stages.
  """
  use GenServer

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
        write_concurrency: true,
        read_concurrency: true
      ]
    )

    {:ok, nil}
  end

  def put_coords(user_id, [x, y] = coords) when is_number(x) and is_number(y) do
    :ets.insert(__MODULE__, {user_id, coords})
  end

  def get_coords(user_id) do
    case :ets.lookup(__MODULE__, user_id) do
      [{^user_id, coords}] -> coords
      [] -> nil
    end
  end

  def remove_coords(user_id) do
    :ets.delete(__MODULE__, user_id)
  end

  def list_coords, do: :ets.tab2list(__MODULE__)
  def get_first_key, do: :ets.first(__MODULE__)
  def get_next_key(previous_key), do: :ets.next(__MODULE__, previous_key)
end
