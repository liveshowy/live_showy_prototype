defmodule LiveShowyWeb.Live.Components.UserStatus do
  @moduledoc false
  use Phoenix.Component

  def list_item(assigns) do
    ~H"""
    <li class="flex items-center gap-2 px-4 select-none">
      <button
        type="button"
        phx-click={if @user.id == @current_user_id, do: "set-new-color"}
        class="w-4 h-4 rounded-full shadow cursor-pointer"
        style={"background-color: #{@user.color}"}
      >
      </button>

      <span><%= @user.username %></span>
    </li>
    """
  end
end
