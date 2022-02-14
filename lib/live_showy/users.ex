defmodule LiveShowy.Users do
  @moduledoc """
  GenServer for managing users in an ETS table.
  """
  require Logger
  use GenServer
  alias Phoenix.PubSub
  alias LiveShowy.UserRoles

  @topic "users"

  def subscribe, do: PubSub.subscribe(LiveShowy.PubSub, @topic)

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

  def list do
    :ets.tab2list(__MODULE__)
    |> Enum.map(&elem(&1, 1))
  end

  @doc """
  List users, with an optional preloads map.

  Preload keys will be added to each user, and each preload value must be a module with a get/1 function.
  """
  def list(preloads) when is_map(preloads) do
    Enum.map(list(), &Map.merge(&1, populate_preloads(&1, preloads)))
  end

  defp populate_preloads(user, preloads) do
    for {key, module} <- preloads, into: %{} do
      case apply(module, :get, [user.id]) do
        {_user_id, value} -> {key, value}
        value -> {key, value}
      end
    end
  end

  def map_usernames do
    :ets.tab2list(__MODULE__)
    |> Enum.map(fn {user_id, user} -> {user_id, user.username} end)
    |> Enum.into(%{})
  end

  def add(params \\ nil) do
    user = LiveShowy.Protocols.User.new(params)
    :ets.insert_new(__MODULE__, {user.id, user})
    PubSub.broadcast(LiveShowy.PubSub, @topic, {:user_added, user})

    Logger.info(user_added: user)

    if Enum.count(list()) == 1 do
      LiveShowy.Roles.list()
      |> Enum.map(&UserRoles.add({user.id, &1}))
    end

    user
  end

  def get(id) do
    case :ets.lookup(__MODULE__, id) do
      [{^id, user}] -> user
      [] -> nil
    end
  end

  def update(id, params) when is_map(params) do
    updated_user =
      get(id)
      |> Map.merge(params)

    :ets.insert(__MODULE__, {id, updated_user})
    PubSub.broadcast(LiveShowy.PubSub, @topic, {:user_updated, updated_user})

    Logger.info(user_updated: updated_user)
  end

  def update_username(id, username) when is_binary(username) do
    update(id, %{username: username})
  end

  def update_output_device_name(id, device_name) when is_binary(device_name) do
    update(id, %{output_device_name: device_name})
  end

  def remove(id) do
    :ets.delete(__MODULE__, id)
    PubSub.broadcast(LiveShowy.PubSub, @topic, {:user_removed, id})
    Logger.info(user_removed: id)
  end

  def get_first_key, do: :ets.first(__MODULE__)
  def get_next_key(previous_key), do: :ets.next(__MODULE__, previous_key)
end
