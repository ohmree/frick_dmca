defmodule FrickDmcaWeb.SongLive.Show do
  use FrickDmcaWeb, :live_view

  alias FrickDmca.Songs

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    song = Songs.get_song!(id)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(Songs.fetch_urls_and_metadata(song))}
  end

  defp page_title(:show), do: "Playing Song"
end
