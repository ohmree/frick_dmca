defmodule FrickDmcaWeb.SongLive.Index do
  use FrickDmcaWeb, :live_view

  alias FrickDmca.Songs
  alias FrickDmca.Songs.Song
  alias FrickDmca.Users

  @impl true
  def mount(_params, session, socket) do
    socket = assign(socket, :current_user, FrickDmcaWeb.AuthHelpers.get_current_user(socket, session))
    {:ok, assign(socket, :songs, list_songs())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    current_user = socket.assigns.current_user

    socket
    |> assign(:current_user, Users.start_streaming(current_user))
    |> assign(:page_title, "Play song")
    |> assign(:song, %Song{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "FrickDMCA")
    |> assign(:song, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    song = Songs.get_song!(id)
    {:ok, _} = Songs.delete_song(song)

    {:noreply, assign(socket, :songs, list_songs())}
  end

  defp list_songs do
    Songs.list_songs()
  end
end
