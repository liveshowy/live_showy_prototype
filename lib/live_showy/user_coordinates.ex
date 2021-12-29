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

  @doc """
  Store XY coordinates for a user.
  """
  def put_coords(user_id, [x, y] = coords) when is_number(x) and is_number(y) do
    :ets.insert(__MODULE__, {user_id, coords})
    [x, y]
  end

  @doc """
  Get a user's coordinates. If none exist, generate random coords.
  """
  def get_coords(user_id) do
    case :ets.lookup(__MODULE__, user_id) do
      [{^user_id, coords}] -> coords
      [] -> put_coords(user_id, [Enum.random(0..90), Enum.random(0..90)])
    end
  end

  @doc """
  Remove a user's coordinates.
  """
  def remove_coords(user_id) do
    :ets.delete(__MODULE__, user_id)
  end

  @doc """
  List all user coordinates.
  """
  def list_coords, do: :ets.tab2list(__MODULE__)
  def get_first_key, do: :ets.first(__MODULE__)
  def get_next_key(previous_key), do: :ets.next(__MODULE__, previous_key)
end
