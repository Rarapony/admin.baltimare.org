defmodule Baltimarecms.AnnouncementsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Baltimarecms.Announcements` context.
  """

  @doc """
  Generate a announcement.
  """
  def announcement_fixture(attrs \\ %{}) do
    {:ok, announcement} =
      attrs
      |> Enum.into(%{
        announcer: "some announcer",
        content: "some content",
        title: "some title"
      })
      |> Baltimarecms.Announcements.create_announcement()

    announcement
  end
end
