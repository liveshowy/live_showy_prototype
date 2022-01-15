defmodule LiveShowyWeb.Components.ClientMidiDevices do
  use Phoenix.Component

  def list(assigns) do
    ~H"""
    <ul>
      <%= for device <- @devices do %>
        <li class={if device["id"] in @playing_devices, do: "text-green-300"}><%= device["name"] %></li>
      <% end %>
    </ul>
    """
  end
end
