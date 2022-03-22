defmodule LiveShowyWeb.Components.UserCard do
  @moduledoc false
  use Surface.Component
  alias LiveShowyWeb.Components.Card
  alias LiveShowyWeb.Components.Tag

  prop user, :struct, required: true
  prop title, :string
  prop transparent, :boolean
  prop shadow, :string
  prop class, :css_class

  def render(assigns) do
    ~F"""
    <Card transparent={@transparent} shadow={@shadow} class={@class}>
      <:header>
        <h2 :if={@title}>{@title}</h2>
      </:header>

      <:body>
        <dl class="inline-grid grid-cols-1 gap-2 pt-1 lg:grid-cols-2">
          <dt class="font-bold uppercase text-default-500 dark:text-default-400">Username</dt>
          <dd>
            <Tag>{@user.username}</Tag>
          </dd>

          <dt class="font-bold uppercase text-default-500 dark:text-default-400">Color</dt>
          <dd>
            <Tag class="dark:border-default-700" style={"background-color: #{@user.color}"}>&nbsp;</Tag>
          </dd>

          <dt class="font-bold uppercase text-default-500 dark:text-default-400">Instrument</dt>
          <dd>
            {#if @user.assigned_instrument}
              <Tag>
                {Atom.to_string(@user.assigned_instrument.component)
                |> String.replace(~r/.*\.(\w+)$/, "\\g{1}")}
              </Tag>
            {#else}
              <Tag>None</Tag>
            {/if}
          </dd>

          <dt class="font-bold uppercase text-default-500 dark:text-default-400">Roles</dt>
          <dd class="flex flex-wrap gap-2">
            {#for role <- @user.roles || []}
              <Tag class="capitalize">
                {Atom.to_string(role)
                |> String.replace(~r/_/, " ")}
              </Tag>
            {/for}
          </dd>
        </dl>
      </:body>
    </Card>
    """
  end
end
