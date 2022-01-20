defmodule LiveShowyWeb.Components.NavBar do
  @moduledoc false
  use Surface.Component
  use Phoenix.HTML
  alias LiveShowyWeb.Router.Helpers, as: Routes
  alias Surface.Components.Link

  prop conn, :struct

  def render(assigns) do
    ~F"""
    <header class="sticky top-0 z-50 flex-none shadow-md select-none text-brand-200">
      <section class="bg-gradient-to-br from-brand-700 to-brand-900">
        <nav class="mx-auto max-w-7xl">
          <ul class="flex flex-wrap gap-4 p-4">
            <li>
              <Link to={Routes.landing_index_path(@conn, :index)}>LiveShowy</Link>
            </li>

            <span class="flex-grow"></span>

            <li>
              <Link to={Routes.backstage_index_path(@conn, :index)}>Backstage</Link>
            </li>
            <li>
              <Link to={Routes.stage_manager_index_path(@conn, :index)}>
                Stage Manager
              </Link>
            </li>
            {#if function_exported?(Routes, :live_dashboard_path, 2) }
              <li>
                <Link to={Routes.live_dashboard_path(@conn, :home)}>
                  Live Dashboard
                </Link>
              </li>
            {/if}
          </ul>
        </nav>
      </section>
    </header>
    """
  end
end
