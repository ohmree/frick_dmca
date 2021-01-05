defmodule FrickDmca.Repo.Migrations.AddUserPicture do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :picture_url, :string, null: false
    end
  end
end
