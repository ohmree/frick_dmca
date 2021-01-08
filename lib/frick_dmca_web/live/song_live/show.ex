defmodule FrickDmcaWeb.SongLive.Show do
  use FrickDmcaWeb, :live_view

  alias FrickDmca.Songs

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:song, Songs.get_song!(id))}
  end

  defp page_title(:show), do: "Play Song"
end
