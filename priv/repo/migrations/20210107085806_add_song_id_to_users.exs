defmodule FrickDmca.Repo.Migrations.AddSongIdToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :song_id, references(:songs, on_delete: :nothing)
      add :song_progress, :bigint, default: 0
    end
  end
end
