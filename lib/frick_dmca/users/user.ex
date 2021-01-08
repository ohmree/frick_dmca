defmodule FrickDmca.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema, user_id_field: :username
  use PowAssent.Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string, null: false
    field :picture_url, :string, null: false
    field :role, :string, null: false, default: "user"
    field :song_progress, :integer, default: 0
    belongs_to :song, Song

    pow_user_fields()

    timestamps()
  end

  def changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> pow_changeset(attrs)
    |> validate_username(attrs)
    |> validate_picture_url(attrs)
  end

  def user_identity_changeset(user_or_changeset, user_identity, %{"username" => username, "picture" => picture_url} = attrs, user_id_attrs) do
    user_or_changeset
    |> change()
    |> put_change(:picture_url, picture_url)
    |> put_change(:username, username)
    |> validate_username(attrs)
    |> validate_picture_url(attrs)
    |> pow_assent_user_identity_changeset(user_identity, attrs, user_id_attrs)
  end

  defp validate_username(user_or_changeset, attrs) do
    user_or_changeset
    |> cast(attrs, [:username])
    |> validate_required([:username])
  end

  defp validate_picture_url(user_or_changeset, attrs) do
    user_or_changeset
    |> cast(attrs, [:picture_url])
    |> validate_required([:picture_url])
  end

  @spec changeset_role(Ecto.Schema.t() | Ecto.Changeset.t(), map()) :: Ecto.Changeset.t()
  def changeset_role(user_or_changeset, attrs) do
    user_or_changeset
    |> cast(attrs, [:role])
    |> validate_inclusion(:role, ~w(user admin))
  end
end
