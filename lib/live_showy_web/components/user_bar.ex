defmodule LiveShowyWeb.Components.UserBar do
  @moduledoc false
  use Surface.Component
  # alias LiveShowyWeb.Components.LatencyMonitor

  prop user, :struct, required: true

  def render(assigns) do
    ~F"""
    <div class="overflow-x-auto bg-black bg-opacity-5">
      <dl class="flex items-baseline self-end justify-end w-full gap-2 px-4 py-1 mx-auto overflow-x-auto whitespace-nowrap max-w-screen-2xl">
        <dt class="font-bold uppercase text-default-500 dark:text-default-400">Username</dt>
        <dd class="font-mono text-sm break-normal">{@user.username}</dd>

        <dt class="font-bold uppercase text-default-500 dark:text-default-400">Instrument</dt>
        <dd class="font-mono text-sm">
          {if @user.assigned_instrument do
            Atom.to_string(@user.assigned_instrument.component)
            |> String.replace(~r/.*\.(\w+)$/, "\\g{1}")
          else
            "None"
          end}
        </dd>

        <dt class="font-bold uppercase text-default-500 dark:text-default-400">Roles</dt>
        <dd class="font-mono text-sm">
          {#if Enum.count(@user.roles) > 2}
            {Enum.count(@user.roles)}
          {#else}
            {Enum.map(@user.roles || [], &Atom.to_string/1) |> Enum.join(", ")}
          {/if}
        </dd>

        <!--
        <dt class="font-bold uppercase text-default-500 dark:text-default-400">Latency</dt>
        <dd class="font-mono text-sm">
          <LatencyMonitor id="latency-monitor" />
        </dd>
        -->
      </dl>
    </div>
    """
  end
end
