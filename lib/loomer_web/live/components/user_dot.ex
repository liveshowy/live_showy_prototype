defmodule LoomerWeb.Live.Components.UserDot do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <circle
      id={"dot-" <> @user.id}
      fill={@user.color}
      fill-opacity={if @user.id == @current_user_id, do: "100%", else: "50%"}
      r={30}
      cx={0}
      cy={0}
      style={"transform: translate3d(#{@user.x}px, #{@user.y}px, 0)"}
    />
    """
  end
end
