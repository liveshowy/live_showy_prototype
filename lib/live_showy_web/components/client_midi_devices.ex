defmodule LiveShowyWeb.Components.ClientMidiDevices do
  @moduledoc false
  use Surface.Component

  prop devices, :list, required: true
  prop playing_devices, :mapset, default: MapSet.new()

  def render(assigns) do
    ~F"""
    <ul>
      {#for device <- @devices}
        <li class="flex items-center gap-2">
          <span class={
            "rounded-full w-4 h-4 shadow-inner",
            "bg-success-500": device["id"] in @playing_devices,
            "bg-default-600": device["id"] not in @playing_devices
          } />

          <span>{device["name"]}</span>
        </li>
      {/for}
    </ul>
    """
  end
end
