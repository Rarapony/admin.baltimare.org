defmodule Baltimarecms.Repo.Migrations.CreateAnnouncements do
  use Ecto.Migration

  def change do
    create table(:announcements) do
      add :title, :string
      add :content, :text
      add :announcer, :string

      timestamps(type: :utc_datetime)
    end
  end
end
