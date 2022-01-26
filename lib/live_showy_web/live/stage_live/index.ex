defmodule LiveShowyWeb.StageLive.Index do
  @moduledoc false
  use LiveShowyWeb, :live_view
  alias LiveShowyWeb.Components.Card

  @topic "stage"

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
