defmodule LiveShowyWeb.BackstageLive.Index do
  @moduledoc """
  A chat room for coordinating performers and instruments.
  """
  require Logger
  use LiveShowyWeb, :live_view
  alias LiveShowy.Chat.Message
  alias LiveShowy.Chat.Backstage, as: BackstageChat
  alias LiveShowyWeb.Components.Users
  alias LiveShowyWeb.Components.ChatBox

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: subscribe()
    performers = []

    {:ok,
     assign(socket,
       performers: performers,
       messages: BackstageChat.list(),
       form_message: Message.new(%{}),
       assigned_instrument: nil
     )}
  end

  defp subscribe do
    Phoenix.PubSub.subscribe(LiveShowy.PubSub, BackstageChat.get_topic())
  end

  @impl true
  def handle_info({:message_updated, _message}, socket) do
    update_chat(socket)
  end

  def handle_info({:message_added, _message}, socket) do
    update_chat(socket)
  end

  @impl true
  def handle_event(
        "instrument-requested",
        %{"user-id" => user_id, "instrument" => instrument},
        socket
      ) do
    # TODO: process request
    Logger.info(instrument_requested: {user_id, instrument})
    {:noreply, socket}
  end

  def handle_event(
        "submit-message",
        %{"body" => body},
        %{assigns: %{current_user: current_user}} = socket
      ) do
    %{
      body: body,
      user_id: current_user.id,
      username: current_user.username
    }
    |> BackstageChat.add()

    update_chat(socket)
  end

  def handle_event(event, value, socket) do
    Logger.warning(unknown_event: {event, value})
    {:noreply, socket}
  end

  defp update_chat(socket) do
    {:noreply, assign(socket, messages: BackstageChat.list())}
  end
end
