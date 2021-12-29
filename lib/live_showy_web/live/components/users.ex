defmodule LiveShowyWeb.Live.Components.Users do
  @moduledoc false
  use Phoenix.Component

  def list(assigns) do
    user_count = Enum.count(assigns.users)

    ~H"""
    <div>
      <span class="font-mono text-xs">
        <%= user_count %> active <%= if user_count == 1, do: "user", else: "users" %>
      </span>
      <div class="gap-2 py-2 font-mono select-none columns-lg">
        <%= for user <- Enum.sort_by(@users, & &1.username) do %>
          <.list_item id={"#{user.id}-username"} user={user} current_user_id={@current_user_id} />
        <% end %>
      </div>
    </div>
    """
  end

  def list_item(assigns) do
    ~H"""
    <div class="flex items-center gap-2 select-none">
      <button
        type="button"
        phx-click={if @user.id == @current_user_id, do: "set-new-color"}
        class="w-4 h-4 rounded-full shadow cursor-pointer"
        style={"background-color: #{@user.color}"}
      ></button>

      <span><%= @user.username %></span>
    </div>
    """
  end
end
