defmodule LiveShowyWeb.Components.ChatMessage do
  @moduledoc false
  use Surface.Component

  prop username, :string
  prop time, :string
  prop body, :string, required: true
  prop current_user?, :boolean, default: false

  def render(assigns) do
    ~F"""
    <li class={
      "grid items-baseline grid-cols-2 gap-1 px-4 py-2 shadow-md animate-fade-in-slide-down auto-rows-auto",
      "bg-default-200 text-default-900": @current_user?,
      "bg-default-700": !@current_user?,
    }>
      <span :if={@username} class="font-bold">
        {@username}
      </span>

      <span :if={@time} class="font-mono text-xs justify-self-end opacity-70">
        {@time}
      </span>

      <span class={"col-span-full", "opacity-70 text-center": !@username && !@time}>
        {@body}
      </span>
    </li>
    """
  end
end
