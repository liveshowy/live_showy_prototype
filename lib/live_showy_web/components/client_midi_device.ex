defmodule LiveShowyWeb.Components.ClientMidiDevice do
  @moduledoc false
  use Surface.Component

  prop id, :string, required: true
  prop connection, :string, required: true
  prop manufacturer, :string, required: true
  prop name, :string, required: true
  prop state, :string, required: true
  prop type, :string, required: true
  prop active_notes, :mapset, required: true

  def render(assigns) do
    ~F"""
    <div id={@id} class="flex flex-col gap-1">
      <div class="flex items-center gap-1">
        <div class={
          "w-4 h-4 aspect-square rounded-full shadow-sm",
          "bg-default-500": Enum.empty?(@active_notes),
          "bg-success-500 shadow-success-500": !Enum.empty?(@active_notes)
        } />
        {"#{@manufacturer} #{@name}"}
      </div>
    </div>
    """
  end
end
