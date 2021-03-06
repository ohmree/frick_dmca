defmodule FrickDmca.Songs.Song do
  use Ecto.Schema
  import Ecto.Changeset
  alias FrickDmca.Users.StreamerInfo

  schema "songs" do
    field :url, :string
    has_many :streamer_info, StreamerInfo

    timestamps()
  end

  @doc false
  def changeset(song, attrs) do
    song
    |> cast(attrs, [:url])
    |> validate_required([:url])
    |> unique_constraint(:url)
    |> FrickDmca.Songs.validate_providers(attrs)
  end
end
