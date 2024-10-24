defmodule Baltimarecms.Repo.Migrations.CreateBans do
  use Ecto.Migration

  def change do
    create table(:bans) do
      add :uuid, :string
      add :janny, :string
      add :until, :integer
      add :time, :integer
      add :rule, :integer
      add :reason, :string
      add :active, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
