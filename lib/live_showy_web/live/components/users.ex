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
          <.list_item id={"#{user.id}-username"} user={user} current_user_id={@current_user_id} editable={@editable} />
        <% end %>
      </div>
    </div>
    """
  end

  defp list_item(assigns) do
    ~H"""
    <div class={get_list_item_class(assigns)} phx-click="edit-user" phx-value-id={@user.id}>
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

  defp get_list_item_class(assigns) do
    base_classes = "flex items-center gap-2 select-none"
    if assigns.editable, do: "#{base_classes} cursor-pointer", else: base_classes
  end

  def table(assigns) do
    user_count = Enum.count(assigns.users)

    ~H"""
    <table class="w-full text-left">
      <caption class="font-mono text-xs text-left">
        <%= user_count %> active <%= if user_count == 1, do: "user", else: "users" %>
      </caption>

      <thead class="text-purple-300">
        <tr>
          <th>USER</th>
          <th>COLOR</th>
          <th>ROLES</th>
          <th>&nbsp;</th>
        </tr>
      </thead>

      <tbody class="font-mono text-sm font-normal">
        <%= for user <- Enum.sort_by(@users, & &1.username) do %>
          <.table_row id={"#{user.id}-username"} user={user} />
        <% end %>
      </tbody>
    </table>
    """
  end

  defp table_row(assigns) do
    ~H"""
    <tr>
      <td><%= @user.username %></td>
      <td><span class={"rounded-full w-4 h-4 bg-[#{@user.color}]"}></span></td>
      <td><%= @user.roles |> Enum.join(", ") %></td>
      <td>
        <button phx-click="edit-user" phx-value-id={@user.id} type="button" class="px-2 transition bg-purple-700 rounded-sm hover:bg-purple-600">EDIT</button>
      </td>
    </tr>
    """
  end
end
