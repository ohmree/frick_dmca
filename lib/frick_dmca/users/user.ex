defmodule FrickDmca.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema, user_id_field: :preferred_username
  use PowAssent.Ecto.Schema

  schema "users" do
    field :username, :string, null: false
    field :role, :string, null: false, default: "user"

    pow_user_fields()

    timestamps()
  end
  def changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> pow_changeset(attrs)
    |> validate_username(attrs)
  end

  def user_identity_changeset(user_or_changeset, user_identity, attrs, user_id_attrs) do
    user_or_changeset
    |> put_username_from_uid(attrs)
    |> pow_assent_user_identity_changeset(user_identity, attrs, user_id_attrs)
    |> validate_username(attrs)
  end

  defp validate_username(user_or_changeset, attrs) do
    user_or_changeset
    |> Ecto.Changeset.cast(attrs, [:username])
    |> Ecto.Changeset.validate_required([:username])
  end

  defp put_username_from_uid(changeset, %{"uid" => username}), do: Ecto.Changeset.put_change(changeset, :username, username)
  defp put_username_from_uid(changeset, _attrs), do: changeset

  @spec changeset_role(Ecto.Schema.t() | Ecto.Changeset.t(), map()) :: Ecto.Changeset.t()
  def changeset_role(user_or_changeset, attrs) do
    user_or_changeset
    |> Ecto.Changeset.cast(attrs, [:role])
    |> Ecto.Changeset.validate_inclusion(:role, ~w(user admin))
  end
end
