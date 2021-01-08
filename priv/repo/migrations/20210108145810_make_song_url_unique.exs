defmodule FrickDmca.Repo.Migrations.MakeSongUrlUnique do
  use Ecto.Migration

  def change do
    create unique_index(:songs, [:url])
  end
end
