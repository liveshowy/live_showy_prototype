defmodule LiveShowy.Chat.Backstage do
  @moduledoc """
  A chatroom for backstage users.
  """
  require Logger
  use GenServer
  alias Phoenix.PubSub
  alias LiveShowy.Chat.Message

  @topic "backstage"

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
        :set,
        write_concurrency: true,
        read_concurrency: true
      ]
    )

    {:ok, nil}
  end

  def list(statuses \\ [:public]) when is_list(statuses) do
    case Enum.all?(statuses, &is_atom/1) do
      true ->
        :ets.tab2list(__MODULE__)
        |> Enum.map(&elem(&1, 1))
        |> Enum.filter(&(&1.status in statuses))
        |> Enum.sort(&(DateTime.compare(&1.created_at, &2.created_at) != :gt))

      _ ->
        {:error, "statuses must be a list of atoms"}
    end
  end

  def add(params) do
    message = Message.new(params)

    :ets.insert(__MODULE__, {message.id, message})
    Logger.info(message_added: message)
    PubSub.broadcast(LiveShowy.PubSub, @topic, {:message_added, message})

    message
  end

  def get(id) when is_binary(id) do
    case :ets.match_object(__MODULE__, {id, :_}) do
      [{^id, message}] -> message
      _ -> nil
    end
  end

  def update_status(id, status) when is_atom(status) do
    update(id, %{status: status})
  end

  def update_body(id, body) when is_binary(body) do
    update(id, %{body: body})
  end

  defp update(id, params) when is_binary(id) and is_map(params) do
    params = Map.drop(params, [:user_id, :created_at, :id, :updated_at])

    message =
      get(id)
      |> Map.merge(params)
      |> Map.put(:updated_at, DateTime.utc_now())

    :ets.insert(__MODULE__, {message.id, message})
    Logger.info(message_updated: message)
    PubSub.broadcast(LiveShowy.PubSub, @topic, {:message_updated, message})

    message
  end

  def delete(id) do
    update(id, %{status: :deleted})
  end
end
