defmodule FrickDmcaWeb.SongLive.FormComponent do
  use FrickDmcaWeb, :live_component

  alias FrickDmca.Songs

  @impl true
  def update(%{song: song} = assigns, socket) do
    changeset = Songs.change_song(song)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"song" => song_params}, socket) do
    changeset =
      socket.assigns.song
      |> Songs.change_song(song_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"song" => song_params}, socket) do
    save_song(socket, socket.assigns.action, song_params)
  end

  defp save_song(socket, :new, song_params) do
    song = case Songs.create_song(song_params) do
      {:ok, song} -> song
      {:error, _changeset} ->
        Songs.get_song_by!(song_params)
    end

    {:noreply,
     socket
     |> assign(url: song.url)
     |> push_redirect(to: socket.assigns.return_to)}
  end
end
