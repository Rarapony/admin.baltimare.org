defmodule Baltimarecms.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :first, :integer
    field :time, :integer
    field :username, :string
    field :UUID, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:UUID, :username, :time, :first])
    |> validate_required([:UUID, :username, :time, :first])
  end
end
