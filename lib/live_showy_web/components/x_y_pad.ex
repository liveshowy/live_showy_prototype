defmodule LiveShowyWeb.Components.XYPad do
  @moduledoc false
  use Surface.Component

  prop users, :list, required: true
  prop current_user_id, :string, required: true

  def render(assigns) do
    ~F"""
    <svg
      class="w-[350px] h-[350px] bg-default-800 rounded-lg border-2 border-default-700 shadow-lg overscroll-none"
      id="touchpad"
      phx-hook="TrackTouchEvents"
      viewBox="0 0 350 350"
      version="1.1"
      xmlns="http://www.w3.org/2000/svg"
    >
      <line x1="0" x2="350" y1="175" y2="175" stroke="rgb(109, 40, 217)" stroke-width="2" />
      <line x1="175" x2="175" y1="0" y2="350" stroke="rgb(109, 40, 217)" stroke-width="2" />

      {#for user <- @users}
        <.dot id={"dot-" <> user.id} user={user} current_user_id={@current_user_id} />
      {/for}

      <use xlink:href={"#dot-" <> @current_user_id} />
    </svg>
    """
  end

  defp dot(assigns) do
    [x, y] = assigns.user.coords

    ~F"""
    <circle
      id={"dot-" <> @user.id}
      fill={@user.color}
      fill-opacity={if @user.id == @current_user_id, do: "100%", else: "50%"}
      r={30}
      cx={0}
      cy={0}
      style={"transform: translate3d(#{x}px, #{y}px, 0)"}
    />
    """
  end
end
