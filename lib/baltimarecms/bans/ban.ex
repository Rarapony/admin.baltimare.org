defmodule Baltimarecms.Bans.Ban do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bans" do
    field :active, :boolean, default: false
    field :reason, :string
    field :time, :integer
    field :until, :integer
    field :uuid, :string
    field :janny, :string
    field :rule, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(ban, attrs) do
    ban
    |> cast(attrs, [:uuid, :janny, :until, :time, :rule, :reason, :active])
    |> validate_required([:uuid, :janny, :until, :time, :rule, :reason, :active])
  end
end
