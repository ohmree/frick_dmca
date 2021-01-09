defmodule FrickDmcaWeb.SongLive.FormComponent do
  use FrickDmcaWeb, :live_component

  alias FrickDmca.Songs

  @impl true
  def update(%{song: song, user: user} = assigns, socket) do
    changeset = Songs.change_song(song)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:current_user, user)
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
    case Songs.create_or_get_song(song_params) do
      {:ok, song} ->
        FrickDmca.Users.set_song(socket.assigns.current_user, song)
        {:noreply,
         socket
         |> assign(url: song.url)
         |> push_redirect(to: Routes.song_show_path(socket, :show, song.id))}
      {:error, changeset} ->
        {:noreply,
         socket
         |> assign(changeset: changeset)}
    end
  end
end
