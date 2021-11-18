defmodule LoomerWeb.Live.Components.XYPad do
  @moduledoc false
  use Phoenix.LiveComponent
  alias LoomerWeb.Live.Components.UserDot

  def render(assigns) do
    ~H"""
      <svg
      class="w-[350px] h-[350px] bg-purple-800 rounded-lg"
      id="touchpad"
      phx-hook="TrackTouchEvents"
      viewBox="0 0 350 350"
      version="1.1"
      xmlns="http://www.w3.org/2000/svg"
    >
      <%= for user <- @users do %>
        <.live_component module={UserDot} id={user.id <> "-dot"} user={user} />
      <% end %>
    </svg>
    """
  end
end
