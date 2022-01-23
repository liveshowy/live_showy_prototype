defmodule LiveShowyWeb.Components.Chat do
  @moduledoc false
  use LiveShowyWeb, :live_component
  require Logger
  alias LiveShowy.Chat.Backstage
  alias LiveShowy.Chat.Message
  alias LiveShowyWeb.Components.ChatMessage, as: ChatMessageComponent
  alias LiveShowyWeb.Components.ChatForm

  prop chat_module, :module, required: true, values: [Backstage]
  prop current_user, :struct, required: true
  prop messages, :list, default: []
  data new_message, :struct, default: Message.new()
  prop show_form, :boolean, default: true

  def mount(socket) do
    if connected?(socket) do
      Backstage.subscribe()
    end

    {:ok, socket}
  end

  def update(%{message: message} = assigns, socket) do
    Logger.info(chat_updated: assigns)
    socket = assign(socket, assigns)

    socket =
      case message.status do
        :deleted ->
          update(socket, :messages, &Enum.reject(&1, fn msg -> msg.id == message.id end))

        _ ->
          update(socket, :messages, &prepend_and_sort(&1, message))
      end

    {:ok, socket}
  end

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  defp prepend_and_sort(messages, %Message{} = message) when is_list(messages) do
    [message | messages]
    |> Enum.sort(&(DateTime.compare(&1.created_at, &2.created_at) != :gt))
  end

  def render(assigns) do
    ~F"""
    <div class="grid gap-1 h-full max-h-full grid-cols-1 grid-rows-[1fr_auto] overflow-hidden scroll-pb-8">
      <ul class="flex flex-col gap-1 overflow-y-auto shadow-inner-lg scroll-pb-0">
        {#for message <- @messages}
          <ChatMessageComponent
            username={message.username}
            time={DateTime.shift_zone!(message.created_at, "America/Detroit") |> Calendar.strftime("%H:%M:%S")}
            body={message.body}
            current_user?={message.user_id == @current_user.id}
          />
        {/for}

        <ChatMessageComponent :if={Enum.empty?(@messages)} body="No messages yet" />
      </ul>

      <ChatForm :if={@show_form} submit="submit-message" message={@new_message} />
    </div>
    """
  end

  def list_message(%{message: message} = assigns) do
    timestamp = DateTime.shift_zone!(message.created_at, "America/Detroit")

    assigns =
      assigns
      |> assign(time: Calendar.strftime(timestamp, "%H:%M:%S"))

    ~F"""
    <li class="grid items-baseline grid-cols-2 gap-1 px-4 py-2 rounded shadow auto-rows-auto bg-default-900">
      <span class="font-bold">{ @message.username }</span>
      <span class="font-mono text-xs justify-self-end opacity-70">{ @time }</span>
      <span class="col-span-full">{ @message.body }</span>
    </li>
    """
  end

  def add_message(component_id, %Message{} = message, socket) when is_binary(component_id) do
    send_update(__MODULE__, id: component_id, message: message)
    {:noreply, socket}
  end

  def handle_event(
        "submit-message",
        %{"body" => body},
        %{assigns: %{current_user: current_user, chat_module: chat_module}} = socket
      ) do
    chat_module.add(%{
      body: body,
      user_id: current_user.id,
      username: current_user.username
    })

    send_update(__MODULE__, id: "backstage-chat", chat_module: chat_module)
    {:noreply, assign(socket, new_message: Message.new())}
    # update_chat(socket)
  end

  def handle_event(event, value, socket) do
    Logger.warning(unknown_event: {__MODULE__, event, value})
    {:noreply, socket}
  end

  def handle_info(message, socket) do
    Logger.warning(unknown_info: {__MODULE__, message})
    {:noreply, socket}
  end

  defp update_chat(%{assigns: %{chat_module: chat_module}} = socket) do
    {:noreply, assign(socket, messages: chat_module.list())}
  end
end
