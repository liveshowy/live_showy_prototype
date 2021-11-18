defmodule LoomerWeb.Presence do
  @moduledoc false
  use Phoenix.Presence,
    otp_app: :loomer,
    pubsub_server: Loomer.PubSub
end
