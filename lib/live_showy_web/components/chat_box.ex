defmodule LiveShowyWeb.Components.ChatBox do
  @moduledoc """
  A list of chat messages.
  """
  use Surface.Component
  alias LiveShowyWeb.Components.Button

  prop messages, :list, default: []
  prop show_form, :boolean, default: false
  prop current_message, :string, default: ""

  def render(assigns) do
    ~F"""
    <div class="grid h-full grid-cols-1 overflow-hidden rounded auto-rows-auto max-h-96">
      <ul class="space-y-2 overflow-y-auto divide-y divide-brand-700 shadow-inner-lg">
        {#for message <- @messages}
          <.message_item message={message} />
        {/for}

        {#if Enum.count(@messages) == 0}
          <li class="flex w-full h-full py-6 text-brand-400 place-items-center place-content-center">No messages yet</li>
        {/if}

        </ul>

        {#if @show_form}
          <.new_message message={@current_message} class="place-self-end" id="performers-chat-form" />
        {/if}
    </div>
    """
  end

  defp message_item(assigns) do
    timestamp = DateTime.shift_zone!(assigns.message.created_at, "America/Detroit")
    time = DateTime.to_time(timestamp)

    assigns =
      assigns
      |> assign(timestamp: timestamp)
      |> assign(time: time)

    ~F"""
    <li class="flex flex-wrap items-baseline gap-1 px-2 py-4 auto-rows-auto">
      <span class="text-sm font-bold text-brand-300">{@message.username}</span>

      {#if @message.updated_at}
        <span class="text-sm text-brand-300">(edited)</span>
      {/if}

      <span class="font-mono text-xs font-normal text-brand-400" data-timestamp={@timestamp}>
        {@time}
      </span>


      <p class="w-full">{@message.body}</p>
    </li>
    """
  end

  defp new_message(assigns) do
    # TODO: convert this to a proper Phoenix form
    ~F"""
    <form phx-submit="submit-message" class={"flex divide-x-2 divide-brand-800 rounded-b w-full #{@class}"}>
      <input title="may not be empty" name="body" value={@message.body} type="text" class="flex-grow px-2 py-2 transition resize-none bg-brand-700 focus:bg-brand-600 focus:outline-none" />

      <Button label="SEND" type="submit" rounded="rounded-br" shadow={nil} />
    </form>
    """
  end
end
