defmodule FrickDmca.Songs do
  @moduledoc """
  The Songs context.
  """

  import Ecto.Query, warn: false
  alias FrickDmca.Repo

  alias FrickDmca.Songs.Song

  @doc """
  Returns the list of songs.

  ## Examples

      iex> list_songs()
      [%Song{}, ...]

  """
  def list_songs do
    Repo.all(Song)
  end

  @doc """
  Gets a single song.

  Raises `Ecto.NoResultsError` if the Song does not exist.

  ## Examples

      iex> get_song!(123)
      %Song{}

      iex> get_song!(456)
      ** (Ecto.NoResultsError)

  """
  def get_song!(id), do: Repo.get!(Song, id)

  @doc """
  Creates a song.

  ## Examples

      iex> create_song(%{field: value})
      {:ok, %Song{}}

      iex> create_song(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_song(attrs \\ %{}) do
    %Song{}
    |> Song.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a song.

  ## Examples

      iex> update_song(song, %{field: new_value})
      {:ok, %Song{}}

      iex> update_song(song, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_song(%Song{} = song, attrs) do
    song
    |> Song.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a song.

  ## Examples

      iex> delete_song(song)
      {:ok, %Song{}}

      iex> delete_song(song)
      {:error, %Ecto.Changeset{}}

  """
  def delete_song(%Song{} = song) do
    Repo.delete(song)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking song changes.

  ## Examples

      iex> change_song(song)
      %Ecto.Changeset{data: %Song{}}

  """
  def change_song(%Song{} = song, attrs \\ %{}) do
    Song.changeset(song, attrs)
  end

  @providers [
    youtube:
      ~r"^(?:https?://)?(?:www\.|m\.)?(?:youtube\.com/watch\?v=|youtu\.be/|youtube\.com/embed/)(?<video_id>[A-Za-z0-9_-]{11})"
  ]


  @spec validate_providers(Ecto.Schema.t() | Ecto.Changeset.t(), map()) :: Ecto.Changeset.t()
  def validate_providers(song_or_changeset, attrs) do
    song_or_changeset
    |> Ecto.Changeset.cast(attrs, [:url])
    |> Ecto.Changeset.validate_format(:url, @providers[:youtube])
  end

  def fetch_urls_and_metadata(%Song{url: url} = song) do
    {provider, _} =
      Enum.find(@providers, fn {_, regex} ->
        Regex.match?(regex, url)
      end)

    fetch_urls_and_metadata(song, provider)
  end

  def fetch_urls_and_metadata(%Song{url: url}, :youtube) do
    invidious_instance = "https://invidious.kavin.rocks"

    %{"video_id" => video_id} = Regex.named_captures(@providers[:youtube], url)

    api_url =
      "#{invidious_instance}/api/v1/videos/#{video_id}?fields=adaptiveFormats,title,videoThumbnails"

    %HTTPoison.Response{body: body, status_code: 200} = HTTPoison.get!(api_url)
    info_json = Jason.decode!(body)

    urls =
      for %{"type" => mime_type} = format <- info_json["adaptiveFormats"], mime_type =~ "audio" do
        [url: format["url"], mime_type: mime_type, quality: format["quality"], is_hls: false]
      end

    artwork_url =
      info_json["videoThumbnails"]
      |> Enum.find_value(fn %{"quality" => quality, "url" => url} ->
        if quality == "high", do: url
      end)

    title = info_json["title"]

    [direct_urls: urls, artwork_url: artwork_url, song_title: title]
  end

  def fetch_urls_and_metadata(%Song{url: _url}, :soundcloud) do
    raise "TODO"
  end

  # def get_song_by(%{"url" => url}) do
  #   Repo.get_by(Song, url: url)
  # end
  # def get_song_by!(%{"url" => url}) do
  #   Repo.get_by!(Song, url: url)
  # end

  def create_or_get_song(%{"url" => url} = attrs \\ %{}) do
    maybe_song = Repo.get_by(Song, url: url)
    if maybe_song == nil do
        create_song(attrs)
    else
      {:ok, maybe_song}
    end
  end
end
