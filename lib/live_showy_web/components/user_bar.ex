defmodule LiveShowyWeb.Components.UserBar do
  @moduledoc false
  use Surface.Component
  alias LiveShowyWeb.Components.LatencyMonitor

  prop user, :struct, required: true

  def render(assigns) do
    ~F"""
    <dl class="flex justify-end gap-2 px-2 py-1 overflow-x-auto bg-black bg-opacity-5 whitespace-nowrap">
      <dt class="font-bold uppercase text-default-500 dark:text-default-400">Username</dt>
      <dd class="font-mono text-sm break-normal">{@user.username}</dd>

      <dt class="font-bold uppercase text-default-500 dark:text-default-400">Instrument</dt>
      <dd class="font-mono text-sm">
        {if @user.assigned_instrument do
          Atom.to_string(@user.assigned_instrument.component)
          |> String.replace(~r/.*\.(\w+)$/, "\\g{1}")
        end}
      </dd>

      <dt class="font-bold uppercase text-default-500 dark:text-default-400">Roles</dt>
      <dd class="font-mono text-sm">{Enum.map(@user.roles || [], &Atom.to_string/1) |> Enum.join(", ")}</dd>

      <!--
      <dt class="font-bold uppercase text-default-500 dark:text-default-400">Latency</dt>
      <dd class="font-mono text-sm">
        <LatencyMonitor id="latency-monitor" />
      </dd>
      -->
    </dl>
    """
  end
end
