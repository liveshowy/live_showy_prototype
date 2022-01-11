defmodule LiveShowyWeb.Components.XYPad do
  @moduledoc false
  use Phoenix.Component
  alias LiveShowyWeb.Components.UserDot

  def square(assigns) do
    ~H"""
      <svg
      class="w-[350px] h-[350px] bg-purple-800 rounded-lg border-2 border-purple-700 shadow-lg overscroll-none"
      id="touchpad"
      phx-hook="TrackTouchEvents"
      viewBox="0 0 350 350"
      version="1.1"
      xmlns="http://www.w3.org/2000/svg"
    >
      <line x1="0" x2="350" y1="175" y2="175" stroke="rgb(109, 40, 217)" stroke-width="2" />
      <line x1="175" x2="175" y1="0" y2="350" stroke="rgb(109, 40, 217)" stroke-width="2" />

      <%= for user <- @users do %>
        <UserDot.render id={"dot-" <> user.id} user={user} current_user_id={@current_user_id} />
      <% end %>

      <use xlink:href={"#dot-" <> @current_user_id} />
    </svg>
    """
  end
end
