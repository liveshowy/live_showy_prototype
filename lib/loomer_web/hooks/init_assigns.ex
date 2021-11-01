defmodule LoomerWeb.InitAssigns do
  @moduledoc """
  Ensures common assigns are applied to all LiveViews attaching to this hook.
  """

  import Phoenix.LiveView

  def on_mount(:default, _params, _session, socket) do
    {:cont, socket}
  end

  def on_mount(:user, _params, %{"current_user_id" => current_user_id} = _session, socket) do
    {:cont, assign(socket, current_user_id: current_user_id)}
  end
end
