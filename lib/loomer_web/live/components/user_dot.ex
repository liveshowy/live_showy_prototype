defmodule LoomerWeb.Live.Components.UserDot do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <circle
      fill={@user.color}
      r={30}
      cx={0}
      cy={0}
      style={"transform: translate3d(#{@user.x}px, #{@user.y}px, 0)"}
    />
    """
  end
end
