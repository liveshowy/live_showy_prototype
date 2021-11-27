defmodule LoomerWeb.KeysLive.Index do
  @moduledoc """
  A stage for up to six members to collaborate.
  """
  use LoomerWeb, :live_view
  alias LoomerWeb.Presence
  alias LoomerWeb.Live.Components.LatencyMonitor
  alias LoomerWeb.Live.Components.Keyboard

  @topic "band_live"

  @impl true
  def mount(
        _params,
        _session,
        %{assigns: %{current_user_id: current_user_id}} = socket
      ) do
    if connected?(socket), do: subscribe()
    current_user = Loomer.Users.get_user(current_user_id)

    Presence.track(
      self(),
      @topic,
      current_user.id,
      current_user
    )

    users =
      Presence.list(@topic) |> Enum.map(fn {_user_id, data} -> data[:metas] |> List.first() end)

    {:ok, assign(socket, users: users, current_username: current_user.username)}
  end

  def handle_event("note-on", [note, velocity], socket) do
    output = Loomer.MidiDevices.get_device(:output)
    PortMidi.write(output, {144, note, velocity})
    {:noreply, socket}
  end

  def handle_event("note-off", note, socket) do
    output = Loomer.MidiDevices.get_device(:output)
    PortMidi.write(output, {144, note, 0})
    {:noreply, socket}
  end

  @impl true
  def handle_event(event, params, socket) do
    IO.inspect(params, label: event)
    {:noreply, socket}
  end

  defp subscribe, do: Phoenix.PubSub.subscribe(Loomer.PubSub, @topic)
end
