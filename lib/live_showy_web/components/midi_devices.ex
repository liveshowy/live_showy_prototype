defmodule LiveShowyWeb.Components.MidiDevices do
  @moduledoc false
  use Surface.Component
  alias LiveShowyWeb.Components.Button

  prop available_inputs, :list, default: []
  prop available_outputs, :list, default: []
  prop active_input, :any
  prop active_output, :any
  prop attrs, :map, default: %{}

  def render(assigns) do
    ~F"""
    <div
      id="midi-device-list"
      class="flex flex-wrap gap-2 whitespace-nowrap"
      {...@attrs}
    >
      <div>
        <label class="font-bold">Inputs</label>
        <div class="flex flex-wrap gap-1">
          {#for device <- @available_inputs}
            <Button
              type="button"
              click="set-midi-input"
              attrs={%{
                "phx-value-device-name": device.name,
              }}
              active={@active_input == device.name}
              label={device.name}
            />
          {/for}
        </div>
      </div>

      <div>
        <label class="font-bold">Outputs</label>
        <div class="flex flex-wrap gap-1">
          {#for device <- @available_outputs}
            <Button
              type="button"
              click="set-midi-output"
              attrs={%{
                "phx-value-device-name": device.name
              }}
              active={@active_output == device.name}
              label={device.name}
            />
          {/for}
        </div>
      </div>
    </div>
    """
  end
end
