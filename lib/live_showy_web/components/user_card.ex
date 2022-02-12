defmodule LiveShowyWeb.Components.UserCard do
  @moduledoc false
  use Surface.Component
  alias LiveShowyWeb.Components.Card

  prop user, :struct, required: true
  prop transparent, :boolean
  prop class, :css_class

  def render(assigns) do
    ~F"""
    <Card transparent={@transparent} class={@class}>
      <:body>
        <dl class="grid grid-cols-1 gap-1 lg:grid-cols-2">
          <dt class="font-bold uppercase text-default-500 dark:text-default-400">Username</dt>
          <dd class="font-mono text-sm break-normal">{@user.username}</dd>

          <dt class="font-bold uppercase text-default-500 dark:text-default-400">Instrument</dt>
          <dd class="font-mono text-sm break-normal">
            {if @user.assigned_instrument do
              Atom.to_string(@user.assigned_instrument.component)
              |> String.replace(~r/.*\.(\w+)$/, "\\g{1}")
            end}
          </dd>

          <dt class="font-bold uppercase text-default-500 dark:text-default-400">Roles</dt>
          <dd class="font-mono text-sm break-normal">
            {
              Enum.map(@user.roles || [], &Atom.to_string/1)
              |> Enum.join(", ")
            }
          </dd>
        </dl>
      </:body>
    </Card>
    """
  end
end
