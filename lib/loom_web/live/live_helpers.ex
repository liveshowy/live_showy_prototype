defmodule LoomWeb.LiveHelpers do
  import Phoenix.LiveView.Helpers

  @doc """
  Renders a component inside the `LoomWeb.ModalComponent` component.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <%= live_modal LoomWeb.StageLive.FormComponent,
        id: @stage.id || :new,
        action: @live_action,
        stage: @stage,
        return_to: Routes.stage_index_path(@socket, :index) %>
  """
  def live_modal(component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component(LoomWeb.ModalComponent, modal_opts)
  end
end
