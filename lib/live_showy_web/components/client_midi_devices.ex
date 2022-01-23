defmodule LiveShowyWeb.Components.ClientMidiDevices do
  use Phoenix.Component

  def list(assigns) do
    ~H"""
    <ul>
      <%= for device <- @devices do %>
        <li class="flex items-center gap-2">
          <span class={"rounded-full w-4 h-4 shadow-inner #{if device["id"] in @playing_devices, do: "bg-green-500", else: "bg-default-600"}"}></span>
          <span><%= device["name"] %></span>
        </li>
      <% end %>
    </ul>
    """
  end
end
