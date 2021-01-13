defmodule FrickDmca.Repo.Migrations.CreateSongs do
  use Ecto.Migration

  def change do
    create table(:songs) do
      add :url, :string

      timestamps()
    end
  end
end
