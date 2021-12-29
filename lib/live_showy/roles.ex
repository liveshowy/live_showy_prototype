defmodule LiveShowy.Roles do
  @moduledoc """
  Manages application roles.
  """
  use GenServer
  alias Phoenix.PubSub

  @initial_roles Application.get_env(:live_showy, :initial_roles)
  @topic "roles"

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

    @initial_roles
    |> Enum.map(&add/1)

    {:ok, nil}
  end

  def list do
    case :ets.tab2list(__MODULE__) do
      [roles: roles] -> roles
      [] -> []
    end
  end

  def add(role, broadcast \\ false) when is_atom(role) do
    roles = [role | list()]
    :ets.insert(__MODULE__, {:roles, roles})

    if broadcast do
      PubSub.broadcast(LiveShowy.PubSub, @topic, {:role_added, role})
    end

    role
  end

  def remove(role, broadcast \\ false) when is_atom(role) do
    roles = list() -- [role]
    :ets.insert(__MODULE__, {:roles, roles})

    if broadcast do
      PubSub.broadcast(LiveShowy.PubSub, @topic, {:role_removed, role})
    end

    role
  end
end
