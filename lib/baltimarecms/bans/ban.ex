defmodule Baltimarecms.Bans.Ban do
  use Ecto.Schema
  import Ecto.Changeset
  alias Baltimarecms.Accounts.User

  schema "bans" do
    field :active, :boolean, default: true
    field :reason, :string
    field :time, :integer
    field :until, :integer
    # field :uuid, :string
    belongs_to(:user, User, foreign_key: :uuid, references: :uuid, type: :string)
    field :janny, :string
    field :rule, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(ban, attrs) do
    ban
    |> cast(attrs, [:uuid, :janny, :until, :time, :rule, :reason, :active])
    |> validate_required([:uuid, :janny, :time, :rule, :reason, :active])
  end
end
