defmodule LiveShowyWeb.ChatLive.Index do
  @moduledoc false
  use LiveShowyWeb, :live_view
  require Logger
  alias LiveShowy.Users
  alias LiveShowy.Chat.Message
  alias LiveShowyWeb.Components.ChatMessage, as: ChatMessageComponent
  alias LiveShowyWeb.Components.ChatForm

  def mount(
        _params,
        %{"chat_module" => chat_module, "current_user_id" => current_user_id} = _session,
        socket
      ) do
    if connected?(socket) do
      apply(chat_module, :subscribe, [])
      Logger.info(subscribed_to: chat_module)

      Users.subscribe()
      Logger.info(subscribed_to: Users)
    end

    # What's this?!
    # `assign_new/3` will inherit the value for a specified key if one exists, otherwise it will assign the result of an anonymous function.
    socket =
      socket
      |> assign_new(:current_user, fn -> Users.get(current_user_id) end)
      |> assign_new(:chat_module, fn -> chat_module end)
      |> assign_new(:messages, fn -> apply(chat_module, :list, []) end)
      |> assign_new(:new_message, fn -> Message.new() end)

    {:ok, socket, temporary_assigns: [messages: []]}
  end

  def handle_event(
        "submit-message",
        %{"body" => body},
        %{assigns: %{current_user: current_user, chat_module: chat_module}} = socket
      ) do
    apply(chat_module, :add, [
      %{
        body: body,
        user_id: current_user.id,
        username: current_user.username
      }
    ])

    {:noreply, assign(socket, new_message: Message.new())}
  end

  def handle_event(event, value, socket) do
    Logger.warning(unknown_event: {__MODULE__, event, value})
    {:noreply, socket}
  end

  def handle_info({:message_added, message}, socket) do
    {:noreply, update(socket, :messages, &[message | &1])}
  end

  def handle_info({:message_updated, message}, socket) do
    {:noreply, update(socket, :messages, fn messages -> [message | messages] end)}
  end

  def handle_info({:user_updated, _user}, %{assigns: %{chat_module: chat_module}} = socket) do
    {:noreply, assign(socket, messages: apply(chat_module, :list, []))}
  end

  def handle_info(message, socket) do
    Logger.warning(unknown_info: {__MODULE__, message})
    {:noreply, socket}
  end
end
