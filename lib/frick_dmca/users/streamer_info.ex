defmodule FrickDmca.Users.StreamerInfo do
  use Ecto.Schema
  alias FrickDmca.Users.User

  schema "streamer_info" do
    belongs_to :user, User
    field :song_progress, :integer, default: 0
    belongs_to :song, FrickDmca.Songs.Song
  end

  def changeset(info_or_changeset, attrs) do
    info_or_changeset
    |> Ecto.Changeset.cast(attrs, [])
    |> Ecto.Changeset.cast_assoc(:user)
  end
end
