defmodule FrickDmca.Repo.Migrations.AddStreamersTable do
  use Ecto.Migration

  def change do
    create table(:streamer_info) do
      add :user_id, references(:users)
      add :song_id, references(:songs, on_delete: :nothing)
      add :song_progress, :bigint, default: 0
    end

    alter table(:users) do
      add :streamer_info_id, references(:streamer_info, on_delete: :delete_all)
    end

    alter table(:songs) do
      add :streamer, references(:streamer_info, on_delete: :nilify_all)
    end

    create unique_index(:streamer_info, [:song_id])
    create index(:songs, [:streamer])
  end
end
