defmodule LiveShowy.UserRoles do
  @moduledoc """
  Manages user-role relationships for authorization.

  In LiveShowy, users may have multiple roles. As a user navigates the application and performs actions, `check/1` is called to authorize
  """
  require Logger
  use GenServer
  alias Phoenix.PubSub

  @topic "user_roles"

  def subscribe, do: PubSub.subscribe(LiveShowy.PubSub, @topic)

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
    |> Enum.reduce(%{}, &group_user_roles/2)
  end

  defp group_user_roles({user, role}, result) do
    result
    |> Map.put_new(user, [])
    |> Map.update!(user, &[role | &1])
  end

  def add({user_id, role} = user_role) when is_binary(user_id) and is_atom(role) do
    :ets.insert(__MODULE__, user_role)

    PubSub.broadcast(LiveShowy.PubSub, @topic, {:user_role_added, user_role})

    Logger.info(user_role_added: user_role)

    user_role
  end

  def add({_user_id, _role}) do
    {:error, "user_id must be binary and role must be an atom"}
  end

  def set({user_id, roles}) when is_binary(user_id) and is_list(roles) do
    :ets.delete(__MODULE__, user_id)
    for role <- roles, do: add({user_id, role})
  end

  def remove({user_id, role} = user_role) when is_binary(user_id) and is_atom(role) do
    :ets.delete_object(__MODULE__, user_role)

    PubSub.broadcast(LiveShowy.PubSub, @topic, {:user_role_removed, user_role})

    Logger.info(user_role_removed: user_role)

    user_role
  end

  def remove({_user_id, _role}) do
    {:error, "user_id must be binary and role must be an atom"}
  end

  def get(user_id) do
    :ets.match_object(__MODULE__, {user_id, :_})
    |> Enum.map(&elem(&1, 1))
  end

  def check({user_id, role} = params) when is_binary(user_id) and is_atom(role) do
    case :ets.match_object(__MODULE__, params) do
      [{^user_id, ^role}] ->
        Logger.info(user_role_pass: params)
        true

      _ ->
        Logger.warn(user_role_fail: params)
        false
    end
  end
end
