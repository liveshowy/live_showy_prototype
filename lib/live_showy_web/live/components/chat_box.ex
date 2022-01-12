defmodule LiveShowyWeb.Components.ChatBox do
  @moduledoc """
  A list of chat messages.
  """
  use Phoenix.Component

  def list(assigns) do
    ~H"""
    <div class="flex flex-1 h-auto overflow-hidden rounded">
      <ul class="h-full max-h-full overflow-y-auto divide-y divide-purple-700">
        <%= for message <- @messages do %>
          <.message_item message={message} />
        <% end %>

        <%= if Enum.count(@messages) == 0 do %>
          <li class="flex w-full h-full py-6 text-purple-400 place-items-center place-content-center">No messages yet</li>
        <% end %>
      </ul>
    </div>
    """
  end

  defp message_item(assigns) do
    timestamp = DateTime.shift_zone!(assigns.message.created_at, "America/Detroit")
    time = DateTime.to_time(timestamp)

    assigns =
      assigns
      |> assign(timestamp: timestamp)
      |> assign(time: time)

    ~H"""
    <li class="flex flex-wrap items-baseline gap-1 px-2 py-4 auto-rows-auto">
      <span class="text-sm font-bold text-purple-300"><%= @message.username %></span>

      <%= if @message.updated_at do %>
        <span class="text-sm text-purple-300">(edited)</span>
      <% end %>

      <span class="font-mono text-xs font-normal text-purple-400" data-timestamp={@timestamp}>
        <%= @time %>
      </span>


      <p class="w-full"><%= @message.body %></p>
    </li>
    """
  end

  def new_message(assigns) do
    ~H"""
    <form phx-submit="submit-message" class={"flex border-2 border-purple-900 divide-x-2 divide-purple-900 rounded focus-within:border-black focus-within:divide-black w-full #{@class}"}>
      <input name="body" value={@message.body} type="text" class="flex-grow px-2 py-1 transition bg-purple-700 rounded-l resize-none focus:bg-purple-600 focus:outline-none" />
      <button type="submit" class="px-2 py-1 font-bold transition bg-purple-700 rounded-r shadow hover:bg-purple-600 hover:text-white">SEND</button>
    </form>
    """
  end
end
