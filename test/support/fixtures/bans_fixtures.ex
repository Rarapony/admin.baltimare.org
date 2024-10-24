defmodule Baltimarecms.BansFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Baltimarecms.Bans` context.
  """

  @doc """
  Generate a ban.
  """
  def ban_fixture(attrs \\ %{}) do
    {:ok, ban} =
      attrs
      |> Enum.into(%{
        active: true,
        janny: "some janny",
        reason: "some reason",
        rule: 42,
        time: 42,
        until: 42,
        uuid: "some uuid"
      })
      |> Baltimarecms.Bans.create_ban()

    ban
  end
end
