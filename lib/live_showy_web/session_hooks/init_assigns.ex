defmodule LiveShowyWeb.SessionHooks.InitAssigns do
  @moduledoc """
  Ensures common assigns are applied to all LiveViews attaching to this hook.
  """
  import Phoenix.LiveView
  alias LiveShowy.UserRoles
  alias LiveShowy.UserInstruments

  def on_mount(:user, _params, %{"current_user_id" => current_user_id} = _session, socket) do
    {:cont,
     assign(socket,
       current_user:
         LiveShowy.Users.get(current_user_id)
         |> Map.put_new(:roles, UserRoles.get(current_user_id))
         |> Map.put_new(:assigned_instrument, UserInstruments.get(current_user_id) |> elem(1))
     )}
  end

  def on_mount(:default, _params, _session, socket) do
    {:cont, socket}
  end
end
