defmodule LiveShowy.UserRoles do
  @moduledoc """
  Manages user-role relationships for authorization.
  """
  require Logger
  use GenServer
  alias Phoenix.PubSub

  @topic "user_roles"

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
        :bag,
        write_concurrency: true,
        read_concurrency: true
      ]
    )

    {:ok, nil}
  end

  def list do
    :ets.tab2list(__MODULE__)
  end

  def add(user_id, role) when is_binary(user_id) and is_atom(role) do
    params = {user_id, role}
    :ets.insert(__MODULE__, params)

    if LiveShowy.Application.is_pubsub_started?(LiveShowy.PubSub) do
      PubSub.broadcast(LiveShowy.PubSub, @topic, {:user_role_added, params})
    end

    Logger.info(user_role_added: params)
  end

  def add(_user_id, _role) do
    {:error, "user_id must be binary and role must be an atom"}
  end

  def remove(user_id, role) when is_binary(user_id) and is_atom(role) do
    params = {user_id, role}
    :ets.delete_object(__MODULE__, params)

    if LiveShowy.Application.is_pubsub_started?(LiveShowy.PubSub) do
      PubSub.broadcast(LiveShowy.PubSub, @topic, {:user_role_removed, params})
    end

    Logger.info(user_role_removed: params)
  end

  def remove(_user_id, _role) do
    {:error, "user_id must be binary and role must be an atom"}
  end
end
