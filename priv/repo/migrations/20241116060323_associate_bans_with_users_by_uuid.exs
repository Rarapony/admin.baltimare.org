defmodule Baltimarecms.Repo.Migrations.AssociateBansWithUsersByUuid do
  use Ecto.Migration

  def change do
    alter table(:bans) do
      # The magic is here!
      modify :uuid, references(:users, column: :uuid, type: :string), on_delete: :delete_all
    end
  end
end
