defmodule FrickDmca.Repo.Migrations.AddUniqueSongIndex do
  use Ecto.Migration

  def change do
    create unique_index(:users, [:song_id])
  end
end
