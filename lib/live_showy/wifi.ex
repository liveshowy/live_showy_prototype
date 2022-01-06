defmodule LiveShowy.Wifi do
  @moduledoc """
  Manages Wifi credentials to be displayed to users.
  """
  require Logger
  use GenServer
  alias Phoenix.PubSub

  @topic "wifi"

  def get_topic, do: @topic

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl true
  def init(_) do
    :ets.new(
      __MODULE__,
      [
        :named_table,
        :public,
        write_concurrency: true,
        read_concurrency: true
      ]
    )

    Application.get_env(:live_showy, :wifi)
    |> Enum.map(&add/1)

    {:ok, nil}
  end

  def list do
    :ets.tab2list(__MODULE__)
  end

  def add({key, value} = credential) when is_atom(key) and is_binary(value) do
    :ets.insert_new(__MODULE__, credential)
    PubSub.broadcast(LiveShowy.PubSub, @topic, {:wifi_credential_added, credential})
    Logger.info(wifi_credential_added: credential)
    credential
  end

  def update({key, value} = credential) when is_atom(key) and is_binary(value) do
    :ets.insert(__MODULE__, credential)
    PubSub.broadcast(LiveShowy.PubSub, @topic, {:wifi_credential_updated, credential})
    Logger.info(wifi_credential_updated: credential)
    credential
  end
end
