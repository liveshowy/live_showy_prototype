defmodule Loomer.Users do
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl true
  def init(_) do
    :ets.new(
      __MODULE__,
      [:named_table, :public, write_concurrency: true, read_concurrency: true]
    )

    {:ok, nil}
  end

  def put_user(username) do
    user = Loomer.Protocols.User.new(username)
    :ets.insert_new(__MODULE__, {user.id, user})

    user
  end

  def get_user(id) do
    case :ets.lookup(__MODULE__, id) do
      [{^id, user}] -> user
      [] -> nil
    end
  end

  def update_user(id, params) when is_map(params) do
    updated_user =
      get_user(id)
      |> Map.merge(params)

    :ets.insert(__MODULE__, {id, updated_user})
  end

  def get_first_key, do: :ets.first(__MODULE__)
  def get_next_key(previous_key), do: :ets.next(__MODULE__, previous_key)
end
