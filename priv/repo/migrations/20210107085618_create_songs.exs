defmodule FrickDmca.Repo.Migrations.CreateSongs do
  use Ecto.Migration

  def change do
    create table(:songs) do
      add :url, :string
      add :user, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:songs, [:user])
  end
end
