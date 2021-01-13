defmodule FrickDmcaWeb.SongLive.Show do
  use FrickDmcaWeb, :live_view

  alias FrickDmca.Songs

  @impl true
  def mount(_params, session, socket) do
    socket = assign(socket, :current_user, FrickDmcaWeb.AuthHelpers.get_current_user(socket, session))
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    song = Songs.get_song!(id)
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:song, song)
     |> assign(Songs.fetch_urls_and_metadata(song))}
  end

  defp page_title(:show), do: "Playing Song"
end
