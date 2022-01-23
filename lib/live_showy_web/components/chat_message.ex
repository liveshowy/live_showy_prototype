defmodule LiveShowyWeb.Components.ChatMessage do
  @moduledoc false
  use Surface.Component

  prop username, :string
  prop time, :string
  prop body, :string, required: true
  prop current_user?, :boolean, default: false
  prop class, :css_class

  def render(assigns) do
    ~F"""
    <li
      class={
        "grid items-baseline grid-cols-1 w-5/6 px-4 py-2 rounded-xl shadow-md animate-fade-in-slide-down auto-rows-auto",
        @class,
        "bg-gradient-to-bl from-default-100 to-default-400 text-default-900 rounded-br-none self-end": @current_user?,
        "bg-gradient-to-br from-primary-700 to-primary-900 rounded-bl-none": !@current_user?
      }
      title={"Sent at #{@time}"}
    >
      <span :if={@username} class={"font-bold text-sm", "justify-self-end text-primary-800": @current_user?}>
        {#if @current_user?}
          <span>You</span>
          @ <span class="font-mono text-xs font-normal">{@time}</span>
        {#else}
          <span>{@username}</span>
          @ <span class="font-mono text-xs font-normal">{@time}</span>
        {/if}
      </span>


      <span class={"col-span-full text-base", "justify-self-end": @current_user?, "opacity-70 text-center": !@username && !@time}>
        {@body}
      </span>
    </li>
    """
  end
end
