defmodule LiveShowyWeb.Presence do
  @moduledoc false
  use Phoenix.Presence,
    otp_app: :live_showy,
    pubsub_server: LiveShowy.PubSub
end
