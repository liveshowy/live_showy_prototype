defmodule LiveShowyWeb.Live.Components.WifiInfo do
  @moduledoc false
  use Phoenix.Component

  def datalist(assigns) do
    ~H"""
    <dl class="grid grid-cols-2 gap-1">
      <dt>SSID</dt>
      <dd>LiveShowy</dd>

      <dt>Password</dt>
      <dd>live-showy-rocks!</dd>

      <dt>URL</dt>
      <dd>live.showy</dd>
    </dl>
    """
  end

  def bar(assigns) do
    ~H"""
    <ul class="flex gap-2">
      <li>
        SSID: <strong>LiveShowy</strong>
      </li>

      <li>
        Password: <strong>live-showy-rocks!</strong>
      </li>

      <li>
        URL: <strong>live.showy</strong>
      </li>
    </ul>
    """
  end
end
