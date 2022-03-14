defmodule LiveShowyWeb.Components.NavBar do
  @moduledoc false
  use Surface.Component
  use Phoenix.HTML
  alias LiveShowyWeb.Router.Helpers, as: Routes
  alias Surface.Components.Link

  prop conn, :struct

  def render(assigns) do
    ~F"""
    <header class="sticky top-0 z-50 self-start w-full shadow-md select-none col-span-full text-default-800 dark:text-default-200">
      <section class="bg-gradient-to-br from-white to-default-300 dark:from-default-700 dark:to-default-900">
        <nav class="mx-auto max-w-screen-2xl">
          <ul class="flex flex-wrap items-center gap-4 px-4 py-2">
            <li>
              <Link to={Routes.landing_index_path(@conn, :index)}>
                <LiveShowyWeb.Components.Logo class="h-8" />
              </Link>
            </li>

            <span class="flex-grow" />

            <li>
              <Link to={Routes.landing_index_path(@conn, :index)}>Lobby</Link>
            </li>
            <li>
              <Link to={Routes.backstage_index_path(@conn, :index)}>Backstage</Link>
            </li>
            <li>
              <Link to={Routes.stage_index_path(@conn, :index)}>Main Stage</Link>
            </li>
            <li>
              <Link to={Routes.stage_manager_index_path(@conn, :index)}>
                Stage Manager
              </Link>
            </li>
            {#if function_exported?(Routes, :live_dashboard_path, 2)}
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
