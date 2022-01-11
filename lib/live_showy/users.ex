defmodule LiveShowy.Users do
  @moduledoc """
  GenServer for managing users in an ETS table.
  """
  require Logger
  use GenServer
  alias Phoenix.PubSub
  alias LiveShowy.UserRoles

  @topic "users"

  def get_topic, do: @topic

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

  def list() do
    :ets.tab2list(__MODULE__)
    |> Enum.map(&elem(&1, 1))
  end

  def list_with_roles() do
    list()
    |> Enum.map(fn user -> Map.put(user, :roles, UserRoles.get(user.id)) end)
  end

  def add(params \\ nil) do
    user = LiveShowy.Protocols.User.new(params)
    :ets.insert_new(__MODULE__, {user.id, user})
    PubSub.broadcast(LiveShowy.PubSub, @topic, {:user_added, user})

    Logger.info(user_added: user)

    if Enum.count(list()) == 1 do
      LiveShowy.Roles.list()
      |> Enum.map(&UserRoles.add({user.id, &1}))
    else
      UserRoles.add({user.id, :guest})
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

  def remove(id) do
    :ets.delete(__MODULE__, id)
    PubSub.broadcast(LiveShowy.PubSub, @topic, {:user_removed, id})
    Logger.info(user_removed: id)
  end

  def get_first_key, do: :ets.first(__MODULE__)
  def get_next_key(previous_key), do: :ets.next(__MODULE__, previous_key)
end
