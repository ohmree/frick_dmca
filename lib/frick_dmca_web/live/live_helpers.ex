defmodule FrickDmcaWeb.LiveHelpers do
  import Phoenix.LiveView.Helpers

  @doc """
  Renders a component inside the `FrickDmcaWeb.ModalComponent` component.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <%= live_modal @socket, FrickDmcaWeb.SongLive.FormComponent,
        id: @song.id || :new,
        action: @live_action,
        song: @song,
        return_to: Routes.song_index_path(@socket, :index) %>
  """
  def live_modal(socket, component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component(socket, FrickDmcaWeb.ModalComponent, modal_opts)
    # live_component(socket, FrickDmcaWeb.SongLive.FormComponent, opts)
  end
end
