defmodule Baltimarecms.Announcements.Announcement do
  use Ecto.Schema
  import Ecto.Changeset

  schema "announcements" do
    field :title, :string
    field :content, :string
    field :announcer, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(announcement, attrs) do
    announcement
    |> cast(attrs, [:title, :content, :announcer])
    |> validate_required([:title, :content, :announcer])
  end
end
