defmodule LiveShowyWeb.Components.ChatMessage do
  @moduledoc false
  use Surface.Component

  prop id, :string
  prop username, :string
  prop time, :string
  prop body, :string, required: true
  prop current_user?, :boolean, default: false
  prop class, :css_class
  prop attrs, :map, default: %{}
  prop status, :atom

  def render(assigns) do
    ~F"""
    <li
      class={
        "grid items-baseline grid-cols-1 w-5/6 px-4 py-2 rounded-xl animate-fade-in-slide-down auto-rows-auto dark:text-white",
        @class,
        hidden: @status != :public,
        "bg-default-200 dark:bg-default-700 rounded-br-none self-end":
          @current_user?,
        "bg-primary-200 text-primary-800 dark:bg-primary-600 rounded-bl-none": !@current_user?
      }
      title={"Sent at #{@time}"}
      id={@id}
      {...@attrs}
    >
      <span
        :if={@username}
        class={"font-bold text-sm", "justify-self-end": @current_user?}
        id={"chat-message-user-#{@id}"}
      >
        <span id={"chat-message-username-#{@id}"}>
          {#if @current_user?}
            You
          {#else}
            {@username}
          {/if}
        </span>

        @ <span class="font-mono text-xs font-normal" id={"chat-message-timestamp-#{@id}"}>{@time}</span>
      </span>

      <span
        class={
          "col-span-full text-base",
          "justify-self-end": @current_user?,
          "opacity-70 text-center": !@username && !@time
        }
        id={"chat-message-body-#{@id}"}
      >
        {@body}
      </span>
    </li>
    """
  end
end
