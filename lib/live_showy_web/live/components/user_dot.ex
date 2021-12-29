defmodule LiveShowyWeb.Live.Components.UserDot do
  use Phoenix.Component

  def render(assigns) do
    [x, y] = assigns.user.coords

    ~H"""
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
