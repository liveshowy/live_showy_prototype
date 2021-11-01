defmodule LoomerWeb.Presence do
  use Phoenix.Presence,
    otp_app: :loomer,
    pubsub_server: Loomer.PubSub
end
