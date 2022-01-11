defmodule LiveShowyWeb.Components.ChatBox do
  @moduledoc """
  A list of chat messages.
  """
  use Phoenix.Component

  def list(assigns) do
    ~H"""
    <ul class="flex flex-col justify-end flex-1 overflow-auto divide-y divide-purple-600 shadow-inner-lg">
      <%= for message <- @messages do %>
        <.message_item message={message} />
      <% end %>
    </ul>
    """
  end

  defp message_item(assigns) do
    ~H"""
    <li class="grid grid-cols-2 gap-1 px-2 py-4 auto-rows-auto">
      <span class="font-bold text-purple-300">
        <%= @message.username %>
        <%= if @message.updated_at do %>
          (edited)
        <% end %>
      </span>

      <span class="text-purple-300 place-self-end"><%= @message.created_at %></span>

      <p><%= @message.body %></p>
    </li>
    """
  end

  def new_message(assigns) do
    # TODO: convert to Phoenix.HTML.form

    ~H"""
    <form phx-submit="submit-message" class="flex">
      <textarea name="body" class="flex-grow px-2 py-1 transition bg-purple-700 rounded-l resize-none focus:bg-purple-600 focus:outline-none"><%= @message.body %></textarea>
      <button type="submit" class="px-2 py-1 transition bg-purple-600 rounded-r shadow hover:bg-purple-200 hover:text-purple-900">SEND</button>
    </form>
    """
  end
end
