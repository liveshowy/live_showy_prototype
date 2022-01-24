defmodule LiveShowyWeb.Components.MidiDevices do
  @moduledoc """
  Lists Midi devices.
  """
  use Surface.Component

  def button_groups(assigns) do
    {_type, output_name, _pid} = assigns.output || {nil, nil, nil}
    {_type, input_name, _pid} = assigns.input || {nil, nil, nil}

    assigns =
      assigns
      |> assign(:output_name, output_name)
      |> assign(:input_name, input_name)

    ~F"""
    <div id="midi-device-list" class="flex flex-wrap gap-2 whitespace-nowrap" phx-hook="HandleWebMidiDevices">
      <div>
        <label class="font-bold">Inputs</label>
        <div class="flex flex-wrap gap-1">
          {#for device <- @devices.input}
            <button
             type="button"
             phx-click="set-midi-input"
             phx-value-device-name={device.name}
             class={"bg-default-600 flex-1 px-2 py-1 rounded-sm shadow #{get_class(@input_name, device.name)}"}>
              {device.name}
            </button>
          {/for}
        </div>
      </div>

      <div>
        <label class="font-bold">Outputs</label>
        <div class="flex flex-wrap gap-1">
          {#for device <- @devices.output}
          <button
          type="button"
          phx-click="set-midi-output"
          phx-value-device-name={device.name}
          class={"bg-default-600 flex-1 px-2 py-1 rounded-sm shadow #{get_class(@output_name, device.name)}"}>
           {device.name}
         </button>
          {/for}
          </div>
        </div>
    </div>
    """
  end

  defp get_class(name1, name2) do
    if name1 == name2, do: "font-bold", else: "opacity-70"
  end
end
