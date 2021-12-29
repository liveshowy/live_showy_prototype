defmodule LiveShowy.Roles do
  @moduledoc """
  Manages roles and user role assignment.
  """

  @initial_roles Application.get_env(:live_showy, :initial_roles)

  def list_roles, do: @initial_roles

  def list_role_users(role_key) do
    Keyword.get(list_roles(), role_key)
  end
end
