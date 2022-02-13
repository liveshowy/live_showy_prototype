defmodule LiveShowyWeb.Components.HostMidiDevices do
  @moduledoc false
  use Surface.Component
  alias LiveShowyWeb.Components.Button

  prop available_inputs, :list, default: []
  prop available_outputs, :list, default: []
  prop active_inputs, :list, default: []
  prop active_outputs, :list, default: []
  prop attrs, :map, default: %{}

  def render(assigns) do
    ~F"""
    <div
      id="midi-device-list"
      class="flex flex-wrap gap-2 whitespace-nowrap"
      {...@attrs}
    >
      <span :if={Enum.empty?(@available_inputs) && Enum.empty?(@available_outputs)}>
        No inputs or outputs
      </span>

      <div :if={!Enum.empty?(@available_inputs)}>
        <label class="font-bold">Inputs</label>
        <div class="flex flex-wrap gap-1">
          {#for device <- @available_inputs}
            <Button
              type="button"
              click={
                if device.name in @active_inputs, do: "close-midi-input", else: "open-midi-input"
              }
              attrs={%{
                "phx-value-device-name": device.name,
              }}
              active={device.name in @active_inputs}
              label={device.name}
            />
          {/for}
        </div>
      </div>

      <div :if={!Enum.empty?(@available_outputs)}>
        <label class="font-bold">Outputs</label>
        <div class="flex flex-wrap gap-1">
          {#for device <- @available_outputs}
            <Button
              type="button"
              click={
                if device.name in @active_outputs, do: "close-midi-output", else: "open-midi-output"
              }
              attrs={%{
                "phx-value-device-name": device.name
              }}
              active={device.name in @active_outputs}
              label={device.name}
            />
          {/for}
        </div>
      </div>
    </div>
    """
  end
end
