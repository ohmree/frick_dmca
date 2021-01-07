defmodule FrickDmca.Songs.Song do
  use Ecto.Schema
  import Ecto.Changeset
  alias FrickDmca.Users.User

  schema "songs" do
    field :url, :string
    has_many :users, User

    timestamps()
  end

  @doc false
  def changeset(song, attrs) do
    song
    |> cast(attrs, [:url])
    |> validate_required([:url])
  end
end
